# Step 1: Base Image (Tomcat with JDK)
FROM tomcat:9.0-jdk17

# Step 2: Remove default webapps (optional, to use ROOT)
RUN rm -rf /usr/local/tomcat/webapps/*

# Step 3: Copy your Dynamic Web Project contents
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# Step 4: Copy compiled classes (if any)
COPY build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# Step 5: Expose Tomcat default port
EXPOSE 8080

# Step 6: Start
CMD ["catalina.sh", "run"]
