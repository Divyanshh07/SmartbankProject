<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbs.jsp" %>
<%
    String email = request.getParameter("email");
    String userType = request.getParameter("userType");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    // Check if passwords match
    if(email == null || userType == null || newPassword == null || confirmPassword == null) {
        response.sendRedirect("ForgotPassword.jsp?msg=All+fields+are+required");
        return;
    }

    if(!newPassword.equals(confirmPassword)){
        response.sendRedirect("ForgotPassword.jsp?msg=Passwords+do+not+match");
        return;
    }

    try {
        Connection con = getConnection();
        String table = "customer".equals(userType) ? "customers" : "employees";

        PreparedStatement ps = con.prepareStatement(
            "UPDATE " + table + " SET Password=? WHERE Email=?"
        );
        ps.setString(1, newPassword);
        ps.setString(2, email);

        int updated = ps.executeUpdate();
        ps.close(); con.close();

        if(updated > 0){
            response.sendRedirect("Login.jsp?msg=Password+reset+successfully");
        } else {
            response.sendRedirect("ForgotPassword.jsp?msg=No+user+found+with+this+email");
        }

    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("ForgotPassword.jsp?msg=Error+resetting+password");
    }
%>
