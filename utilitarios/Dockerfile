# Use an official openjdk runtime as a parent image
FROM openjdk:17-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file into the container
COPY authentication_api-0.0.1-SNAPSHOT.jar app.jar

# Copy the SSL/TLS certificate and private key into the container
COPY apache-selfsigned.crt /etc/ssl/certs/
COPY apache-selfsigned.p12 /etc/ssl/certs/
COPY apache-selfsigned.key /etc/ssl/private/

# Set the appropriate permissions for the certificate and private key files
RUN chmod 644 /etc/ssl/certs/apache-selfsigned.crt
RUN chmod 600 /etc/ssl/private/apache-selfsigned.key

# Expose the desired port for the Spring Boot application
EXPOSE 8081

# Run the application when the container starts
CMD ["java", "-jar", "app.jar"]
