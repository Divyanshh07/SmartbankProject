<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // ✅ Restrict access to employee only
    String role = (String) session.getAttribute("role");
    if(role == null || !"employee".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Customers & Accounts - Employee Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .table thead th { vertical-align: middle; }
        .card { border-radius: 0.75rem; }
        .btn-sm { padding: 0.25rem 0.5rem; font-size: 0.8rem; }
        .table-hover tbody tr:hover { background-color: #e9f0ff; }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">SmartBank</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="Dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="ViewCustomers.jsp"><i class="bi bi-people"></i> Customers & Accounts</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-warning" href="../Login.jsp"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<div class="container mt-4">
    <h3 class="mb-4 text-primary fw-bold">
    <i class="bi bi-people-fill"></i> Customers & Accounts
</h3>

    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-striped table-hover text-center mb-0 align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>CustomerID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Account Number</th>
                        <th>Account Type</th>
                        <th>Balance</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try{
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/smartbankdb","root","Mysql@07");

                            String sql = "SELECT c.CustomerID, c.Name, c.Email, c.Phone, c.Address, " +
                                         "a.AccountNumber, a.AccountType, a.Balance, a.CreatedAt " +
                                         "FROM customers c " +
                                         "LEFT JOIN accounts a ON c.CustomerID = a.CustomerID " +
                                         "ORDER BY c.CustomerID";

                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sql);

                            while(rs.next()){
                    %>
                    <tr class="<%= rs.getString("AccountNumber") == null ? "table-warning" : "" %>">
                        <td><%= rs.getInt("CustomerID") %></td>
                        <td><%= rs.getString("Name") %></td>
                        <td><%= rs.getString("Email") %></td>
                        <td><%= rs.getString("Phone") %></td>
                        <td><%= rs.getString("Address") %></td>
                        <td>
                            <% if(rs.getString("AccountNumber") != null){ %>
                                <span class="badge bg-success"><%= rs.getString("AccountNumber") %></span>
                            <% } else { %>
                                <span class="badge bg-secondary">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if(rs.getString("AccountType") != null){ %>
                                <span class="badge bg-info text-dark"><%= rs.getString("AccountType") %></span>
                            <% } else { %>
                                <span class="badge bg-secondary">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <% if(rs.getString("Balance") != null){ %>
                                $<%= rs.getString("Balance") %>
                            <% } else { %>
                                N/A
                            <% } %>
                        </td>
                        <td><%= rs.getString("CreatedAt") != null ? rs.getString("CreatedAt") : "N/A" %></td>
                        <td>
                            <% if(rs.getString("AccountNumber") == null){ %>
                                <form method="get" action="OpenAccountEmployee.jsp" style="display:inline-block;">
                                    <input type="hidden" name="customerId" value="<%= rs.getInt("CustomerID") %>">
                                    <button type="submit" class="btn btn-success btn-sm" title="Open Account">
                                        <i class="bi bi-bank"></i> Open
                                    </button>
                                </form>
                            <% } else { %>
                                <span class="text-success fw-bold">✅ Exists</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                            con.close();
                        } catch(Exception e){
                    %>
                    <tr>
                        <td colspan="10" class="text-danger">Error: <%= e.getMessage() %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
