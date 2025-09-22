<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, conn.Conn" %>
<%
    // Session check
    HttpSession sess = request.getSession(false);
    if(sess == null || !"customer".equals(sess.getAttribute("role"))){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    String email = (String) sess.getAttribute("email");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Transaction History - SmartBank</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color:#f8f9fa; }
    .table thead { background-color: #0d6efd; color: white; }
    .table tbody tr:nth-child(even) { background-color: #e9ecef; }
</style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="CustomerDashboard.jsp">SmartBank</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="CustomerDashboard.jsp">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="Balance.jsp">Balance</a></li>
        <li class="nav-item"><a class="nav-link active" href="Transactions.jsp">Transactions</a></li>
        <li class="nav-item"><a class="nav-link" href="../Login.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
    <h3 class="mb-3 text-center">📑 Transaction History</h3>

    <div class="card shadow p-3">
        <%
            try {
                Connection con = Conn.getCon();

                // Get all accounts for this customer
                PreparedStatement psAcc = con.prepareStatement(
                    "SELECT TRIM(a.AccountNumber) AS AccountNumber FROM accounts a JOIN customers c ON a.CustomerID=c.CustomerID WHERE c.Email=?"
                );
                psAcc.setString(1, email);
                ResultSet rsAcc = psAcc.executeQuery();

                List<String> accountNumbers = new ArrayList<>();
                while(rsAcc.next()) {
                    accountNumbers.add(rsAcc.getString("AccountNumber"));
                }
                rsAcc.close();
                psAcc.close();

                if(accountNumbers.isEmpty()) {
        %>
                    <p class="text-danger">❌ No account found for your email. Please contact the bank.</p>
        <%
                } else {
                    // Build dynamic query for multiple accounts
                    StringBuilder sql = new StringBuilder(
                        "SELECT TransactionID,AccountNumber,COALESCE(RecipientAccount,'-') AS RecipientAccount,Type, Amount, Timestamp , Description " +
                        "FROM transactions WHERE "
                    );

                    for(int i=0; i<accountNumbers.size(); i++) {
                        if(i > 0) sql.append(" OR ");
                        sql.append("AccountNumber=? OR RecipientAccount=?");
                    }
                    sql.append(" ORDER BY Timestamp DESC");

                    PreparedStatement psTrans = con.prepareStatement(sql.toString());
                    int idx = 1;
                    for(String acc : accountNumbers) {
                        psTrans.setString(idx++, acc);
                        psTrans.setString(idx++, acc);
                    }

                    ResultSet rsTrans = psTrans.executeQuery();
        %>

        <table class="table table-bordered table-hover text-center align-middle">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Transaction ID</th>
                    <th>Type</th>
                    <th>Amount (₹)</th>
                    <th>Account Number</th>
                    <th>Recipient Account</th>
                    <th>Description</th>
                    <th>Date & Time</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int count = 1;
                    boolean hasTransactions = false;
                    while(rsTrans.next()){
                        hasTransactions = true;
                %>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= rsTrans.getInt("TransactionID") %></td>
                    <td><%= rsTrans.getString("Type") %></td>
                    <td><%= String.format("%.2f", rsTrans.getDouble("Amount")) %></td>
                    <td><%= rsTrans.getString("AccountNumber") %></td>
                    <td><%= rsTrans.getString("RecipientAccount") %></td>
                    <td><%= rsTrans.getString("Description") != null ? rsTrans.getString("Description") : "-" %></td>
                    <td><%= rsTrans.getTimestamp("Timestamp") %></td>
                </tr>
                <% } %>
                <%
                    if(!hasTransactions){
                %>
                <tr>
                    <td colspan="8" class="text-danger">❌ No transactions found for your account.</td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <%
                    rsTrans.close();
                    psTrans.close();
                }

                con.close();
            } catch(Exception e) {
        %>
        <p class="text-danger">❌ Error: <%= e.getMessage() %></p>
        <% } %>
    </div>

    <a href="CustomerDashboard.jsp" class="btn btn-primary w-100 mt-3">Back to Dashboard</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
