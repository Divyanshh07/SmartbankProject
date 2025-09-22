<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // ✅ Restrict access only for employee
    String role = (String)session.getAttribute("role");
    String username = (String)session.getAttribute("username");
    if(role == null || !"employee".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
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
<body>

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3 active">
  <h4 class="text-white text-center mb-4">Employee Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li>
      <a href="Dashboard.jsp" class="nav-link">
        <i class="bi bi-speedometer2"></i> Dashboard
      </a>
    </li>
    <li>
      <a href="ViewCustomers.jsp" class="nav-link">
        <i class="bi bi-people"></i> View Accounts
      </a>
    </li>    
    <li>
      <a href="ManageCustomers.jsp" class="nav-link">
        <i class="bi bi-people"></i> Manage Customers
      </a>
    </li>
     <li>
      <a href="OpenAccount.jsp" class="nav-link">
        <i class="bi bi-people"></i> Open Accounts
      </a>
    </li>
    <li>
      <a href="ManageAccounts.jsp" class="nav-link">
        <i class="bi bi-bank"></i> Manage Accounts
      </a>
    </li>
    <li>
      <a href="Transactions.jsp" class="nav-link">
        <i class="bi bi-credit-card"></i> Transactions
      </a>
    </li>
        <li>
      <a href="Loans.jsp" class="nav-link">
        <i class="bi bi-credit-card"></i> Loans
      </a>
    </li>
    <li>
      <a href="../Login.jsp" class="nav-link text-warning">
        <i class="bi bi-box-arrow-right"></i> Logout
      </a>
    </li>
  </ul>
</div>

<!-- Main Content -->
<div class="content text-center">
  <div class="p-4 bg-white border rounded-4 shadow-sm">
    <h2 class="fw-bold mb-3" style="color:#2c3e50;">
      Welcome, <%= username %> 👋
    </h2>
    <p class="text-muted mb-0">
      Use the sidebar to manage Customers, Accounts, and Transactions.
    </p>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
