# Stage 1: Create a custom Java Image using JLink.
# Currently Services itself are not modular. Something we can further optimise in future.
FROM amazoncorretto:20.0.2-alpine as customJRECreateStage
ARG TARGETPLATFORM
MAINTAINER Sachin Goyal <sachin.goyal.se@gmail.com>
VOLUME /opt

RUN jlink \
  --no-header-files \
  --no-man-pages \
  --compress=2 \
  --add-modules java.base,java.logging,java.naming,java.desktop,java.management,java.security.jgss,java.instrument,java.sql \
  --output /opt/custom/java

# Stage 2: Use the custom Java image
# Have to deploy some dependencies as per first stage's base image's Dockerfile (https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/15/jdk/alpine/Dockerfile.hotspot.releases.full) to run Java
FROM alpine:3.18
ARG TARGETPLATFORM
MAINTAINER Sachin Goyal <sachin.goyal.se@gmail.com>
VOLUME /opt

ARG version=20.0.2.9.1

# Please note that the THIRD-PARTY-LICENSE could be out of date if the base image has been updated recently.
# The Corretto team will update this file but you may see a few days' delay.
RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-20=$version-r0 && \
    rm -rf /usr/lib/jvm/java-20-amazon-corretto

ENV LANG C.UTF-8

COPY --from=customJRECreateStage /opt/custom/java /opt/custom/java

ENV JAVA_HOME=/opt/custom/java \
    PATH="/opt/custom/java/bin:$PATH"

