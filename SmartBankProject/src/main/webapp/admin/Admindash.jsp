<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,conn.Conn" %>
<%
    // ✅ Restrict access only for admin
    String role = (String)session.getAttribute("role");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin Dashboard</title>
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
    background: #343a40;
    color: white;
    position: fixed;
    top: 0;
    left: 0;
    overflow-y: auto;
  }
  .sidebar .nav-link {
    color: #adb5bd;
    padding: 12px 20px;
    transition: 0.3s;
  }
  .sidebar .nav-link:hover, .sidebar .nav-link.active {
    background: #495057;
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
<div class="sidebar d-flex flex-column p-3">
  <h4 class="text-white text-center mb-4">Admin Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li>
      <a href="AdminDashboard.jsp" class="nav-link">
        <i class="bi bi-speedometer2"></i> Dashboard
      </a>
    </li>
    <li>
      <a href="Employees.jsp" class="nav-link">
        <i class="bi bi-building"></i> Manage Employees
      </a>
    </li>
        <li>
      <a href="ViewTransactions.jsp" class="nav-link ">
        <i class="bi bi-people"></i> View Transactions
      </a>
    </li>
    <li>
      <a href="Reports.jsp" class="nav-link">
        <i class="bi bi-bar-chart"></i> Reports
      </a>
    </li>
    <li>
      <a href="Setting.jsp" class="nav-link">
        <i class="bi bi-gear"></i> Settings
      </a>
    </li>
    <li>
      <a href="../Login.jsp" class="nav-link text-danger">
        <i class="bi bi-box-arrow-right"></i> Logout
      </a>
    </li>
  </ul>
</div>

<!-- Main Content -->
<div class="content text-center">
  <div class="p-4 bg-white border rounded-4 shadow-sm">
    <h2 class="fw-bold mb-3" style="color:#2c3e50;">
      Welcome to Admin Dashboard
    </h2>
    <p class="text-muted mb-0">
      Manage all Customers, Employees, and Reports in one place.
    </p>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
