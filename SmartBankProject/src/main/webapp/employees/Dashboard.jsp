<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // ✅ Restrict access only for employee
    String role = (String)session.getAttribute("role");
    String username = (String)session.getAttribute("username");
    if(role == null || !"employee".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
%>

<%! 
    // ✅ Centralized DB Connection Method
    public static Connection getConnection() throws Exception {
        String dbURL = "jdbc:mysql://localhost:3306/smartbankdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "Mysql@07"; // 🔐 your DB password
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbURL, dbUser, dbPass);
    }
%>

<%
    int totalCustomers = 0;
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        con = getConnection();  // ✅ use our method
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT COUNT(*) AS count FROM customers");
        if(rs.next()) totalCustomers = rs.getInt("count");
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception ex) {}
        if(stmt != null) try { stmt.close(); } catch(Exception ex) {}
        if(con != null) try { con.close(); } catch(Exception ex) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
  body {
    margin: 0;
    padding: 0;
    display: flex;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f8f9fa;
  }
  .sidebar {
    width: 250px;
    height: 100vh;
    background: #0d6efd; /* Bootstrap Primary Blue */
    color: white;
    position: fixed;
    top: 0;
    left: 0;
    overflow-y: auto;
  }
  .sidebar h4 {
    font-weight: bold;
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
    padding: 30px;
    width: 100%;
  }
  .card i {
    font-size: 2rem;
  }
</style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
  <h4 class="text-white text-center mb-4">Employee Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li><a href="Dashboard.jsp" class="nav-link active"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
    <li><a href="ViewCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> View Accounts</a></li>
    <li><a href="ManageCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> Manage Customers</a></li>
    <li><a href="OpenAccount.jsp" class="nav-link"><i class="bi bi-bank"></i> Open Accounts</a></li>
    <li><a href="ManageAccounts.jsp" class="nav-link"><i class="bi bi-bank"></i> Manage Accounts</a></li>
    <li><a href="Loans.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Loans</a></li>
    <li><a href="Transactions.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Transactions</a></li>
    <li><a href="../Login.jsp" class="nav-link text-warning"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="content">
  <div class="mb-4">
    <h2 class="fw-bold text-primary">Welcome, <%= username %> 👋</h2>
    <p class="text-muted">This is your employee dashboard. Here you can manage accounts, customers, and transactions efficiently.</p>
  </div>
  
  <div class="row g-4">
    <!-- Customers Card -->
    <div class="col-md-3">
      <div class="card text-bg-success p-3 shadow-sm">
        <i class="bi bi-people-fill"></i>
        <h5 class="card-title mt-2">Total Customers</h5>
        <p class="card-text fs-4 fw-bold"><%= totalCustomers %></p>
      </div>
    </div>
  </div> 
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
