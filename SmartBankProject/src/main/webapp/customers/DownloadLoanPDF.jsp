<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*" %>
<%@ page import="conn.Conn" %>

<%
    String email = (String) session.getAttribute("email");
    String loanIdStr = request.getParameter("loanId");

    if(loanIdStr == null || loanIdStr.trim().isEmpty()){
        out.println("❌ Loan ID missing!");
        return;
    }

    int loanId = 0;
    try {
        loanId = Integer.parseInt(loanIdStr);
    } catch(NumberFormatException e){
        out.println("❌ Invalid Loan ID!");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = Conn.getCon();

        String sql = "SELECT l.LoanID, l.Amount, l.Tenure, l.InterestRate, l.Status, l.EMI, " +
                     "c.Name, c.Email " +
                     "FROM loans l JOIN customers c ON l.CustomerID = c.CustomerID " +
                     "WHERE l.LoanID=? AND c.Email=?";

        ps = con.prepareStatement(sql);
        ps.setInt(1, loanId);
        ps.setString(2, email);
        rs = ps.executeQuery();

        if(rs.next()){
            // Simple line/note output
            out.println("✅ Loan Note: " + rs.getString("Name") + 
                        " has a loan of ₹" + String.format("%.2f", rs.getDouble("Amount")) +
                        " (Loan ID: " + rs.getInt("LoanID") + "), tenure: " + rs.getInt("Tenure") + 
                        " months, interest: " + rs.getDouble("InterestRate") + "%, EMI: ₹" + 
                        String.format("%.2f", rs.getDouble("EMI")) + 
                        ", status: " + rs.getString("Status") + ".");
        } else {
            out.println("❌ Loan not found or unauthorized access!");
        }

    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e){}
        try { if(ps != null) ps.close(); } catch(Exception e){}
        try { if(con != null) con.close(); } catch(Exception e){}
    }
%>
