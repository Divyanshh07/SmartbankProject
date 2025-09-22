<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../dbs.jsp" %>
<%
    // Admin access check
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    // Metrics
    int totalEmployees = 0, totalAccounts = 0, totalTransactions = 0;
    double totalBankBalance = 0, totalDeposits = 0, totalWithdrawals = 0;

    // Recent Transactions
    List<Map<String, Object>> recentTransactions = new ArrayList<>();

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = getConnection();
        stmt = con.createStatement();

        // Total Employees
        rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM employees");
        if(rs.next()) totalEmployees = rs.getInt("count");
        rs.close();

        // Total Accounts & Bank Balance
        rs = stmt.executeQuery("SELECT COUNT(*) AS count, SUM(Balance) AS balanceSum FROM accounts");
        if(rs.next()){
            totalAccounts = rs.getInt("count");
            totalBankBalance = rs.getDouble("balanceSum");
        }
        rs.close();

        // Total Transactions, Deposits, Withdrawals
        rs = stmt.executeQuery("SELECT COUNT(*) AS count, " +
                               "SUM(CASE WHEN Type='Deposit' THEN Amount ELSE 0 END) AS depositSum, " +
                               "SUM(CASE WHEN Type='Withdrawal' THEN Amount ELSE 0 END) AS withdrawalSum " +
                               "FROM transactions");
        if(rs.next()){
            totalTransactions = rs.getInt("count");
            totalDeposits = rs.getDouble("depositSum");
            totalWithdrawals = rs.getDouble("withdrawalSum");
        }
        rs.close();

        // Recent Transactions (last 10)
        rs = stmt.executeQuery("SELECT * FROM transactions ORDER BY Timestamp DESC LIMIT 10");
        while(rs.next()){
            Map<String,Object> map = new HashMap<>();
            map.put("id", rs.getInt("TransactionID"));
            map.put("accNo", rs.getString("AccountNumber"));
            map.put("type", rs.getString("Type"));
            map.put("recipient", rs.getString("RecipientAccount"));
            map.put("amount", rs.getDouble("Amount"));
            map.put("desc", rs.getString("Description"));
            map.put("time", rs.getTimestamp("Timestamp"));
            recentTransactions.add(map);
        }
        rs.close();

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(con != null) con.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; display: flex; }
        .sidebar {
            width: 240px;
            height: 100vh;
            background: #343a40;
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
        }
        .sidebar h4 { font-size: 1.2rem; }
        .sidebar .nav-link {
            color: #adb5bd;
            padding: 10px 18px;
            transition: 0.3s;
            font-size: 0.95rem;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: #495057;
            color: white;
        }
        .sidebar .nav-link i { margin-right: 8px; }
        .content {
            margin-left: 220px;
            padding: 20px 30px;
            width: calc(100% - 220px);
        }
        .card i { font-size: 1.8rem; }
        .table thead { background-color: #0d6efd; color: #fff; }
        .table tbody tr:hover { background-color: #e9f5ff; }
        .chart-container {
            width: 70%; /* reduced chart width */
            margin: auto;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
  <h4 class="text-white text-center mb-4">Admin Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li><a href="AdminDashboard.jsp" class="nav-link active"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
    <li><a href="Employees.jsp" class="nav-link"><i class="bi bi-building"></i> Manage Employees</a></li>
        <li><a href="ViewTransactions.jsp" class="nav-link"><i class="bi bi-people"></i> ViewTransactions</a></li>
    <li><a href="Reports.jsp" class="nav-link"><i class="bi bi-bar-chart"></i> Reports</a></li>
    <li><a href="Setting.jsp" class="nav-link"><i class="bi bi-gear"></i> Settings</a></li>
    <li><a href="../Login.jsp" class="nav-link text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
  </ul>
</div>

<div class="content">

    <!-- Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-2">
            <div class="card text-bg-primary p-3 shadow-sm text-center">
                <i class="bi bi-people-fill"></i>
                <h6 class="mt-2">Employees</h6>
                <p class="fs-6 fw-bold"><%= totalEmployees %></p>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card text-bg-success p-3 shadow-sm text-center">
                <i class="bi bi-bank"></i>
                <h6 class="mt-2">Accounts</h6>
                <p class="fs-6 fw-bold"><%= totalAccounts %></p>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card text-bg-warning p-3 shadow-sm text-center">
                <i class="bi bi-cash-stack"></i>
                <h6 class="mt-2">Bank Balance</h6>
                <p class="fs-6 fw-bold">₹ <%= totalBankBalance %></p>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card text-bg-info p-3 shadow-sm text-center">
                <i class="bi bi-arrow-repeat"></i>
                <h6 class="mt-2">Transactions</h6>
                <p class="fs-6 fw-bold"><%= totalTransactions %></p>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card text-bg-success p-3 shadow-sm text-center">
                <i class="bi bi-arrow-down-circle"></i>
                <h6 class="mt-2">Deposits</h6>
                <p class="fs-6 fw-bold">₹ <%= totalDeposits %></p>
            </div>
        </div>
        <div class="col-md-2">
            <div class="card text-bg-danger p-3 shadow-sm text-center">
                <i class="bi bi-arrow-up-circle"></i>
                <h6 class="mt-2">Withdrawals</h6>
                <p class="fs-6 fw-bold">₹ <%= totalWithdrawals %></p>
            </div>
        </div>
    </div>

    <!-- Chart: Deposit vs Withdrawal -->
    <div class="chart-container mb-4">
        <canvas id="depositWithdrawChart"></canvas>
    </div>

    <script>
        const ctx = document.getElementById('depositWithdrawChart').getContext('2d');
        const depositWithdrawChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Deposits', 'Withdrawals'],
                datasets: [{
                    label: 'Amount (₹)',
                    data: [<%= totalDeposits %>, <%= totalWithdrawals %>],
                    backgroundColor: ['green','red']
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });
    </script>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
