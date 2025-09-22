<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*, conn.Conn" %>
<%
    // Validate session
    if(session == null || !"customer".equals(session.getAttribute("role"))){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }

    Integer customerIdObj = (Integer) session.getAttribute("customerId");
    if(customerIdObj == null){
        response.sendRedirect("../Login.jsp?msg=unauthorized");
        return;
    }
    int customerId = customerIdObj;
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Open New Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow-lg p-4">
        <div class="card-header bg-primary text-white text-center">
            <h3>Open a New Bank Account</h3>
            <small>Welcome, <%= username %></small>
        </div>
        <div class="card-body">
            <form action="OpenAccountProcess.jsp" method="post">
                <input type="hidden" name="customerId" value="<%= customerId %>">
                <div class="mb-3">
                    <label class="form-label">Account Type</label>
                    <select name="accountType" class="form-control" required>
                        <option value="">-- Select --</option>
                        <option value="Savings">Savings Account</option>
                        <option value="Current">Current Account</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Initial Deposit</label>
                    <input type="number" name="deposit" class="form-control" min="500" placeholder="Minimum 500 rupees" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Open Account</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
