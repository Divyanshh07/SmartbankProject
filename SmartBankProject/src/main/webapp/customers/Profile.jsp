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

    // Customer details
    String fullName = "", phone = "", address = "", accountNumber = "";
    double balance = 0.0;
    String message = "";

    try {
        Connection con = Conn.getCon();
        PreparedStatement ps = con.prepareStatement(
            "SELECT c.Name, c.Email, c.Phone, c.Address, a.AccountNumber, a.Balance " +
            "FROM customers c JOIN accounts a ON c.CustomerID = a.CustomerID WHERE c.Email=?"
        );
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            fullName = rs.getString("Name");
            phone = rs.getString("Phone");
            address = rs.getString("Address");
            accountNumber = rs.getString("AccountNumber");
            balance = rs.getDouble("Balance");
        } else {
            message = "❌ No profile found.";
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        message = "❌ Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Profile - SmartBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .profile-card { max-width: 700px; margin: 40px auto; border-radius: 15px; }
        .profile-header { background: #0d6efd; color: white; border-radius: 15px 15px 0 0; padding: 20px; }
        .icon { font-size: 1.4rem; color: #0d6efd; margin-right: 10px; }
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
        <li class="nav-item"><a class="nav-link active" href="CustomerProfile.jsp"><i class="bi bi-person-circle"></i> Profile</a></li>
        <li class="nav-item"><a class="nav-link" href="../Login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container">
    <div class="card shadow profile-card">
        <div class="profile-header text-center">
            <h3><i class="bi bi-person-badge"></i> Customer Profile</h3>
        </div>
        <div class="card-body p-4">
            <% if(message.isEmpty()) { %>
                <p><i class="bi bi-person icon"></i><strong>Name:</strong> <%= fullName %></p>
                <p><i class="bi bi-envelope icon"></i><strong>Email:</strong> <%= email %></p>
                <p><i class="bi bi-telephone icon"></i><strong>Phone:</strong> <%= phone %></p>
                <p><i class="bi bi-geo-alt icon"></i><strong>Address:</strong> <%= address %></p>
                <hr>
                <p><i class="bi bi-credit-card icon"></i><strong>Account Number:</strong> <%= accountNumber %></p>
                <p><i class="bi bi-wallet2 icon"></i><strong>Balance:</strong> ₹ <%= String.format("%.2f", balance) %></p>
            <% } else { %>
                <div class="alert alert-danger"><%= message %></div>
            <% } %>

            <div class="text-center mt-4">
                <a href="CustomerDashboard.jsp" class="btn btn-primary"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
