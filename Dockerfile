FROM tomcat:9
COPY /var/lib/jenkins/workspace/paraloyal/target/studentsnapshot.war /usr/local/tomcat/webapps/
EXPOSE 8081
CMD ["catalina.sh", "run"]
