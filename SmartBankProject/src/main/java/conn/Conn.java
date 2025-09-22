package conn;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conn {
    public static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    public static Connection con;
    public static final String URL = "jdbc:mysql://localhost:3306/";
    public static final String USERNAME = "root";
    public static final String PASSWORD = "Mysql@07";
    public static final String DATABASE = "smartbankdb";
    
    public static Connection getCon() {
    	try {
    		Class.forName(DRIVER);
    		con = DriverManager.getConnection(URL+DATABASE,USERNAME,PASSWORD);
    		System.out.println("Connect created");
    	}catch(Exception e) {
    		System.out.println("Database connection failed");
    		e.printStackTrace();
    		return null;
    	}
    	return con;
    }
    
}
