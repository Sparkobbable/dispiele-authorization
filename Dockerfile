FROM maven:3.8.4-openjdk-17 AS MAVEN_BUILD
COPY pom.xml /build/
COPY src /build/src/
WORKDIR /build/
RUN mvn -Dmaven.test.skip=true package

FROM openjdk:17-jdk
ARG JAVA_OPTS
ARG STAGE
ARG OAUTH_CLIENT_ID
ARG OAUTH_CLIENT_SECRET
COPY --from=MAVEN_BUILD ./build/target/*.jar /app/dispiele-authorization.jar
ENV JAVA_OPTS=$JAVA_OPTS
ENV STAGE=$STAGE
ENV OAUTH_CLIENT_ID=$OAUTH_CLIENT_ID
ENV OAUTH_CLIENT_SECRET=$OAUTH_CLIENT_SECRET
EXPOSE 8080
ENTRYPOINT exec java $JAVA_OPTS -Dspring.profiles.active=$STAGE -Doauth.admin-site.clientid=$OAUTH_CLIENT_ID -Doauth.admin-site.clientsecret=$OAUTH_CLIENT_SECRET -jar /app/dispiele-authorization.jar