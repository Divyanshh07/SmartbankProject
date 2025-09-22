<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // ✅ Restrict access only for employee
    String role = (String)session.getAttribute("role");
    if(role == null || !"employee".equals(role)){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Customers - SmartBank</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
  body { margin:0; padding:0; display:flex; }
  .sidebar {
    width:250px; height:100vh; background:#0d6efd; color:white;
    position:fixed; top:0; left:0; overflow-y:auto;
  }
  .sidebar .nav-link { color:#d6e4ff; padding:12px 20px; transition:0.3s; }
  .sidebar .nav-link:hover, .sidebar .nav-link.active { background:#084298; color:white; }
  .sidebar .nav-link i { margin-right:10px; }
  .content { margin-left:250px; padding:20px; width:100%; }
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
     <li><a href="OpenAccount.jsp" class="nav-link"><i class="bi bi-people"></i> Open Accounts</a></li>
    <li><a href="ManageAccounts.jsp" class="nav-link"><i class="bi bi-bank"></i> Manage Accounts</a></li>
     <li><a href="Loans.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Loans</a></li>
    <li><a href="Transactions.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Transactions</a></li>
    <li><a href="../Login.jsp" class="nav-link text-warning"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="content">
  <h4 class="fw-bold mb-4">👥 Manage Customers</h4>

  <!-- Add New User Form -->
  <div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white">
      <i class="bi bi-person-plus"></i> Add New Customer
    </div>
    <div class="card-body">
      <form method="post" action="ViewCustomers.jsp" class="row g-3">
        <div class="col-md-4">
          <input type="text" name="name" class="form-control" placeholder="Name" required>
        </div>
        <div class="col-md-4">
          <input type="email" name="email" class="form-control" placeholder="Email" required>
        </div>
        <div class="col-md-4">
          <input type="text" name="phone" class="form-control" placeholder="Phone" required>
        </div>
        <div class="col-md-4">
          <input type="text" name="address" class="form-control" placeholder="Address" required>
        </div>
        <div class="col-md-4">
          <input type="password" name="password" class="form-control" placeholder="Password" required>
        </div>
        <div class="col-md-12">
          <button type="submit" class="btn btn-success">
            <i class="bi bi-check-circle"></i> Add Customer
          </button>
        </div>
      </form>
    </div>
  </div>

  <%
    // Handle Add Customer
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String pass = request.getParameter("password");

    if(name != null){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartbankdb","root","Mysql@07");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO customers(Name,Email,Phone,Address,Password) VALUES (?,?,?,?,?)"
            );
            ps.setString(1,name);
            ps.setString(2,email);
            ps.setString(3,phone);
            ps.setString(4,address);
            ps.setString(5,pass);
            ps.executeUpdate();

            con.close();
            out.println("<div class='alert alert-success'>✅ Customer added successfully!</div>");
            out.println("<a href='customers/OpenAccount.jsp'>Click here to open account</a>");
        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>❌ Error: "+ e.getMessage() +"</div>");
        }
    }

    // Handle Delete Customer
    String deleteId = request.getParameter("deleteId");
    if(deleteId != null){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartbankdb","root","Mysql@07");

            PreparedStatement ps = con.prepareStatement("DELETE FROM customers WHERE CustomerID=?");
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.executeUpdate();

            con.close();
            out.println("<div class='alert alert-warning'>⚠️ Customer deleted successfully!</div>");
        } catch(Exception e) {
            out.println("<div class='alert alert-danger'>❌ Error: "+ e.getMessage() +"</div>");
        }
    }
  %>

  <!-- Registered Customers List -->
  <div class="card shadow-sm">
    <div class="card-header bg-dark text-white">
      <i class="bi bi-list-check"></i> Registered Customers
    </div>
    <div class="card-body p-0">
      <table class="table table-bordered table-hover mb-0 text-center align-middle">
        <thead class="table-light">
          <tr>
            <th>CustomerID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Password</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/smartbankdb","root","Mysql@07");

                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM customers");

                while(rs.next()){
          %>
          <tr>
            <td><%= rs.getInt("CustomerID") %></td>
            <td><%= rs.getString("Name") %></td>
            <td><%= rs.getString("Email") %></td>
            <td><%= rs.getString("Phone") %></td>
            <td><%= rs.getString("Address") %></td>
            <td><%= rs.getString("Password") %></td>
            <td>
              <!-- Update -->
              <form method="post" action="Update.jsp" style="display:inline-block; margin-right:6px;">
                <input type="hidden" name="UpdateId" value="<%= rs.getInt("CustomerID") %>">
                <button type="submit" class="btn btn-warning btn-sm" onclick="return confirm('Update this customer?');">
                  <i class="bi bi-pencil-square"></i> Update
                </button>
              </form>

              <!-- Delete -->
              <form method="post" action="ViewCustomers.jsp" style="display:inline-block;">
                <input type="hidden" name="deleteId" value="<%= rs.getInt("CustomerID") %>">
                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this customer?');">
                  <i class="bi bi-trash"></i> Delete
                </button>
              </form>
              
            </td>
          </tr>
          <%
                }
                con.close();
            } catch(Exception e) {
                out.println("<tr><td colspan='7'>Error: "+ e.getMessage() +"</td></tr>");
            }
          %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
