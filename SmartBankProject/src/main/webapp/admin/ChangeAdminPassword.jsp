<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../dbs.jsp" %>
<%
    // Admin session check
    String role = (String) session.getAttribute("role");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    // Get session email (unique identifier)
    String sessionEmail = (String) session.getAttribute("email");

    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    if(!newPassword.equals(confirmPassword)){
        response.sendRedirect("Setting.jsp?msg=Password+does+not+match");
        return;
    }

    try {
        Connection con = getConnection();

        // Check current password
        PreparedStatement ps = con.prepareStatement(
            "SELECT Password FROM admin WHERE Email=?"
        );
        ps.setString(1, sessionEmail);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            String dbPass = rs.getString("Password");
            if(!dbPass.equals(currentPassword)){
                rs.close(); ps.close(); con.close();
                response.sendRedirect("Setting.jsp?msg=Current+password+incorrect");
                return;
            }
        } else {
            rs.close(); ps.close(); con.close();
            response.sendRedirect("Setting.jsp?msg=Admin+not+found");
            return;
        }
        rs.close(); ps.close();

        // Update password
        ps = con.prepareStatement(
            "UPDATE admin SET Password=? WHERE Email=?"
        );
        ps.setString(1, newPassword);
        ps.setString(2, sessionEmail);
        ps.executeUpdate();
        ps.close(); con.close();

        response.sendRedirect("Setting.jsp?msg=Password+updated+successfully");

    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("Setting.jsp?msg=Error+updating+password");
    }
%>
