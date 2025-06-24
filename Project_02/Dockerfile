FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y wget gnupg curl software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    mkdir -p /opt/jenkins

COPY jenkins.war /opt/jenkins/jenkins.war

EXPOSE 8080

CMD ["java", "-jar", "/opt/jenkins/jenkins.war"]
