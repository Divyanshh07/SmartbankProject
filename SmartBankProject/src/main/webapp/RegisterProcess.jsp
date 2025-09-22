<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="conn.Conn"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Register</title>
</head>
<body>
<%
String name = request.getParameter("name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String extra = request.getParameter("extra");  // address for customer, department for employee
String password = request.getParameter("password");
String register = request.getParameter("register"); // customer / employee

int i = 0;

Connection db = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    db = Conn.getCon();

    // ✅ Check if email already exists in customers or employees
    String checkQuery = "SELECT COUNT(*) FROM customers WHERE Email=? UNION ALL SELECT COUNT(*) FROM employees WHERE Email=?";
    ps = db.prepareStatement(checkQuery);
    ps.setString(1, email);
    ps.setString(2, email);
    rs = ps.executeQuery();

    int totalExists = 0;
    while(rs.next()){
        totalExists += rs.getInt(1);
    }

    if (totalExists > 0) {
        // Email already exists
        response.sendRedirect("Register.jsp?msg=invalid");
    } else {
        if("customer".equals(register)){
            String query = "INSERT INTO customers(Name,Email,Phone,Address,Password) VALUES (?,?,?,?,?)";
            ps = db.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, extra);   // address
            ps.setString(5, password);
        } else if("employee".equals(register)){
            String query = "INSERT INTO employees(Name,Email,Phone,Role,Password) VALUES (?,?,?,?,?)";
            ps = db.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, extra);   // department
            ps.setString(5, password);
        }

        i = ps.executeUpdate();

        if (i > 0) {
            response.sendRedirect("Login.jsp?msg=success");
        } else {
            response.sendRedirect("Register.jsp?msg=failed");
        }
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("Register.jsp?msg=error");
} finally {
    // ✅ Close resources
    if (rs != null) try { rs.close(); } catch (Exception ex) {}
    if (ps != null) try { ps.close(); } catch (Exception ex) {}
    if (db != null) try { db.close(); } catch (Exception ex) {}
}
%>
</body>
</html>
