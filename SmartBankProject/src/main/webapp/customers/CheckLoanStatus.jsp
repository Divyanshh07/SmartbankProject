<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, conn.Conn" %>
<%
    HttpSession sess = request.getSession(false);
    if(sess == null || !"customer".equals(sess.getAttribute("role"))){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
    String email = (String) sess.getAttribute("email");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Loans</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-3 text-center">📄 My Loans</h3>

    <table class="table table-bordered text-center">
        <thead class="table-primary">
            <tr>
                <th>LoanID</th><th>Amount</th><th>Tenure</th><th>Rate(%)</th><th>Status</th><th>EMI</th><th>Agreement</th>
            </tr>
        </thead>
        <tbody>
<%
    try{
        Connection con = Conn.getCon();
        PreparedStatement ps = con.prepareStatement(
            "SELECT l.LoanID, l.Amount, l.Tenure, l.InterestRate, l.Status, l.EMI FROM loans l " +
            "JOIN customers c ON l.CustomerID=c.CustomerID WHERE c.Email=? ORDER BY l.AppliedAt DESC"
        );
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        while(rs.next()){
%>
            <tr>
                <td><%= rs.getInt("LoanID") %></td>
                <td>₹<%= rs.getDouble("Amount") %></td>
                <td><%= rs.getInt("Tenure") %> months</td>
                <td><%= rs.getDouble("InterestRate") %></td>
                <td><%= rs.getString("Status") %></td>
                <td><%= rs.getDouble("EMI") > 0 ? "₹" + String.format("%.2f", rs.getDouble("EMI")) : "-" %></td>
                <td>
                    <% if("Approved".equals(rs.getString("Status"))){ %>
                        <a href="LoanAgreementPDF.jsp?loanId=<%= rs.getInt("LoanID") %>" class="btn btn-warning btn-sm" target="_blank">
                            <i class="bi bi-file-earmark-pdf"></i> Download
                        </a>
                    <% } else { %>
                        -
                    <% } %>
                </td>
            </tr>
<%
        }
        rs.close(); ps.close(); con.close();
    }catch(Exception e){ out.println("Error: "+e.getMessage()); }
%>
        </tbody>
    </table>

    <a href="CustomerDashboard.jsp" class="btn btn-primary w-100 mt-3">Back to Dashboard</a>
</div>
</body>
</html>
