# Simple Java Web Application

A simple Spring Boot web application for demonstrating CI/CD pipelines with GitHub Actions and Snyk security scanning.

## Project Overview

This is a basic Spring Boot application that:
- Serves a simple web page
- Has a unit test
- Is configured for CI/CD using GitHub Actions
- Includes Snyk security scanning

## Technology Stack

- Java 17
- Spring Boot 3.2.1
- Maven
- Thymeleaf (for HTML templates)
- JUnit 5 (for testing)

## CI/CD Pipeline

The GitHub Actions workflow configured in this project:

1. Builds the application using Maven
2. Runs tests
3. Performs security scanning with Snyk
4. Simulates a deployment (in a real scenario, you would deploy to your target environment)

## Running Locally

Prerequisites:
- Java 17 or higher
- Maven

Steps:
1. Clone this repository
2. Run `mvn clean install`
3. Run `mvn spring-boot:run`
4. Open http://localhost:8080 in your browser

## Setting Up Snyk

To use Snyk in the GitHub Actions workflow:

1. Sign up for a free Snyk account at https://snyk.io/
2. Get your Snyk API token from your account settings
3. Add the token as a GitHub repository secret named `SNYK_TOKEN`

## Project Structure

```
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/webapp/
│   │   │       ├── Application.java
│   │   │       └── HomeController.java
│   │   └── resources/
│   │       ├── static/
│   │       │   └── css/
│   │       │       └── style.css
│   │       ├── templates/
│   │       │   └── home.html
│   │       └── application.properties
│   └── test/
│       └── java/
│           └── com/example/webapp/
│               └── HomeControllerTest.java
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── pom.xml
└── README.md
``` 