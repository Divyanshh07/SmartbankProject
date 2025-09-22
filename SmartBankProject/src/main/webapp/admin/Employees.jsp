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

    // Fetch employees
    List<Map<String,Object>> employees = new ArrayList<>();
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        con = getConnection();
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT * FROM employees ORDER BY EmployeeID ASC");
        while(rs.next()){
            Map<String,Object> emp = new HashMap<>();
            emp.put("id", rs.getInt("EmployeeID"));
            emp.put("name", rs.getString("Name"));
            emp.put("email", rs.getString("Email"));
            emp.put("role", rs.getString("Role"));
            emp.put("phone", rs.getString("Phone"));
            employees.add(emp);
        }
        rs.close();
    } catch(Exception e){ e.printStackTrace(); }
    finally { try { if(stmt!=null) stmt.close(); } catch(Exception e){} try { if(con!=null) con.close(); } catch(Exception e){} }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Employees</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { margin:0; padding:0; display:flex; font-family:'Segoe UI', sans-serif; background:#f8f9fa; }
        .sidebar { width: 220px; height: 100vh; background:#343a40; color:white; position: fixed; top:0; left:0; overflow-y:auto; padding-top:20px; }
        .sidebar h4 { font-weight:bold; text-align:center; margin-bottom:20px; }
        .sidebar .nav-link { color: #adb5bd; padding: 12px 20px; transition:0.3s; display:flex; align-items:center; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background:#495057; color:white; }
        .sidebar .nav-link i { margin-right:10px; }
        .content { margin-left:220px; padding:20px; width: calc(100% - 220px); }
        .table thead { background-color: #0d6efd; color: #fff; }
        .table tbody tr:hover { background-color:#e9f5ff; }
        h3 { margin-bottom: 25px; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Admin Panel</h4>
    <ul class="nav flex-column">
        <li><a href="AdminDashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
        <li><a href="Employees.jsp" class="nav-link active"><i class="bi bi-building"></i> Manage Employees</a></li>
        <li><a href="ViewTransactions.jsp" class="nav-link"><i class="bi bi-people"></i>View transactions</a></li>
        <li><a href="Reports.jsp" class="nav-link"><i class="bi bi-bar-chart"></i> Reports</a></li>
        <li><a href="Setting.jsp" class="nav-link"><i class="bi bi-gear"></i> Settings</a></li>
        <li><a href="../Login.jsp" class="nav-link text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="content container-fluid">
    <h3 class="text-primary">Manage Employees</h3>

    <!-- Add Employee Button -->
    <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
        <i class="bi bi-person-plus"></i> Add Employee
    </button>

    <!-- Employees Table -->
    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle text-center">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                for(Map<String,Object> emp : employees){
            %>
                <tr>
                    <td><%= emp.get("id") %></td>
                    <td><%= emp.get("name") %></td>
                    <td><%= emp.get("email") %></td>
                    <td><%= emp.get("role") %></td>
                    <td><%= emp.get("phone") %></td>
                    <td>
                        <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editEmployeeModal<%=emp.get("id")%>">
                            <i class="bi bi-pencil-square"></i> Edit
                        </button>
                        <a href="DeleteEmployee.jsp?id=<%= emp.get("id") %>" class="btn btn-sm btn-danger">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </td>
                </tr>

                <!-- Edit Employee Modal -->
                <div class="modal fade" id="editEmployeeModal<%=emp.get("id")%>" tabindex="-1" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <form method="post" action="UpdateEmployee.jsp">
                        <div class="modal-header">
                          <h5 class="modal-title">Edit Employee</h5>
                          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                          <input type="hidden" name="id" value="<%= emp.get("id") %>">
                          <div class="mb-2">
                            <label>Name</label>
                            <input type="text" name="name" class="form-control" value="<%= emp.get("name") %>" required>
                          </div>
                          <div class="mb-2">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" value="<%= emp.get("email") %>" required>
                          </div>
                          <div class="mb-2">
                            <label>Role</label>
                            <input type="text" name="role" class="form-control" value="<%= emp.get("role") %>" required>
                          </div>
                          <div class="mb-2">
                            <label>Phone</label>
                            <input type="text" name="phone" class="form-control" value="<%= emp.get("phone") %>" required>
                          </div>
                        </div>
                        <div class="modal-footer">
                          <button type="submit" class="btn btn-primary">Update</button>
                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>

            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Employee Modal -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="AddEmployee.jsp">
        <div class="modal-header">
          <h5 class="modal-title">Add Employee</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-2">
            <label>Name</label>
            <input type="text" name="name" class="form-control" required>
          </div>
          <div class="mb-2">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required>
          </div>
          <div class="mb-2">
            <label>Role</label>
            <input type="text" name="role" class="form-control" required>
          </div>
          <div class="mb-2">
            <label>Password</label>
            <input type="password" name="password" class="form-control" required>
          </div>
          <div class="mb-2">
            <label>Phone</label>
            <input type="text" name="phone" class="form-control" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success">Add Employee</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
