<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, conn.Conn" %>
<%@ page import="java.util.*" %>
<%
    // ✅ Session check
    HttpSession sess = request.getSession(false);
    if(sess == null){
        response.sendRedirect("../Login.jsp?msg=sessionExpired");
        return;
    }

    String message = "";

    // Handle approval/rejection
    String loanIdStr = request.getParameter("loanId");
    String action = request.getParameter("action");

    if(loanIdStr != null && action != null){
        try{
            int loanId = Integer.parseInt(loanIdStr);
            Connection con = Conn.getCon();

            if("approve".equalsIgnoreCase(action)){
                PreparedStatement ps = con.prepareStatement(
                    "SELECT Amount, Tenure, InterestRate FROM loans WHERE LoanID=?"
                );
                ps.setInt(1, loanId);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    double P = rs.getDouble("Amount");
                    int N = rs.getInt("Tenure");
                    double annualRate = rs.getDouble("InterestRate");
                    double R = annualRate / (12*100);
                    double EMI = (P*R*Math.pow(1+R, N))/(Math.pow(1+R,N)-1);

                    PreparedStatement psUpdate = con.prepareStatement(
                        "UPDATE loans SET Status='Approved', EMI=? WHERE LoanID=?"
                    );
                    psUpdate.setDouble(1, EMI);
                    psUpdate.setInt(2, loanId);
                    psUpdate.executeUpdate();
                    psUpdate.close();
                    message = "✅ Loan approved successfully!";
                }
                rs.close(); ps.close();
            } else if("reject".equalsIgnoreCase(action)){
                PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE loans SET Status='Rejected', EMI=0 WHERE LoanID=?"
                );
                psUpdate.setInt(1, loanId);
                psUpdate.executeUpdate();
                psUpdate.close();
                message = "❌ Loan rejected!";
            }
            con.close();
        } catch(Exception e){
            message = "❌ Error: " + e.getMessage();
        }
    }

    // Fetch all loans
    List<String[]> loans = new ArrayList<>();
    try{
        Connection con = Conn.getCon();
        PreparedStatement ps = con.prepareStatement(
            "SELECT l.LoanID, c.Name, l.Amount, l.Tenure, l.InterestRate, l.Status, l.EMI " +
            "FROM loans l JOIN customers c ON l.CustomerID=c.CustomerID ORDER BY l.AppliedAt DESC"
        );
        ResultSet rs = ps.executeQuery();
        while(rs.next()){
            loans.add(new String[]{
                rs.getString("LoanID"),
                rs.getString("Name"),
                rs.getString("Amount"),
                rs.getString("Tenure"),
                rs.getString("InterestRate"),
                rs.getString("Status"),
                rs.getString("EMI")
            });
        }
        rs.close(); ps.close(); con.close();
    } catch(Exception e){
        message = "❌ Error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin - Loans</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<style>
body { margin: 0; padding: 0; display: flex; }
.sidebar {
    width: 250px; height: 100vh; background: #0d6efd; color: white;
    position: fixed; top: 0; left: 0; overflow-y: auto;
}
.sidebar .nav-link { color: #d6e4ff; padding: 12px 20px; transition: 0.3s; }
.sidebar .nav-link:hover, .sidebar .nav-link.active { background: #084298; color: white; }
.sidebar .nav-link i { margin-right: 10px; }
.content { margin-left: 250px; padding: 20px; width: 100%; }
</style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
  <h4 class="text-white text-center mb-4">Admin Panel</h4>
  <ul class="nav nav-pills flex-column mb-auto">
    <li><a href="Dashboard.jsp" class="nav-link"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
    <li><a href="ViewCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> View Accounts</a></li>
    <li><a href="ManageCustomers.jsp" class="nav-link"><i class="bi bi-people"></i> Manage Customers</a></li>
    <li><a href="OpenAccount.jsp" class="nav-link"><i class="bi bi-people"></i> Open Accounts</a></li>
    <li><a href="ManageAccounts.jsp" class="nav-link"><i class="bi bi-bank"></i> Manage Accounts</a></li>
    <li><a href="AdminLoans.jsp" class="nav-link active"><i class="bi bi-cash-stack"></i> Loans</a></li>
    <li><a href="Transactions.jsp" class="nav-link"><i class="bi bi-credit-card"></i> Transactions</a></li>
    <li><a href="Logout.jsp" class="nav-link text-warning"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
  </ul>
</div>

<!-- Main Content -->
<div class="content container mt-5">
    <h3 class="mb-3 text-center">💼 Manage Loans</h3>
    <% if(!message.isEmpty()){ %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>
    <table class="table table-bordered text-center">
        <thead class="table-primary">
            <tr>
                <th>LoanID</th><th>Customer</th><th>Amount</th><th>Tenure</th>
                <th>Rate(%)</th><th>Status</th><th>EMI</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
        <% for(String[] loan : loans){ %>
            <tr>
                <% for(int i=0;i<loan.length;i++){ %>
                    <td><%= loan[i] %></td>
                <% } %>
                <td>
                    <% if("Pending".equalsIgnoreCase(loan[5])){ %>
                        <a href="Loans.jsp?loanId=<%=loan[0]%>&action=approve" class="btn btn-success btn-sm">Approve</a>
                        <a href="Loans.jsp?loanId=<%=loan[0]%>&action=reject" class="btn btn-danger btn-sm">Reject</a>
                    <% } else { %>
                        -
                    <% } %>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
