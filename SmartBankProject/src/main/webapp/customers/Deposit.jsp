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

    // Handle deposit form submission
    String depositStr = request.getParameter("depositAmount");
    if (depositStr != null && !depositStr.isEmpty()) {
        try {
            double depositAmount = Double.parseDouble(depositStr);
            if (depositAmount <= 0) {
                message = "❌ Deposit amount must be greater than zero.";
            } else {
                Connection con = Conn.getCon();

                // Get account
                PreparedStatement psAcc = con.prepareStatement(
                    "SELECT AccountNumber, Balance FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID WHERE c.Email=?"
                );
                psAcc.setString(1, email);
                ResultSet rsAcc = psAcc.executeQuery();

                if (rsAcc.next()) {
                    accountNumber = rsAcc.getString("AccountNumber");
                    balance = rsAcc.getDouble("Balance");
                    
                    // Update balance
                    double newBalance = balance + depositAmount;
                    PreparedStatement psUpdate = con.prepareStatement(
                        "UPDATE accounts SET Balance=? WHERE AccountNumber=?"
                    );
                    psUpdate.setDouble(1, newBalance);
                    psUpdate.setString(2, accountNumber);
                    int updated = psUpdate.executeUpdate();
                    psUpdate.close();

                    if (updated > 0) {
                        // ✅ Insert into transactions
                        PreparedStatement psTxn = con.prepareStatement(
                            "INSERT INTO transactions (AccountNumber, Type, Amount, Description) VALUES (?,?,?,?)"
                        );
                        psTxn.setString(1, accountNumber);
                        psTxn.setString(2, "Deposit");
                        psTxn.setDouble(3, depositAmount);
                        psTxn.setString(4, "Cash Deposit");
                        psTxn.executeUpdate();
                        psTxn.close();

                        balance = newBalance;
                        message = "✅ Successfully deposited ₹ " + String.format("%.2f", depositAmount) + 
                                  ". New Balance: ₹ " + String.format("%.2f", balance);
                    } else {
                        message = "❌ Failed to update balance. Please try again.";
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
    <title>Deposit - SmartBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f8f9fa; }
        .card { max-width: 500px; margin: 50px auto; }
        .balance { font-size: 1.8rem; font-weight: bold; color: #198754; }
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
        <li class="nav-item"><a class="nav-link" href="Transactions.jsp"><i class="bi bi-clock-history"></i> Transactions</a></li>
        <li class="nav-item"><a class="nav-link" href="../Login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container">
    <div class="card shadow text-center p-4">
        <h3 class="card-title mb-3">💵 Deposit Money</h3>

        <% if(accountNumber != null) { %>
            <p><strong>Account Number:</strong> <%= accountNumber %></p>
            <p class="balance">Current Balance: ₹ <%= String.format("%.2f", balance) %></p>

            <% if(!message.isEmpty()){ %>
                <div class="alert alert-info mt-3"><%= message %></div>
            <% } %>

            <form method="post" class="mt-3">
                <div class="mb-3">
                    <label for="depositAmount" class="form-label">Deposit Amount</label>
                    <input type="number" step="0.01" name="depositAmount" id="depositAmount" class="form-control" placeholder="Enter amount to deposit" required>
                </div>
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-cash-stack"></i> Deposit
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
