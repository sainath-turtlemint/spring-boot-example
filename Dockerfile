# FROM amazoncorretto:17-alpine
# MAINTAINER Ram "ram.k@turtlemint.com"
# WORKDIR /usr/src/app
#
# COPY ["build/libs/my-office-service-0.0.1-SNAPSHOT.jar", "/usr/src/app"]
#
# VOLUME [ "./logs" , "/usr/src/app/tmp" ]
#
# EXPOSE 9078
#
# CMD java $JAVA_OPTS -jar my-office-service-0.0.1-SNAPSHOT.jar

ARG BUILD_HOME=/gradle-build

FROM gradle:7.3.2-jdk17 as build-image

ARG BUILD_HOME
ENV APP_HOME=$BUILD_HOME
WORKDIR $APP_HOME

COPY --chown=gradle:gradle build.gradle settings.gradle $APP_HOME/
COPY --chown=gradle:gradle src $APP_HOME/src
#COPY --chown=gradle:gradle config $APP_HOME/config

RUN gradle -x test clean build



FROM amazoncorretto:17-alpine
MAINTAINER Ram "ram.k@turtlemint.com"
WORKDIR /usr/src/app

WORKDIR /usr/src/app
ARG BUILD_HOME
ENV APP_HOME=$BUILD_HOME


COPY --from=build-image $APP_HOME/build/libs/my-office-service-0.0.1-SNAPSHOT.jar .

VOLUME [ "./logs" , "/usr/src/app/tmp" ]

EXPOSE 9078

CMD java $JAVA_OPTS -jar my-office-service-0.0.1-SNAPSHOT.jar