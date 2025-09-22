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

    // Handle withdrawal form submission
    String withdrawStr = request.getParameter("withdrawAmount");
    if (withdrawStr != null && !withdrawStr.isEmpty()) {
        try {
            double withdrawAmount = Double.parseDouble(withdrawStr);
            if (withdrawAmount <= 0) {
                message = "❌ Withdrawal amount must be greater than zero.";
            } else {
                Connection con = Conn.getCon();
                con.setAutoCommit(false); // ✅ Start transaction

                // Get account
                PreparedStatement psAcc = con.prepareStatement(
                    "SELECT AccountNumber, Balance FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID WHERE c.Email=?"
                );
                psAcc.setString(1, email);
                ResultSet rsAcc = psAcc.executeQuery();
                if (rsAcc.next()) {
                    accountNumber = rsAcc.getString("AccountNumber");
                    balance = rsAcc.getDouble("Balance");

                    if (withdrawAmount > balance) {
                        message = "❌ Insufficient balance! Your current balance is ₹ " + String.format("%.2f", balance);
                    } else {
                        // Update balance
                        double newBalance = balance - withdrawAmount;
                        PreparedStatement psUpdate = con.prepareStatement(
                            "UPDATE accounts SET Balance=? WHERE AccountNumber=?"
                        );
                        psUpdate.setDouble(1, newBalance);
                        psUpdate.setString(2, accountNumber);
                        int updated = psUpdate.executeUpdate();

                        if (updated > 0) {
                            // ✅ Insert transaction record
                            PreparedStatement psTrans = con.prepareStatement(
                                "INSERT INTO transactions (AccountNumber, Type, Amount, Description) VALUES (?, 'Withdrawal', ?, ?)"
                            );
                            psTrans.setString(1, accountNumber);
                            psTrans.setDouble(2, withdrawAmount);
                            psTrans.setString(3, "ATM/Online Withdrawal");
                            psTrans.executeUpdate();
                            psTrans.close();

                            con.commit(); // ✅ Commit transaction
                            balance = newBalance;
                            message = "✅ Successfully withdrawn ₹ " + String.format("%.2f", withdrawAmount) +
                                      ". New Balance: ₹ " + String.format("%.2f", balance);
                        } else {
                            con.rollback();
                            message = "❌ Failed to update balance. Please try again.";
                        }
                        psUpdate.close();
                    }
                } else {
                    message = "❌ No account found. Please contact bank staff.";
                }
                rsAcc.close();
                psAcc.close();
                con.close();
            }
        } catch(Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    } else {
        // Load account info for display
        try {
            Connection con = Conn.getCon();
            PreparedStatement psAcc = con.prepareStatement(
                "SELECT AccountNumber, Balance FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID WHERE c.Email=?"
            );
            psAcc.setString(1, email);
            ResultSet rsAcc = psAcc.executeQuery();
            if (rsAcc.next()) {
                accountNumber = rsAcc.getString("AccountNumber");
                balance = rsAcc.getDouble("Balance");
            }
            rsAcc.close();
            psAcc.close();
            con.close();
        } catch(Exception e) {
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Withdrawal - SmartBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f8f9fa; }
        .card { max-width: 500px; margin: 50px auto; }
        .balance { font-size: 1.8rem; font-weight: bold; color: #dc3545; }
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
        <li class="nav-item"><a class="nav-link" href="Balance.jsp"><i class="bi bi-cash-stack"></i> Balance</a></li>
        <li class="nav-item"><a class="nav-link" href="../Login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container">
    <div class="card shadow text-center p-4">
        <h3 class="card-title mb-3">🏧 Withdraw Money</h3>

        <% if(accountNumber != null) { %>
            <p><strong>Account Number:</strong> <%= accountNumber %></p>
            <p class="balance">Current Balance: ₹ <%= String.format("%.2f", balance) %></p>

            <% if(!message.isEmpty()){ %>
                <div class="alert alert-info mt-3"><%= message %></div>
            <% } %>

            <form method="post" class="mt-3">
                <div class="mb-3">
                    <label for="withdrawAmount" class="form-label">Withdrawal Amount</label>
                    <input type="number" step="0.01" name="withdrawAmount" id="withdrawAmount" class="form-control" placeholder="Enter amount to withdraw" required>
                </div>
                <button type="submit" class="btn btn-danger">
                    <i class="bi bi-bank"></i> Withdraw
                </button>
            </form>
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
