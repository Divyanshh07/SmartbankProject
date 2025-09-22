<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbs.jsp" %> <!-- ✅ Your DB connection file -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SmartBank - Modern Banking</title>
<link rel="stylesheet" type="text/css" href="Style.css">


</head>
<body>
<%@include file="Navbar.jsp" %>

    <!-- Hero Slider -->
    <section class="hero">
        <div class="hero-slide active" style="background-image:url('https://images.pexels.com/photos/8353786/pexels-photo-8353786.jpeg');"></div>
        <div class="hero-slide" style="background-image:url('https://images.pexels.com/photos/2988232/pexels-photo-2988232.jpeg');"></div>
        <div class="hero-slide" style="background-image:url('https://images.pexels.com/photos/5716000/pexels-photo-5716000.jpeg');"></div>
        <div class="hero-slide" style="background-image:url('https://images.pexels.com/photos/7231804/pexels-photo-7231804.jpeg');"></div>
        <div class="hero-slide" style="background-image:url('https://images.pexels.com/photos/7567487/pexels-photo-7567487.jpeg');"></div>
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <h1>SmartBank - Your Modern Banking Partner</h1>
            <p>Safe, fast, and intuitive banking experience anytime, anywhere.</p>
            <a href="Login.jsp" style="padding:10px 20px; background:#ffc107; color:white; border-radius:5px; text-decoration:none;">Get Started</a>
            
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <h2>Our Key Services</h2>
        <div class="feature-cards">
            <div class="feature-card">
                <img src="https://images.pexels.com/photos/7691672/pexels-photo-7691672.jpeg"/>
                <h3>Savings Account</h3>
                <p>Grow your wealth with high interest savings and zero hassle banking.</p>
            </div>
            <div class="feature-card">
                <img src="https://images.pexels.com/photos/3831185/pexels-photo-3831185.jpeg"/>
                <h3>Credit Cards</h3>
                <p>Flexible credit options with rewards and cashback on all transactions.</p>
            </div>
            <div class="feature-card">
                <img src="https://images.pexels.com/photos/7231804/pexels-photo-7231804.jpeg"/>
                <h3>Loans</h3>
                <p>Quick approvals for personal, education, and home loans.</p>
            </div>
            <div class="feature-card">
                <img src="https://images.pexels.com/photos/5716044/pexels-photo-5716044.jpeg"/>
                <h3>Online Banking</h3>
                <p>Access all your accounts, pay bills, and transfer funds securely online.</p>
            </div>
        </div>
    </section>

<!-- Modern Promotional Section -->
<section class="promo-modern">
    <div class="promo-container">
        <!-- Left: Text Content -->
        <div class="promo-left">
            <h2>Bank Smarter with SmartBank</h2>
            <p>Open your account today and enjoy seamless banking, instant approvals, and personalized financial services. Your money, your way!</p>
            <a href="Login.jsp" style="padding:10px 20px; background:#0a3d62; color:yellow; border-radius:5px; text-decoration:none;">Get Started</a>
            
            
        </div>

        <!-- Right: Image -->
        <div class="promo-right">
            <img src="https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg" alt="SmartBank Promo">
        </div>
    </div>
</section>

<!-- Bank Gallery Section -->
<section class="bank-gallery">
    <h2>Our Bank Gallery</h2>
    <div class="gallery-container">
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/8353786/pexels-photo-8353786.jpeg" alt="Bank Branch">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/2988232/pexels-photo-2988232.jpeg" alt="ATM">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/12885861/pexels-photo-12885861.jpeg" alt="Bank Event">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/4968639/pexels-photo-4968639.jpeg" alt="Customer Service">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/4968384/pexels-photo-4968384.jpeg" alt="Bank Team">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/265087/pexels-photo-265087.jpeg" alt="Financial Services">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/259091/pexels-photo-259091.jpeg" alt="Bank Team">
        </div>
        <div class="gallery-item">
            <img src="https://images.pexels.com/photos/4386373/pexels-photo-4386373.jpeg" alt="Financial Services">
        </div>
    </div>
</section>
 
<%

    // ✅ Handle form submission (Insert into DB)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("customerName");
        String comment = request.getParameter("comment");
        if (name != null && comment != null && !name.trim().isEmpty() && !comment.trim().isEmpty()) {
            try (Connection con = getConnection()) {
                String insertSQL = "INSERT INTO reviews (CustomerName, Comment) VALUES (?, ?)";
                PreparedStatement ps = con.prepareStatement(insertSQL);
                ps.setString(1, name);
                ps.setString(2, comment);
                ps.executeUpdate();
                ps.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error saving review: " + e.getMessage() + "</p>");
            }
        }
    }
%>

<!-- Customer Reviews Section -->
<section class="customer-reviews" style="padding:40px 20px; text-align:center; background:#f5f6fa;">
    <h2 style="font-size:28px; margin-bottom:30px; color:#0a3d62;">What Our Customers Say</h2>
    <div class="reviews-container" style="display:flex; flex-wrap:wrap; justify-content:center; gap:20px;">

        <%
            try (Connection con = getConnection()) {
                String query = "SELECT CustomerName, Comment FROM reviews ORDER BY CreatedAt DESC LIMIT 6";
                PreparedStatement ps = con.prepareStatement(query);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    String comment = rs.getString("Comment");
                    String name = rs.getString("CustomerName");
        %>
            <div class="review-card" style="background:#fff; padding:20px; border-radius:12px; max-width:300px; box-shadow:0 4px 10px rgba(0,0,0,0.1); font-style:italic;">
                <p style="font-size:16px; color:#2f3640;">“<%= comment %>”</p>
                <h4 style="margin-top:15px; color:#0a3d62; font-weight:bold;">- <%= name %></h4>
            </div>
        <%
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error loading reviews: " + e.getMessage() + "</p>");
            }
        %>

    </div>
</section>


<!-- Footer -->
<footer style="background-color:#0a3d62; color:#fff; padding:40px 20px 20px;">
    <div class="footer-container" style="display:flex; flex-wrap:wrap; justify-content:space-between; max-width:1200px; margin:auto;">

        <!-- About & Logo -->
        <div class="footer-section" style="flex:1; min-width:250px; margin:15px;">
            <h3 style="color:#f1c40f; font-size:22px; margin-bottom:10px;">SmartBank</h3>
            <p>Your trusted partner for modern, secure, and convenient banking solutions.</p>
        </div>

        <!-- Quick Links -->
        <div class="footer-section" style="flex:1; min-width:200px; margin:15px;">
            <h4 style="color:#f1c40f; margin-bottom:10px;">Quick Links</h4>
            <ul style="list-style:none; padding:0; line-height:1.8;">
                <li><a href="Home.jsp" style="color:#fff; text-decoration:none;">Home</a></li>
                <li><a href="Service.jsp" style="color:#fff; text-decoration:none;">Services</a></li>
                <li><a href="Promotion.jsp" style="color:#fff; text-decoration:none;">Promotions</a></li>
                <li><a href="Testimonial.jsp" style="color:#fff; text-decoration:none;">Testimonials</a></li>
                <li><a href="Gallery.jsp" style="color:#fff; text-decoration:none;">Gallery</a></li>
                <li><a href="Contact.jsp" style="color:#fff; text-decoration:none;">Contact</a></li>
            </ul>
        </div>

        <!-- Contact Info -->
        <div class="footer-section" style="flex:1; min-width:250px; margin:15px;">
            <h4 style="color:#f1c40f; margin-bottom:10px;">Contact Us</h4>
            <p><strong>Email:</strong> support@smartbank.com</p>
            <p><strong>Phone:</strong> +91 9634834846</p>
            <p><strong>Address:</strong>Noida sector 15 ,Uttar pradesh, India</p>
        </div>

        <!-- Review Submission Form -->
        <div class="footer-section" style="flex:1; min-width:300px; margin:15px;">
            <h4 style="color:#f1c40f; margin-bottom:10px;">Leave Your Feedback</h4>
            <form method="post" action="" style="display:flex; flex-direction:column;">
                <input type="text" name="customerName" placeholder="Your Name" required 
                       style="padding:10px; margin-bottom:10px; border:none; border-radius:5px;">
                <textarea name="comment" placeholder="Write your feedback..." required 
                          style="padding:10px; margin-bottom:10px; border:none; border-radius:5px;"></textarea>
                <button type="submit" 
                        style="background:#f1c40f; color:#0a3d62; border:none; padding:10px; border-radius:5px; cursor:pointer;">
                    Submit
                </button>
            </form>
        </div>
    </div>

    <!-- Social Icons -->
    <div style="text-align:center; margin-top:20px;">
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/ffffff/facebook-new.png" style="margin:0 8px;"/></a>
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/ffffff/twitter.png" style="margin:0 8px;"/></a>
        <a href="#"><img src="https://img.icons8.com/ios-filled/20/ffffff/linkedin.png" style="margin:0 8px;"/></a>
    </div>

    <!-- Footer Bottom -->
    <div class="footer-bottom" style="text-align:center; margin-top:20px; font-size:14px; border-top:1px solid rgba(255,255,255,0.2); padding-top:10px;">
        <p>&copy; 2025 SmartBank. All Rights Reserved.</p>
    </div>
</footer>
   
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>
