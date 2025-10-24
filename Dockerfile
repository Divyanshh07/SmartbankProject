# Use official Tomcat 9 image with JDK 21
FROM tomcat:9.0-jdk21

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file to Tomcat webapps as ROOT
COPY SmartBank.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (Render will map $PORT)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
