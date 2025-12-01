# Step 1: Build the application with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only pom.xml first (better caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy entire source
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Step 2: Use a smaller runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the jar file to runtime image
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
