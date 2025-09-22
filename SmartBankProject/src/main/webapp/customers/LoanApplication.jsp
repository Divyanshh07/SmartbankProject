<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, conn.Conn" %>
<%
    HttpSession sess = request.getSession(false);
    if(sess == null || !"customer".equals(sess.getAttribute("role"))){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    String email = (String) sess.getAttribute("email");
    String message = "";

    String amountStr = request.getParameter("loanAmount");
    String tenureStr = request.getParameter("tenure");

    if(amountStr != null && tenureStr != null){
        try{
            double amount = Double.parseDouble(amountStr);
            int tenure = Integer.parseInt(tenureStr);

            Connection con = Conn.getCon();
            // Get customer ID
            PreparedStatement psCust = con.prepareStatement("SELECT CustomerID FROM customers WHERE Email=?");
            psCust.setString(1, email);
            ResultSet rsCust = psCust.executeQuery();
            int customerId = 0;
            if(rsCust.next()){
                customerId = rsCust.getInt("CustomerID");

                // Insert loan request
                PreparedStatement psLoan = con.prepareStatement(
                    "INSERT INTO loans(CustomerID, Amount, Tenure) VALUES(?,?,?)"
                );
                psLoan.setInt(1, customerId);
                psLoan.setDouble(2, amount);
                psLoan.setInt(3, tenure);
                int inserted = psLoan.executeUpdate();
                if(inserted > 0){
                    message = "✅ Loan application submitted successfully!";
                } else {
                    message = "❌ Failed to submit loan. Try again!";
                }
                psLoan.close();
            }
            rsCust.close();
            psCust.close();
            con.close();
        } catch(Exception e){
            message = "❌ Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Apply for Loan</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="card p-4 shadow" style="max-width:500px;margin:auto;">
        <h3 class="mb-3 text-center">💰 Apply for Loan</h3>
        <% if(!message.isEmpty()){ %>
            <div class="alert alert-info"><%= message %></div>
        <% } %>
        <form method="post">
            <div class="mb-3">
                <label class="form-label">Loan Amount (₹)</label>
                <input type="number" step="0.01" name="loanAmount" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Tenure (months)</label>
                <input type="number" name="tenure" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-success w-100">Apply</button>
        </form>

        <!-- New buttons -->
        <div class="mt-3 d-grid gap-2">
            <a href="CheckLoanStatus.jsp" class="btn btn-info w-100">Check Status</a>
            <a href="DownloadLoanPDF.jsp" class="btn btn-primary w-100">Download PDF</a>
        </div>

        <a href="CustomerDashboard.jsp" class="btn btn-secondary w-100 mt-3">Back to Dashboard</a>
    </div>
</div>
</body>
</html>
