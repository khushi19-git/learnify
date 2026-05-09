# 1. Build stage (Maven se WAR banega)
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# project copy
COPY . .

# WAR build
RUN mvn clean package -DskipTests

# 2. Runtime stage (Tomcat)
FROM tomcat:10.1-jdk17

# default apps remove
RUN rm -rf /usr/local/tomcat/webapps/*

# WAR copy (auto detect)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]