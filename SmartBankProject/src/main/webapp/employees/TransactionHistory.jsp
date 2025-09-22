<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../dbs.jsp" %>
<%
    // ✅ Validate account number
    String accNo = request.getParameter("accountNumber");
    if(accNo == null || accNo.trim().isEmpty()){
        out.println("<div class='alert alert-danger text-center my-4'>No account number provided!</div>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; padding: 40px; }
        .table thead { background-color: #0d6efd; color: #fff; }
        .table tbody tr:hover { background-color: #e9f5ff; }
        h3 { margin-bottom: 30px; }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center">Transaction History - <span class="text-primary"><%= accNo %></span></h3>

    <div class="table-responsive">
    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = getConnection();
            ps = con.prepareStatement("SELECT * FROM transactions WHERE AccountNumber=? ORDER BY Timestamp DESC");
            ps.setString(1, accNo);
            rs = ps.executeQuery();

            if(!rs.isBeforeFirst()){ // No records
    %>
        <div class="alert alert-info text-center">No transactions found for this account.</div>
    <%
            } else {
    %>
        <table class="table table-bordered table-striped align-middle text-center">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Type</th>
                    <th>Recipient</th>
                    <th>Amount</th>
                    <th>Description</th>
                    <th>Timestamp</th>
                </tr>
            </thead>
            <tbody>
    <%
                while(rs.next()){
    %>
                <tr>
                    <td><%= rs.getInt("TransactionID") %></td>
                    <td><%= rs.getString("Type") %></td>
                    <td><%= rs.getString("RecipientAccount") != null ? rs.getString("RecipientAccount") : "-" %></td>
                    <td>₹ <%= rs.getDouble("Amount") %></td>
                    <td><%= rs.getString("Description") != null ? rs.getString("Description") : "-" %></td>
                    <td><%= rs.getTimestamp("Timestamp") %></td>
                </tr>
    <%
                }
    %>
            </tbody>
        </table>
    <%
            }
        } catch(Exception e){
            out.println("<div class='alert alert-danger text-center'>Error: "+e.getMessage()+"</div>");
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception ex) {}
            if(ps != null) try { ps.close(); } catch(Exception ex) {}
            if(con != null) try { con.close(); } catch(Exception ex) {}
        }
    %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
