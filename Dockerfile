FROM tomcat:latest
COPY /target/studentapp-2.5-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8081
CMD ["catalina.sh", "run"]
