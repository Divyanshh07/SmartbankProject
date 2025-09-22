<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../dbs.jsp" %>

<%
    String accNo = request.getParameter("accountNumber");
    String type = request.getParameter("type");
    String recipient = request.getParameter("recipientAccount");
    double amount = Double.parseDouble(request.getParameter("amount"));

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String message = "";

    try {
        con = getConnection();
        con.setAutoCommit(false);

        // ✅ Check balance for withdrawal/transfer
        double currentBalance = 0;
        ps = con.prepareStatement("SELECT Balance FROM accounts WHERE AccountNumber=?");
        ps.setString(1, accNo);
        rs = ps.executeQuery();
        if (rs.next()) currentBalance = rs.getDouble(1);

        if ("Deposit".equals(type)) {
            ps = con.prepareStatement("UPDATE accounts SET Balance = Balance + ? WHERE AccountNumber=?");
            ps.setDouble(1, amount);
            ps.setString(2, accNo);
            ps.executeUpdate();
            message = "Deposit of ₹" + amount + " successful!";
        }
        else if ("Withdrawal".equals(type)) {
            if (currentBalance >= amount) {
                ps = con.prepareStatement("UPDATE accounts SET Balance = Balance - ? WHERE AccountNumber=?");
                ps.setDouble(1, amount);
                ps.setString(2, accNo);
                ps.executeUpdate();
                message = "Withdrawal of ₹" + amount + " successful!";
            } else {
                message = "Withdrawal failed: Insufficient balance!";
            }
        }
        else if ("Transfer".equals(type)) {
            // check recipient account
            ps = con.prepareStatement("SELECT Balance FROM accounts WHERE AccountNumber=?");
            ps.setString(1, recipient);
            ResultSet rs2 = ps.executeQuery();
            if (!rs2.next()) {
                message = "Transfer failed: Recipient account not found!";
            } else if (currentBalance >= amount) {
                // deduct sender
                ps = con.prepareStatement("UPDATE accounts SET Balance = Balance - ? WHERE AccountNumber=?");
                ps.setDouble(1, amount);
                ps.setString(2, accNo);
                ps.executeUpdate();

                // credit recipient
                ps = con.prepareStatement("UPDATE accounts SET Balance = Balance + ? WHERE AccountNumber=?");
                ps.setDouble(1, amount);
                ps.setString(2, recipient);
                ps.executeUpdate();

                message = "Transfer of ₹" + amount + " to " + recipient + " successful!";
            } else {
                message = "Transfer failed: Insufficient balance!";
            }
        }

        con.commit();
    } catch (Exception e) {
        if (con != null) con.rollback();
        message = "Error: " + e.getMessage();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }

    // ✅ Redirect back with message
    response.sendRedirect("Transactions.jsp?accountNumber=" + accNo + "&msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
