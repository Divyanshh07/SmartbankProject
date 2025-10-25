# Use official Tomcat image
FROM tomcat:9.0-jdk21

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/SmartBank.war

# Copy your WAR file as ROOT.war
COPY SmartBank.war /usr/local/tomcat/webapps/SmartBank.war

# Expose port (Render will use $PORT)
ENV PORT 10000
EXPOSE $PORT

# Use Render-assigned port
CMD sed -i "s/8080/${PORT}/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
