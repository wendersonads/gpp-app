FROM openjdk:8u151-jdk-alpine
RUN apk add -U tzdata
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN apk del -U tzdata

RUN mkdir /app

COPY auth-server.jar /app/auth-server.jar

EXPOSE 8082

CMD ["java", "-Dspring.profiles.active=prod", "-Duser.timezone=America/Sao_Paulo", "-Dloader.path=.,/app/config", "-jar", "/app/auth-server.jar"]
