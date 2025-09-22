<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*, java.sql.*" %>
<%@ page import="conn.Conn" %>
<%
    // ✅ Ensure session is active & role = customer
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("role") == null || !"customer".equals(sess.getAttribute("role"))) {
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    String email = (String) sess.getAttribute("email");
    String accountNumber = null;

    try {
        Connection con = Conn.getCon();

        // Check if account exists first
        PreparedStatement psAcc = con.prepareStatement(
            "SELECT AccountNumber FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID WHERE c.Email=?"
        );
        psAcc.setString(1, email);
        ResultSet rsAcc = psAcc.executeQuery();
        if (rsAcc.next()) {
            accountNumber = rsAcc.getString("AccountNumber");
        }
        rsAcc.close();
        psAcc.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - SmartBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f8f9fa; }
        .card:hover { transform: translateY(-3px); transition: 0.3s; }
        .dashboard-title { font-weight: 600; margin-bottom: 20px; }
        .navbar-brand { font-weight: bold; font-size: 1.4rem; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">SmartBank</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link " href="../Home.jsp"><i class="bi bi-house-door"></i> Home</a></li>
        <li class="nav-item"><a class="nav-link" href="Profile.jsp"><i class="bi bi-person-circle"></i> Profile</a></li>
        <li class="nav-item"><a class="nav-link" href="../Login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
    <div class="alert alert-info">
        <h4>Welcome, <%= email %> 👋</h4>
        <% if (accountNumber != null) { %>
            <p><strong>Account Number:</strong> <%= accountNumber %></p>
        <% } else { %>
            <p class="text-warning"><em>No account found. Please open an account first.</em></p>
        <% } %>
    </div>

    <% if (accountNumber != null) { %>

    <!-- Quick Action Cards -->
    <div class="row">
        <div class="col-md-4 col-sm-6 mb-3">
            <div class="card shadow h-100 text-center">
                <div class="card-body">
                    <h5 class="card-title">💰 View Balance</h5>
                    <p class="card-text">Check your current account balance securely.</p>
                    <a href="ViewBalance.jsp" class="btn btn-primary btn-sm">View Balance</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-sm-6 mb-3">
            <div class="card shadow h-100 text-center">
                <div class="card-body">
                    <h5 class="card-title">💵 Deposit</h5>
                    <p class="card-text">Add funds to your account securely.</p>
                    <a href="Deposit.jsp" class="btn btn-success btn-sm">Deposit</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-sm-6 mb-3">
            <div class="card shadow h-100 text-center">
                <div class="card-body">
                    <h5 class="card-title">🏧 Withdrawal</h5>
                    <p class="card-text">Withdraw money from your account easily.</p>
                    <a href="Withdrawal.jsp" class="btn btn-warning btn-sm">Withdraw</a>
                </div>
            </div>
        </div>
        
          <div class="col-md-4 col-sm-6 mb-3">
            <div class="card shadow h-100 text-center">
                <div class="card-body">
                    <h5 class="card-title">💳 Transfer Money</h5>
                    <p class="card-text">Send money to other accounts instantly.</p>
                    <a href="Transfer.jsp" class="btn btn-success btn-sm">Transfer</a>
                </div>
            </div>
        </div>

    <!-- Second Row: Transactions, Loan, Profile -->
        <div class="col-md-4 col-sm-6 mb-3">
            <div class="card shadow h-100 text-center">
                <div class="card-body">
                    <h5 class="card-title">📑 Transactions</h5>
                    <p class="card-text">View all your transaction history.</p>
                    <a href="Transaction.jsp" class="btn btn-warning btn-sm">View</a>
                </div>
            </div>
        </div>

        <div class="col-md-4 col-sm-6 mb-3">
            <div class="card shadow h-100 text-center">
                <div class="card-body">
                    <h5 class="card-title">🏦 Apply for Loan</h5>
                    <p class="card-text">Need financial help? Apply for a loan online.</p>
                    <a href="LoanApplication.jsp" class="btn btn-info btn-sm">Apply Now</a>
                </div>
            </div>
        </div>

    <% } %> <!-- End dashboard -->

</div>

<!-- Footer -->
<footer class="bg-dark text-white text-center p-3 mt-5">
    &copy; 2025 SmartBank. All Rights Reserved.
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
