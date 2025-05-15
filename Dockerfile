# Stage 1: Build the Maven project
# Use an official Maven image with a specific JDK version (Temurin/Adoptium is a good choice)
# Using an Alpine variant for the build stage can also keep intermediate layers smaller.
FROM maven:3.9.7-eclipse-temurin-17-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml first to leverage Docker's layer caching for dependencies
COPY pom.xml .

# Download all dependencies. If pom.xml hasn't changed, this layer will be cached.
RUN mvn dependency:go-offline -B

# Copy the rest of the source code
COPY src ./src

# Package the application (this will also run tests by default)
# The -DskipTests flag can be added if tests are extensively run in a previous CI stage,
# but it's generally good to run them here too to ensure the artifact is sound.
RUN mvn clean package -B

# Stage 2: Create the final lightweight runtime image
# Use an Alpine base with JRE for a smaller footprint
FROM eclipse-temurin:17-jre-alpine

# Set the working directory in the container
WORKDIR /app

# Argument to specify the JAR file name (can be overridden at build time if needed)
ARG JAR_FILE_PATH=target/simple-webapp-*.jar

# Copy the JAR from the builder stage to the current stage
# The JAR file is produced in the 'target' directory by Maven.
# Your pom.xml defines artifactId as 'simple-webapp' and version '0.0.1-SNAPSHOT',
# so the JAR will be something like 'simple-webapp-0.0.1-SNAPSHOT.jar'.
# The workflow uploads 'target/*.jar', so we'll use a wildcard here too.
# However, the downloaded artifact in your workflow is placed in './jar-artifact'.
# The Docker build in your workflow runs from the root, so it needs to copy from there.
# This Dockerfile assumes it's being built in a context where the JAR from the
# 'builder' stage is available.
# If building this Dockerfile *outside* the CI job that downloads the artifact,
# the COPY --from=builder is correct.
# If building this Dockerfile *inside* the CI job after downloading the artifact,
# you'd adjust the COPY command in the Docker build step in the YAML.
# For now, this Dockerfile is self-contained for building the JAR.
COPY --from=builder /app/target/simple-webapp-*.jar app.jar

# Expose the port the application runs on (defined in your application.properties)
EXPOSE 8080

# Command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
