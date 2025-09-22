<%@ page import="java.sql.*" %>
<%! 
    public static Connection getConnection() throws Exception {
	String dbURL = "jdbc:mysql://localhost:3306/smartbankdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";

        String dbUser = "root";
        String dbPass = "Mysql@07"; // your DB password
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbURL, dbUser, dbPass);
    }
%>
