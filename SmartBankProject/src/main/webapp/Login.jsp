<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SmartBank-Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Raleway:wght@400;700&display=swap" rel="stylesheet">
<style>
    body {
        font-family: 'Raleway', sans-serif;
        background: #f4f6f9;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }
    .login-card {
        max-width: 400px;
        width: 100%;
        padding: 2rem;
        border-radius: 1rem;
        box-shadow: 0 0.5rem 1.5rem rgba(0,0,0,0.15);
        background: #fff;
        margin: auto;
        margin-top: 4rem;
    }
    .login-card h2 {
        font-weight: 700;
    }
    .login-card .welcome-text {
        font-size: 0.9rem;
        color: #555;
        margin-bottom: 1.5rem;
        text-align: center;
    }
    .form-control-sm, .btn-sm {
        border-radius: 0.5rem;
    }
</style>
</head>
<body>
<%@ include file="Navbar.jsp" %>

<!-- Login Card -->
<div class="login-card">
    <h2 class="text-center mb-2">
        <i class="bi bi-box-arrow-in-right me-2"></i>Login
    </h2>

    <% 
    String msg = request.getParameter("msg");
    if("invalid".equals(msg)){
    %>
    <div class="alert alert-danger small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i> Invalid Email or Password.
    </div>
    <% } %>

    <form action="LoginProcess.jsp" method="post">
        <div class="mb-3">
            <label class="form-label small">Email Address</label>
            <input type="email" name="email" class="form-control form-control-sm" placeholder="Enter email" required>
        </div>

        <div class="mb-3">
            <label class="form-label small">Password</label>
            <input type="password" name="pass" class="form-control form-control-sm" placeholder="Enter password" required>
        </div>

        <div class="d-grid mb-3">
            <button type="submit" class="btn btn-success btn-sm py-2">
                <i class="bi bi-box-arrow-in-right me-1"></i>Login
            </button>
        </div>
    </form>

    <!-- Extra Options -->
    <div class="text-center small">
        <p><a href="ForgotPassword.jsp">Forgot Password?</a></p>
        <p>Don’t have an account? <a href="Register.jsp" class="fw-bold text-primary">Sign Up</a></p>
    </div>
</div>

</body>
</html>
