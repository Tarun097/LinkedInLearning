FROM maven:3.5-jdk-8-slim as BUILDER
ARG VERSION=0.0.1-SNAPSHOT
WORKDIR /build/
COPY pom.xml /build/
RUN ["/usr/local/bin/mvn-entrypoint.sh", "mvn", "verify", "clean", "--fail-never"]

COPY src /build/src/

RUN ["mvn", "package", "-DskipTests"]

COPY target/linkedInLearning-${VERSION}.jar target/application.jar

FROM openjdk:11.0.8-jre-slim
WORKDIR /app/

COPY --from=BUILDER /build/target/application.jar /app/
CMD java -jar /app/application.jar