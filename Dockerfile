# ✅ Use official Tomcat image with JDK 21
FROM tomcat:9.0-jdk21

# ✅ Remove default ROOT webapp (not SmartBank.war)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# ✅ Copy your WAR file and rename as ROOT.war (so it opens on '/')
COPY target/SmartBank.war /usr/local/tomcat/webapps/ROOT.war

# ✅ Expose the Render port (Render injects $PORT)
ENV PORT 10000
EXPOSE 10000

# ✅ Dynamically replace 8080 in server.xml with Render port
CMD sed -i "s/8080/${PORT}/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
