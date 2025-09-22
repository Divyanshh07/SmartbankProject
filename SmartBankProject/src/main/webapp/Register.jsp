<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SmartBank-CustomerRegister</title>
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
    .signup-card {
        max-width: 400px;
        width: 100%;
        padding: 2rem;
        border-radius: 1rem;
        box-shadow: 0 0.5rem 1.5rem rgba(0,0,0,0.15);
        background: #fff;
        margin: 3rem auto;
    }
    .signup-card h2 {
        font-weight: 700;
    }
    .form-control-sm {
        border-radius: 0.5rem;
    }
    .btn-sm {
        border-radius: 0.5rem;
    }
</style>
</head>
<body>
<%@include file="Navbar.jsp" %>

<!-- Register Form -->
<div class="signup-card">

    <h2 class="text-center mb-4 "><i class="bi bi-person-plus-fill me-2"></i>Create Account</h2>

    <% String msg = request.getParameter("msg"); %>
    <% if("invalid".equals(msg)){ %>
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-1"></i> Email ID already exists. Please use another email.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% } else if("error".equals(msg)){ %>
      <div class="alert alert-warning alert-dismissible fade show small" role="alert">
        <i class="bi bi-exclamation-circle-fill me-1"></i> Something went wrong! Please try again later.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% } else if("failed".equals(msg)){ %>
      <div class="alert alert-danger alert-dismissible fade show small" role="alert">
        <i class="bi bi-x-circle-fill me-1"></i> Registration failed. Please try again.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% } %>

    <form action="RegisterProcess.jsp" method="post">
        <!-- Full Name -->
        <div class="mb-3">
            <label class="form-label small">Name</label>
            <input type="text" name="name" class="form-control form-control-sm" placeholder="Enter full name" required>
        </div>

        <!-- Email -->
        <div class="mb-3">
            <label class="form-label small">Email Address</label>
            <input type="email" name="email" class="form-control form-control-sm" placeholder="name@example.com" required>
        </div>

        <!-- Phone -->
        <div class="mb-3">
            <label class="form-label small">Phone</label>
            <input type="phone" name="phone" class="form-control form-control-sm" placeholder="Enter phone No" required>
        </div>

        <!-- Address -->
        <div class="mb-3">
            <label class="form-label small">Address/Role</label>
            <input type="address" name="extra" class="form-control form-control-sm" placeholder="Enter Address" required>
        </div>
        
        <!-- Password -->
        <div class="mb-3">
            <label class="form-label small">Password</label>
            <input type="password" name="password" class="form-control form-control-sm" placeholder="Enter password" required>
        </div>
        
        <!-- RegisterAs -->
        <div class="mb-3">
                <label class="form-label">Register As</label>
                <select name="register" class="form-select" required>
                    <option value="customer">Customer</option>
                    <option value="employee">Employee</option>
                </select>
         </div>        
                        
        <!-- Checkbox -->
        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" required>
            <label class="form-check-label small">I confirm that the above information is correct</label>
        </div>

        <!-- Submit -->
        <div class="d-grid mb-3">
            <button type="submit" class="btn btn-success btn-sm py-2">
              <i class="bi bi-check-circle me-1"></i> Register
            </button>
        </div>
    </form>

    <div class="text-center small">
        <p>Already have an account? <a href="Login.jsp">Login</a></p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
