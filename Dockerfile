# Stage 1: Build the Java application using Maven
FROM maven:3.8-openjdk-11 AS stage1

# Set working directory for source code
WORKDIR /usr/src/app

# Copy the pom.xml and source code into the container
COPY pom.xml /usr/src/app/
COPY ./src /usr/src/app/src/

# Run Maven to build the project and package it into a .war file
RUN mvn -f /usr/src/app/pom.xml clean package

# Debug: List contents of target directory to confirm .war file is created
RUN ls -l /usr/src/app/target

# Stage 2: Set up Tomcat to serve the app
FROM tomcat:9-jdk11-openjdk

# Remove the default ROOT application
RUN rm -fr /usr/local/tomcat/webapps/ROOT

# Copy the .war file from the build stage into Tomcat's webapps directory
COPY --from=stage1 /usr/src/app/target/demoapp1.war /usr/local/tomcat/webapps/ROOT.war

# Expose the Tomcat port (default 8080)
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]
