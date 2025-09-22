<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../dbs.jsp" %>
<%
    String role = (String) session.getAttribute("role");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    String interestRate = request.getParameter("interestRate");
    String withdrawalLimit = request.getParameter("withdrawalLimit");
    String depositLimit = request.getParameter("depositLimit");
    String serviceCharge = request.getParameter("serviceCharge");

    try{
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement(
            "UPDATE bank_policy SET InterestRate=?, DailyWithdrawalLimit=?, DailyDepositLimit=?, ServiceCharge=? WHERE ID=1"
        );
        ps.setDouble(1, Double.parseDouble(interestRate));
        ps.setDouble(2, Double.parseDouble(withdrawalLimit));
        ps.setDouble(3, Double.parseDouble(depositLimit));
        ps.setDouble(4, Double.parseDouble(serviceCharge));
        ps.executeUpdate();
        ps.close(); con.close();

        response.sendRedirect("Setting.jsp?msg=Bank+policies+updated");
    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("Setting.jsp?msg=Error+updating+policies");
    }
%>
