<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../dbs.jsp" %>
<%
    // Admin access check
    String role = (String) session.getAttribute("role");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    // Fetch recent transactions
    List<Map<String, Object>> recentTransactions = new ArrayList<>();
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = getConnection();
        stmt = con.createStatement();
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
    <title>Admin Transactions</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { margin:0; padding:0; display:flex; font-family:'Segoe UI', sans-serif; background:#f8f9fa; }
        .sidebar {
            width: 220px; height: 100vh; background:#343a40; color:white;
            position: fixed; top:0; left:0; overflow-y:auto; padding-top:20px;
        }
        .sidebar h4 { font-weight:bold; text-align:center; margin-bottom:20px; }
        .sidebar .nav-link { color: #adb5bd; padding: 12px 20px; transition:0.3s; display:flex; align-items:center; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background:#495057; color:white; }
        .sidebar .nav-link i { margin-right:10px; }
        .content { margin-left:220px; padding:20px; width: calc(100% - 220px); }
        .table thead { background-color: #0d6efd; color: #fff; }
        .table tbody tr:hover { background-color:#e9f5ff; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Admin Panel</h4>
    <ul class="nav flex-column">
        <li><a href="AdminDashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="Employees.jsp" class="nav-link"><i class="bi bi-building"></i> Manage Employees</a></li>
        <li><a href="ViewTransactions.jsp" class="nav-link active"><i class="bi bi-people"></i> ViewTransactions</a></li>
        <li><a href="Reports.jsp" class="nav-link"><i class="bi bi-bar-chart"></i> Reports</a></li>
        <li><a href="Setting.jsp" class="nav-link"><i class="bi bi-gear"></i> Settings</a></li>
        <li><a href="../Login.jsp" class="nav-link text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="content container-fluid">
    <h3 class="mb-4 text-primary">Recent Transactions</h3>
    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle text-center">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Account Number</th>
                    <th>Type</th>
                    <th>Recipient</th>
                    <th>Amount</th>
                    <th>Description</th>
                    <th>Timestamp</th>
                </tr>
            </thead>
            <tbody>
            <%
                for(Map<String,Object> tx : recentTransactions){
            %>
                <tr>
                    <td><%= tx.get("id") %></td>
                    <td><%= tx.get("accNo") %></td>
                    <td><%= tx.get("type") %></td>
                    <td><%= tx.get("recipient") != null ? tx.get("recipient") : "-" %></td>
                    <td>₹ <%= tx.get("amount") %></td>
                    <td><%= tx.get("desc") != null ? tx.get("desc") : "-" %></td>
                    <td><%= tx.get("time") %></td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
