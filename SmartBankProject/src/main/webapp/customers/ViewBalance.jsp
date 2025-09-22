<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, conn.Conn" %>
<%
    // ✅ Ensure session is active & role = customer
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("role") == null || !"customer".equals(sess.getAttribute("role"))) {
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    String email = (String) sess.getAttribute("email");
    String accountNumber = null;
    double balance = 0.0;
    String message = "";

    try {
        Connection con = Conn.getCon();

        // Get account number and balance
        PreparedStatement ps = con.prepareStatement(
            "SELECT a.AccountNumber, a.Balance FROM accounts a " +
            "JOIN customers c ON a.CustomerID = c.CustomerID " +
            "WHERE c.Email=?"
        );
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            accountNumber = rs.getString("AccountNumber");
            balance = rs.getDouble("Balance");
        } else {
            message = "No account found. Please contact bank staff to open an account.";
        }

        rs.close();
        ps.close();
        con.close();
    } catch(Exception e) {
        message = "Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Account Balance - SmartBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f8f9fa; }
        .card { max-width: 500px; margin: 50px auto; }
        .balance { font-size: 2rem; font-weight: bold; color: #198754; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="CustomerDashboard.jsp">SmartBank</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="CustomerDashboard.jsp"><i class="bi bi-house-door"></i> Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="Profile.jsp"><i class="bi bi-person-circle"></i> Profile</a></li>
        <li class="nav-item"><a class="nav-link" href="../Login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container">
    <div class="card shadow text-center p-4">
        <h3 class="card-title mb-3">💰 Account Balance</h3>

        <% if(accountNumber != null) { %>
            <p><strong>Account Number:</strong> <%= accountNumber %></p>
            <p class="balance">₹ <%= String.format("%.2f", balance) %></p>
        <% } else { %>
            <p class="text-danger"><%= message %></p>
        <% } %>

        <a href="CustomerDashboard.jsp" class="btn btn-primary mt-3">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
