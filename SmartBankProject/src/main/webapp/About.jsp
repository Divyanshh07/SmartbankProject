<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - SmartBank</title>
    <style>
    
/* Hero Section */
.hero {
    background-color: #f5f5f5;
    padding: 80px 20px;
    text-align: center;
}
.hero h1 {
    font-size: 42px;
    margin-bottom: 20px;
}
.hero p {
    font-size: 18px;
    max-width: 700px;
    margin: 0 auto;
    color: #333;
}

/* Mission & Vision */
.mission-vision {
    display: flex;
    gap: 20px;
    margin: 50px 0;
    flex-wrap: wrap;
}
.mission-vision .card {
    flex: 1 1 45%;
    background-color: #0a3d62;
    color: #fff;
    padding: 30px;
    border-radius: 10px;
    min-width: 250px;
}

/* Values Section */
.values h2 {
    text-align: center;
    margin-bottom: 40px;
    font-size: 32px;
    color: #0a3d62;
}
.values-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
}
.value-card {
    flex: 1 1 220px;
    background-color: #e0e0e0;
    padding: 25px;
    border-radius: 10px;
    text-align: center;
}
.value-card h3 {
    color: #0a3d62;
    margin-bottom: 10px;
}

/* Team Section */
.team h2 {
    text-align: center;
    margin-bottom: 40px;
    font-size: 32px;
    color: #0a3d62;
}
.team-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
}
.team-member {
    flex: 1 1 200px;
    background-color: #f5f5f5;
    border-radius: 10px;
    text-align: center;
    padding: 20px;
}
.team-member img {
    width: 100%;
    border-radius: 50%;
    height: 200px;
    object-fit: cover;
    margin-bottom: 15px;
}
.team-member h4 {
    color: #0a3d62;
    margin-bottom: 5px;
}
.team-member p {
    color: #333;
}

/* Footer */
footer {
    background-color: #0a3d62;
    color: #fff;
    text-align: center;
    padding: 20px 0;
    margin-top: 50px;
}

/* Responsive */
@media(max-width:768px){
    .mission-vision {
        flex-direction: column;
    }
    .navbar .nav-links {
        flex-direction: column;
        gap: 10px;
    }
}
    
    
    </style>
</head>
<body>
<%@include file="Navbar.jsp" %>
    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>About SmartBank</h1>
            <p>Your trusted partner in secure, digital banking. We combine technology and finance to provide seamless banking solutions for all.</p>
        </div>
    </section>

    <!-- Mission & Vision -->
    <section class="mission-vision container">
        <div class="card">
            <h2>Our Mission</h2>
            <p>To empower our customers with innovative banking solutions that are simple, safe, and accessible anytime, anywhere.</p>
        </div>
        <div class="card">
            <h2>Our Vision</h2>
            <p>To be the most customer-centric digital bank in India, delivering excellence through trust, innovation, and integrity.</p>
        </div>
    </section>

    <!-- Values Section -->
    <section class="values container">
        <h2>Our Core Values</h2>
        <div class="values-grid">
            <div class="value-card">
                <h3>Trust</h3>
                <p>We maintain the highest standards of transparency and integrity.</p>
            </div>
            <div class="value-card">
                <h3>Innovation</h3>
                <p>We embrace technology to offer smarter banking solutions.</p>
            </div>
            <div class="value-card">
                <h3>Customer Focus</h3>
                <p>Our decisions are guided by the needs and satisfaction of our customers.</p>
            </div>
            <div class="value-card">
                <h3>Security</h3>
                <p>Protecting your data and transactions is our top priority.</p>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team container">
        <h2>Meet Our Team</h2>
        <div class="team-grid">
            <div class="team-member">
                <img src="images/team1.jpg" alt="CEO">
                <h4>Rahul Verma</h4>
                <p>CEO & Founder</p>
            </div>
            <div class="team-member">
                <img src="images/team2.jpg" alt="CTO">
                <h4>Priya Sharma</h4>
                <p>CTO</p>
            </div>
            <div class="team-member">
                <img src="images/team3.jpg" alt="COO">
                <h4>Anil Kumar</h4>
                <p>COO</p>
            </div>
            <div class="team-member">
                <img src="images/team4.jpg" alt="CFO">
                <h4>Neha Singh</h4>
                <p>CFO</p>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p>&copy; 2025 SmartBank. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
