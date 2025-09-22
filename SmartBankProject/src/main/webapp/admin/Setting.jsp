<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../dbs.jsp" %>
<%
    // Admin session check
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    // Fetch current admin info
    String name="", email="", phone="";
    Connection con=null;
    PreparedStatement ps=null;
    ResultSet rs=null;
    try{
        con = getConnection();
        ps = con.prepareStatement("SELECT Name, Email, Phone FROM employees WHERE Name=? AND Role='admin'");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if(rs.next()){
            name = rs.getString("Name");
            email = rs.getString("Email");
            phone = rs.getString("Phone");
        }
    }catch(Exception e){ e.printStackTrace(); }
    finally{ try{ if(rs!=null) rs.close(); }catch(Exception e){} try{ if(ps!=null) ps.close(); }catch(Exception e){} try{ if(con!=null) con.close(); }catch(Exception e){} }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Settings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { margin:0; display:flex; font-family:'Segoe UI', sans-serif; }
        .sidebar { width:250px; height:100vh; background:#343a40; color:white; position:fixed; top:0; left:0; overflow-y:auto; }
        .sidebar .nav-link { color:#adb5bd; padding:12px 20px; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background:#495057; color:white; }
        .sidebar .nav-link i { margin-right:10px; }
        .content { margin-left:250px; padding:20px; width:100%; }
    </style>
</head>
<body>
<div class="sidebar d-flex flex-column p-3">
    <h4 class="text-white text-center mb-4">Admin Panel</h4>
    <ul class="nav nav-pills flex-column mb-auto">
        <li><a href="AdminDashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="Customers.jsp" class="nav-link"><i class="bi bi-people"></i> Manage Customers</a></li>
        <li><a href="Employees.jsp" class="nav-link"><i class="bi bi-building"></i> Manage Employees</a></li>
        <li><a href="Report.jsp" class="nav-link"><i class="bi bi-bar-chart"></i> Reports</a></li>
        <li><a href="Setting.jsp" class="nav-link active"><i class="bi bi-gear"></i> Settings</a></li>
        <li><a href="../Login.jsp" class="nav-link text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</div>

<div class="content container-fluid">
    <h3 class="mb-4 text-primary">Admin Settings</h3>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-4" id="settingsTab" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="personal-tab" data-bs-toggle="tab" data-bs-target="#personal" type="button" role="tab">Personal Info</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button" role="tab">Change Password</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="bank-tab" data-bs-toggle="tab" data-bs-target="#bank" type="button" role="tab">Bank Policies</button>
        </li>
    </ul>

    <div class="tab-content" id="settingsTabContent">
        <!-- Personal Info -->
        <div class="tab-pane fade show active" id="personal" role="tabpanel">
            <form method="post" action="UpdateAdminInfo.jsp" class="row g-3">
                <div class="col-md-4">
                    <label>Name</label>
                    <input type="text" class="form-control" name="name" value="<%=name%>" required>
                </div>
                <div class="col-md-4">
                    <label>Email</label>
                    <input type="email" class="form-control" name="email" value="<%=email%>" required>
                </div>
                <div class="col-md-4">
                    <label>Phone</label>
                    <input type="text" class="form-control" name="phone" value="<%=phone%>" required>
                </div>
                <div class="col-12 mt-3">
                    <button class="btn btn-primary">Update Info</button>
                </div>
            </form>
        </div>

        <!-- Change Password -->
        <div class="tab-pane fade" id="password" role="tabpanel">
            <form method="post" action="ChangeAdminPassword.jsp" class="row g-3">
                <div class="col-md-4">
                    <label>Current Password</label>
                    <input type="password" class="form-control" name="currentPassword" required>
                </div>
                <div class="col-md-4">
                    <label>New Password</label>
                    <input type="password" class="form-control" name="newPassword" required>
                </div>
                <div class="col-md-4">
                    <label>Confirm New Password</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>
                <div class="col-12 mt-3">
                    <button class="btn btn-warning">Change Password</button>
                </div>
            </form>
        </div>

        <!-- Bank Policies -->
        <div class="tab-pane fade" id="bank" role="tabpanel">
            <form method="post" action="UpdateBankPolicy.jsp" class="row g-3">
                <div class="col-md-4">
                    <label>Interest Rate (%)</label>
                    <input type="number" class="form-control" name="interestRate" placeholder="e.g., 5.5" required>
                </div>
                <div class="col-md-4">
                    <label>Daily Withdrawal Limit</label>
                    <input type="number" class="form-control" name="withdrawalLimit" placeholder="e.g., 50000" required>
                </div>
                <div class="col-md-4">
                    <label>Daily Deposit Limit</label>
                    <input type="number" class="form-control" name="depositLimit" placeholder="e.g., 100000" required>
                </div>
                <div class="col-md-4">
                    <label>Service Charge (%)</label>
                    <input type="number" class="form-control" name="serviceCharge" placeholder="e.g., 0.5" required>
                </div>
                <div class="col-12 mt-3">
                    <button class="btn btn-success">Update Policies</button>
                </div>
            </form>
        </div>

      
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
