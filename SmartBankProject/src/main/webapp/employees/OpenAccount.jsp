<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // ✅ Restrict access only for employee
    String role = (String) session.getAttribute("role");
    if(role == null || !"employee".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    String message = "";

    // Handle form submission
    String customerIdStr = request.getParameter("customerId");
    String accountType = request.getParameter("accountType");
    String initialDepositStr = request.getParameter("initialDeposit");

    if(customerIdStr != null && accountType != null && initialDepositStr != null){
        try{
            int customerId = Integer.parseInt(customerIdStr);
            double initialDeposit = Double.parseDouble(initialDepositStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartbankdb","root","Mysql@07");

            // Generate unique account number
            String accountNumber = "SB" + (long)(Math.random() * 10000000000L);

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO accounts(CustomerID, AccountNumber, AccountType, Balance) VALUES (?,?,?,?)"
            );
            ps.setInt(1, customerId);
            ps.setString(2, accountNumber);
            ps.setString(3, accountType);
            ps.setDouble(4, initialDeposit);

            int inserted = ps.executeUpdate();
            if(inserted > 0){
                message = "✅ Account created successfully! Account Number: " + accountNumber;
            }

            ps.close();
            con.close();

        } catch(Exception e){
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Open Account - Employee Panel</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
    body {
        margin: 0;
        padding: 0;
        display: flex;
        min-height: 100vh;
    }
    .sidebar {
        width: 250px;
        height: 100vh;
        background: #0d6efd;
        color: white;
        position: fixed;
        top: 0;
        left: 0;
        overflow-y: auto;
    }
    .sidebar .nav-link {
        color: #d6e4ff;
        padding: 12px 20px;
        transition: 0.3s;
    }
    .sidebar .nav-link:hover, .sidebar .nav-link.active {
        background: #084298;
        color: white;
    }
    .sidebar .nav-link i {
        margin-right: 10px;
    }
    .content {
        margin-left: 250px;
        padding: 20px;
        width: 100%;
    }
</style>
</head>
<body style="background-color:#f8f9fa;">

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
    <h4 class="text-white text-center mb-4">Employee Panel</h4>
    <ul class="nav nav-pills flex-column mb-auto">
        <li><a href="Dashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="ViewCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> View Accounts</a></li>    
        <li><a href="ManageCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> Manage Customers</a></li>
        <li><a href="OpenAccount.jsp" class="nav-link active"><i class="bi bi-bank"></i> Open Accounts</a></li>
        <li><a href="ManageAccounts.jsp" class="nav-link"><i class="bi bi-bank2"></i> Manage Accounts</a></li>
        <li><a href="Loans.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Loans</a></li>
        <li><a href="Transactions.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Transactions</a></li>
        <li><a href="../Login.jsp" class="nav-link text-warning"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="content">
    <h3 class="mb-4">🏦 Open Account for Customer</h3>

    <% if(!message.isEmpty()){ %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-body">
            <form method="post" class="row g-3">
                <div class="col-md-4">
                    <label for="customerId" class="form-label">Customer ID</label>
                    <input type="number" name="customerId" id="customerId" class="form-control" placeholder="Enter Customer ID" required>
                </div>

                <div class="col-md-4">
                    <label for="accountType" class="form-label">Account Type</label>
                    <select name="accountType" id="accountType" class="form-select" required>
                        <option value="">Select Account Type</option>
                        <option value="Savings">Savings</option>
                        <option value="Current">Current</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label for="initialDeposit" class="form-label">Initial Deposit</label>
                    <input type="number" name="initialDeposit" id="initialDeposit" class="form-control" placeholder="Enter Deposit Amount" required>
                </div>

                <div class="col-12 mt-2">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-bank"></i> Create Account
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
