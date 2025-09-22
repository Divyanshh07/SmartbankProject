<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // ✅ Restrict access only for employee
    String role = (String)session.getAttribute("role");
    if(role == null || !"employee".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
%>
<%@ page import="conn.Conn, java.sql.*" %>
<%
    Connection con = Conn.getCon();
    Statement st = con.createStatement();

    // ✅ Fetch all requests (not just pending)
    ResultSet rs = st.executeQuery(
      "SELECT r.RequestID, r.CustomerID, c.Name, r.AccountType, r.Deposit, " +
      "r.Status, r.RequestDate, a.AccountNumber " +
      "FROM account_requests r " +
      "JOIN customers c ON r.CustomerID=c.CustomerID " +
      "LEFT JOIN accounts a ON r.CustomerID=a.CustomerID AND r.Status='Approved' " +
      "ORDER BY r.RequestDate DESC"
    );
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
  body { margin: 0; padding: 0; display: flex; }
  .sidebar {
    width: 250px; height: 100vh; background: #0d6efd; color: white;
    position: fixed; top: 0; left: 0; overflow-y: auto;
  }
  .sidebar .nav-link { color: #d6e4ff; padding: 12px 20px; transition: 0.3s; }
  .sidebar .nav-link:hover, .sidebar .nav-link.active {
    background: #084298; color: white;
  }
  .sidebar .nav-link i { margin-right: 10px; }
  .content { margin-left: 250px; padding: 20px; width: 100%; }
</style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
  <h4 class="text-white text-center mb-4">Employee Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li><a href="Dashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
    <li><a href="ViewCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> View Accounts</a></li>
    <li><a href="ManageCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> Manage Customers</a></li>
     <li><a href="OpenAccount.jsp" class="nav-link"><i class="bi bi-people"></i> Open Accounts</a></li>
    <li><a href="ManageAccounts.jsp" class="nav-link active"><i class="bi bi-bank"></i> Manage Accounts</a></li>
     <li><a href="Loans.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Loans</a></li>
    <li><a href="Transactions.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Transactions</a></li>
    <li><a href="../Login.jsp" class="nav-link text-warning"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="content">
  <div class="p-4 bg-white border rounded-4 shadow-sm text-center">
    <h2 class="fw-bold mb-3" style="color:#2c3e50;">
      Manage Account Requests
    </h2>
  </div>

  <table class="table table-bordered table-striped mt-3 text-center align-middle">
    <thead class="table-dark">
      <tr>
        <th>Request ID</th>
        <th>Customer</th>
        <th>Account Type</th>
        <th>Deposit</th>
        <th>Date</th>
        <th>Status</th>
        <th>Account No</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
      <%
        while(rs.next()){
          String status = rs.getString("Status");
      %>
      <tr>
        <td><%= rs.getInt("RequestID") %></td>
        <td><%= rs.getString("Name") %></td>
        <td><%= rs.getString("AccountType") %></td>
        <td>₹ <%= rs.getDouble("Deposit") %></td>
        <td><%= rs.getTimestamp("RequestDate") %></td>
        <td>
          <% if("Approved".equals(status)){ %>
            <span class="badge bg-success">Approved</span>
          <% } else if("Rejected".equals(status)){ %>
            <span class="badge bg-danger">Rejected</span>
          <% } else { %>
            <span class="badge bg-warning text-dark">Pending</span>
          <% } %>
        </td>
        <td>
          <% if("Approved".equals(status)){ %>
            <%= rs.getString("AccountNumber") %>
          <% } else { %>
            ---
          <% } %>
        </td>
        <td>
          <% if("Pending".equals(status)){ %>
            <a href="ApproveAccounts.jsp?requestId=<%=rs.getInt("RequestID")%>" class="btn btn-success btn-sm">Approve</a>
            <a href="RejectAccount.jsp?requestId=<%=rs.getInt("RequestID")%>" class="btn btn-danger btn-sm">Reject</a>
          <% } else { %>
            <button class="btn btn-secondary btn-sm" disabled>No Action</button>
          <% } %>
        </td>
      </tr>
      <% } rs.close(); st.close(); con.close(); %>
    </tbody>
  </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
