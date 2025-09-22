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

    // Get updated info from form
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    try {
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement(
            "UPDATE admin SET Name=?, Email=?, Phone=? WHERE Email=?"
        );
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setString(4, sessionEmail); // use email as unique identifier

        int updated = ps.executeUpdate();
        ps.close(); con.close();

        if(updated > 0){
            // update session info
            session.setAttribute("username", name);
            session.setAttribute("email", email);
            response.sendRedirect("Setting.jsp?msg=Info+updated+successfully");
        } else {
            response.sendRedirect("Setting.jsp?msg=No+changes+made");
        }
    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("Setting.jsp?msg=Error+updating+info");
    }
%>
