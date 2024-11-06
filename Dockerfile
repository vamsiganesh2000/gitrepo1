FROM maven AS stage1
COPY ./src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml package 

FROM tomcat
RUN rm -fr /usr/local/tomcat/webapps/ROOT
COPY --from=stage1 /usr/src/app/target/demoapp1.war /usr/local/tomcat/webapps/ROOT.war
