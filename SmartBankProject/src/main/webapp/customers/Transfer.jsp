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
    String senderAccount = null;
    double senderBalance = 0.0;
    String message = "";
    String recipientName = "";
    String recipientAccount = request.getParameter("recipientAccount");
    String transferAmountStr = request.getParameter("transferAmount");

    try {
        Connection con = Conn.getCon();

        // Get sender account
        PreparedStatement psSender = con.prepareStatement(
            "SELECT AccountNumber, Balance FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID WHERE c.Email=?"
        );
        psSender.setString(1, email);
        ResultSet rsSender = psSender.executeQuery();
        if(rsSender.next()){
            senderAccount = rsSender.getString("AccountNumber");
            senderBalance = rsSender.getDouble("Balance");
        }
        rsSender.close();
        psSender.close();

        // Step 1: If recipient account is entered, fetch recipient name
        if(recipientAccount != null && !recipientAccount.isEmpty() && (transferAmountStr == null || transferAmountStr.isEmpty())){
            PreparedStatement psRecipient = con.prepareStatement(
                "SELECT c.Name FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID WHERE a.AccountNumber=?"
            );
            psRecipient.setString(1, recipientAccount);
            ResultSet rsRecipient = psRecipient.executeQuery();
            if(rsRecipient.next()){
                recipientName = rsRecipient.getString("Name");
            } else {
                message = "❌ Recipient account not found!";
            }
            rsRecipient.close();
            psRecipient.close();
        }

        // Step 2: If transfer amount is entered, process transfer
        if(recipientAccount != null && !recipientAccount.isEmpty() && transferAmountStr != null && !transferAmountStr.isEmpty()){
            double transferAmount = Double.parseDouble(transferAmountStr);
            if(transferAmount <= 0){
                message = "❌ Transfer amount must be greater than zero.";
            } else if(transferAmount > senderBalance){
                message = "❌ Insufficient balance! Your balance is ₹ " + String.format("%.2f", senderBalance);
            } else {
                // Check recipient account exists
                PreparedStatement psCheck = con.prepareStatement(
                    "SELECT AccountNumber, Balance FROM accounts WHERE AccountNumber=?"
                );
                psCheck.setString(1, recipientAccount);
                ResultSet rsCheck = psCheck.executeQuery();
                if(rsCheck.next()){
                    double recipientBalance = rsCheck.getDouble("Balance");
                    double newSenderBalance = senderBalance - transferAmount;
                    double newRecipientBalance = recipientBalance + transferAmount;

                    try {
                        con.setAutoCommit(false); // ✅ start transaction

                        // Update sender
                        PreparedStatement psUpdateSender = con.prepareStatement(
                            "UPDATE accounts SET Balance=? WHERE AccountNumber=?"
                        );
                        psUpdateSender.setDouble(1, newSenderBalance);
                        psUpdateSender.setString(2, senderAccount);
                        psUpdateSender.executeUpdate();
                        psUpdateSender.close();

                        // Update recipient
                        PreparedStatement psUpdateRecipient = con.prepareStatement(
                            "UPDATE accounts SET Balance=? WHERE AccountNumber=?"
                        );
                        psUpdateRecipient.setDouble(1, newRecipientBalance);
                        psUpdateRecipient.setString(2, recipientAccount);
                        psUpdateRecipient.executeUpdate();
                        psUpdateRecipient.close();

                        // ✅ Insert sender transaction (debit)
                        PreparedStatement psTransSender = con.prepareStatement(
                            "INSERT INTO transactions (AccountNumber, RecipientAccount, Type, Amount, Description) VALUES (?, ?, 'Transfer', ?, ?)"
                        );
                        psTransSender.setString(1, senderAccount);
                        psTransSender.setString(2, recipientAccount);
                        psTransSender.setDouble(3, transferAmount);
                        psTransSender.setString(4, "Transfer to " + recipientAccount);
                        psTransSender.executeUpdate();
                        psTransSender.close();

                        // ✅ Insert recipient transaction (credit)
                        PreparedStatement psTransRecipient = con.prepareStatement(
                            "INSERT INTO transactions (AccountNumber, RecipientAccount, Type, Amount, Description) VALUES (?, ?, 'Deposit', ?, ?)"
                        );
                        psTransRecipient.setString(1, recipientAccount);
                        psTransRecipient.setString(2, senderAccount);
                        psTransRecipient.setDouble(3, transferAmount);
                        psTransRecipient.setString(4, "Received from " + senderAccount);
                        psTransRecipient.executeUpdate();
                        psTransRecipient.close();

                        con.commit(); // ✅ commit all updates
                        senderBalance = newSenderBalance;
                        message = "✅ ₹ " + String.format("%.2f", transferAmount) + " transferred successfully to Account " + recipientAccount;

                    } catch(Exception ex){
                        con.rollback(); // rollback in case of error
                        message = "❌ Transaction failed: " + ex.getMessage();
                    } finally {
                        con.setAutoCommit(true);
                    }
                } else {
                    message = "❌ Recipient account not found!";
                }
                rsCheck.close();
                psCheck.close();
            }
        }

        con.close();
    } catch(Exception e){
        message = "❌ Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transfer Money - SmartBank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color:#f8f9fa; }
        .card { max-width: 550px; margin: 50px auto; }
        .balance { font-size: 1.5rem; font-weight: bold; color: #0d6efd; }
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
    <div class="card shadow p-4 text-center">
        <h3 class="mb-3">💳 Transfer Money</h3>

        <% if(senderAccount != null){ %>
            <p><strong>Your Account:</strong> <%= senderAccount %></p>
            <p class="balance">Available Balance: ₹ <%= String.format("%.2f", senderBalance) %></p>

            <% if(!message.isEmpty()){ %>
                <div class="alert alert-info mt-3"><%= message %></div>
            <% } %>

            <form method="get" class="mt-3">
                <div class="mb-3">
                    <label for="recipientAccount" class="form-label">Recipient Account Number</label>
                    <input type="text" name="recipientAccount" id="recipientAccount" class="form-control" placeholder="Enter recipient account number" required
                        value="<%= recipientAccount != null ? recipientAccount : "" %>">
                </div>
                <button type="submit" class="btn btn-primary btn-sm">
                    <i class="bi bi-search"></i> Verify Recipient
                </button>
            </form>

            <% if(!recipientName.isEmpty()){ %>
                <form method="post" class="mt-3">
                    <input type="hidden" name="recipientAccount" value="<%= recipientAccount %>">
                    <div class="mb-3">
                        <label class="form-label">Recipient Name</label>
                        <input type="text" class="form-control" value="<%= recipientName %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="transferAmount" class="form-label">Amount to Transfer</label>
                        <input type="number" step="0.01" name="transferAmount" id="transferAmount" class="form-control" placeholder="Enter amount" required>
                    </div>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-arrow-right-circle"></i> Transfer
                    </button>
                </form>
            <% } %>

        <% } else { %>
            <p class="text-danger">❌ No account found. Please contact bank staff.</p>
        <% } %>

        <a href="CustomerDashboard.jsp" class="btn btn-primary mt-3"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
