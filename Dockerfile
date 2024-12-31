
FROM maven:3.9.4-eclipse-temurin-17 AS builder


WORKDIR /app


COPY pom.xml .
COPY src ./src

RUN mvn package

FROM eclipse-temurin:17-jdk-alpine


WORKDIR /app




COPY --from=builder /app/target/simple-java-maven-project-0.0.1-SNAPSHOT.jar app.jar





ENTRYPOINT ["java", "-jar", "app.jar"]
