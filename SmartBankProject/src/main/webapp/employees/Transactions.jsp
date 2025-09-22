<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ include file="../dbs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Panel - Customer Transactions</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #f4f6f9;
            font-family: 'Segoe UI', sans-serif;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            height: 100vh;
            background: #0d6efd;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.15);
        }
        .sidebar h4 {
            font-weight: 600;
        }
        .sidebar .nav-link {
            color: #d6e4ff;
            padding: 12px 20px;
            transition: 0.3s;
            border-radius: 6px;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: #084298;
            color: #fff;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
        }

        /* Main Content */
        .main-content {
            margin-left: 250px;  /* ✅ shift content beside sidebar */
            padding: 20px;
        }

        /* Bank style cards */
        .card-header {
            font-weight: 600;
        }
        .bank-card {
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .bank-btn {
            font-weight: 500;
            border-radius: 8px;
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
  <h4 class="text-white text-center mb-4">Employee Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li><a href="Dashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
    <li><a href="ViewCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> View Accounts</a></li>
    <li><a href="ManageCustomers.jsp" class="nav-link active"><i class="bi bi-people"></i> Manage Customers</a></li>
    <li><a href="OpenAccount.jsp" class="nav-link"><i class="bi bi-bank"></i> Open Accounts</a></li>
    <li><a href="ManageAccounts.jsp" class="nav-link"><i class="bi bi-bank"></i> Manage Accounts</a></li>
    <li><a href="Loans.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Loans</a></li>
    <li><a href="Transactions.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Transactions</a></li>
    <li><a href="../Login.jsp" class="nav-link text-warning"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <h2 class="text-center mb-4 text-primary">Employee Panel - Customer Transactions</h2>

    <!-- ✅ Display Transaction Messages -->
    <%
        String msg = request.getParameter("msg");
        if (msg != null) {
    %>
        <div class="alert alert-info text-center"><%= msg %></div>
    <%
        }
    %>

    <!-- Account Number Input -->
    <form method="get" class="d-flex justify-content-center mb-4">
        <input type="text" name="accountNumber" class="form-control w-50" placeholder="Enter Account Number" required>
        <button class="btn btn-primary ms-2 bank-btn" type="submit">Search</button>
    </form>

    <%
        String accNo = request.getParameter("accountNumber");
        if (accNo != null) {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                con = getConnection();

                ps = con.prepareStatement(
                    "SELECT a.Balance, c.Name " +
                    "FROM accounts a JOIN customers c ON a.CustomerID = c.CustomerID " +
                    "WHERE a.AccountNumber=?"
                );
                ps.setString(1, accNo);
                rs = ps.executeQuery();

                if (rs.next()) {
                    double balance = rs.getDouble("Balance");
                    String customerName = rs.getString("Name");
    %>

    <!-- ✅ Customer Info Card -->
    <div class="card mb-4 bank-card">
        <div class="card-header bg-primary text-white">Customer Account</div>
        <div class="card-body">
            <h5 class="mb-2">Customer Name: <%=customerName%></h5>
            <h6 class="mb-2">Account Number: <%=accNo%></h6>
            <h6>Balance: <span class="text-success fw-bold">₹ <%=balance%></span></h6>
        </div>
    </div>

    <div class="row g-3">
        <!-- Withdrawal -->
        <div class="col-md-3">
            <div class="card bank-card h-100">
                <div class="card-header bg-light text-dark">Withdrawal</div>
                <div class="card-body">
                    <form method="post" action="ProcessTransaction.jsp">
                        <input type="hidden" name="accountNumber" value="<%=accNo%>">
                        <input type="hidden" name="type" value="Withdrawal">
                        <input type="number" name="amount" class="form-control mb-3" placeholder="Enter Amount" required>
                        <button type="submit" class="btn btn-outline-danger w-100 bank-btn">Withdraw</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Deposit -->
        <div class="col-md-3">
            <div class="card bank-card h-100">
                <div class="card-header bg-light text-dark">Deposit</div>
                <div class="card-body">
                    <form method="post" action="ProcessTransaction.jsp">
                        <input type="hidden" name="accountNumber" value="<%=accNo%>">
                        <input type="hidden" name="type" value="Deposit">
                        <input type="number" name="amount" class="form-control mb-3" placeholder="Enter Amount" required>
                        <button type="submit" class="btn btn-outline-success w-100 bank-btn">Deposit</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Transfer -->
        <div class="col-md-3">
            <div class="card bank-card h-100">
                <div class="card-header bg-light text-dark">Transfer</div>
                <div class="card-body">
                    <form method="post" action="ProcessTransaction.jsp">
                        <input type="hidden" name="accountNumber" value="<%=accNo%>">
                        <input type="hidden" name="type" value="Transfer">
                        <input type="text" name="recipientAccount" class="form-control mb-2" placeholder="Recipient Account" required>
                        <input type="number" name="amount" class="form-control mb-3" placeholder="Amount" required>
                        <button type="submit" class="btn btn-outline-warning w-100 bank-btn">Transfer</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- History -->
        <div class="col-md-3">
            <div class="card bank-card h-100">
                <div class="card-header bg-light text-dark">Transaction History</div>
                <div class="card-body d-flex align-items-center justify-content-center">
                    <form method="get" action="TransactionHistory.jsp" class="w-100">
                        <input type="hidden" name="accountNumber" value="<%=accNo%>">
                        <button type="submit" class="btn btn-outline-primary w-100 bank-btn">View History</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%
                } else {
                    out.println("<div class='alert alert-danger'>Account not found!</div>");
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        }
    %>

</div>
</body>
</html>
