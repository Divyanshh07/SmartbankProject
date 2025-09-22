<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width: 500px;">
    <div class="card shadow-sm">
        <div class="card-body">
            <h4 class="card-title mb-4 text-center">Forgot Password</h4>

            <form method="post" action="ResetPassword.jsp">
                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>

                <div class="mb-3">
                    <label for="userType" class="form-label">User Type</label>
                    <select class="form-select" id="userType" name="userType" required>
                        <option value="" selected disabled>Select User Type</option>
                        <option value="customer">Customer</option>
                        <option value="employee">Employee</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>

                <button type="submit" class="btn btn-primary w-100">Reset Password</button>
            </form>

            <div class="mt-3 text-center">
                <a href="Login.jsp">Back to Login</a>
            </div>

            <div class="mt-2 text-center text-danger">
                <%= request.getParameter("msg") != null ? request.getParameter("msg") : "" %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
