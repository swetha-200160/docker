# Multi-stage Dockerfile: build with Maven then copy runnable jar into slim JRE image
FROM maven:3.8.8-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

FROM openjdk:11-jre-slim
WORKDIR /app
# copy jar from build stage (artifactId-version.jar)
COPY --from=build /app/target/simple-java-project-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
