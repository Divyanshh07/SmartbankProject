<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SmartBank</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar {
            background-color: #0a3d62 !important; /* Dark Blue theme */
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            position: fixed; /* <-- fixes navbar */
            top: 0;
            left: 0;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 10px;
            z-index: 1000; /* makes sure it's on top */
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            transition: 0.3s;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.6rem;
            color: #ffffff !important;
            display: flex;
            align-items: center;
        }
        .navbar-brand img {
            height: 35px;
            width: 35px;
            margin-right: 8px;
        }
        .nav-link {
            font-size: 1.1rem;
            color: #f1f1f1 !important;
        }
        .nav-link:hover {
            color: #ffd32a !important; /* Golden hover effect */
        }
        .dropdown-menu {
            border-radius: 8px;
        }
    </style>
</head>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <!-- Logo + Bank Name -->
        <a class="navbar-brand" href="index.jsp">
            SmartBank
        </a>

        <!-- Toggler -->
        <button class="navbar-toggler bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#bankNavbar" aria-controls="bankNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar links -->
        <div class="collapse navbar-collapse" id="bankNavbar">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <!-- Home -->
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="Home.jsp">Home</a>
                </li>

                <!-- About -->
                <li class="nav-item">
                    <a class="nav-link" href="About.jsp">About</a>
                </li>

                <!-- Contact Us -->
                <li class="nav-item">
                    <a class="nav-link" href="Contact.jsp">Contact Us</a>
                </li>

                <!-- My Account Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        My Account
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <% if(session.getAttribute("username") != null) { %>
                            <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                            <li><a class="dropdown-item" href="settings.jsp">Settings</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                        <% } else { %>
                            <li><a class="dropdown-item" href="Login.jsp">Login</a></li>
                            <li><a class="dropdown-item" href="Register.jsp">Sign Up</a></li>
                        <% } %>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
