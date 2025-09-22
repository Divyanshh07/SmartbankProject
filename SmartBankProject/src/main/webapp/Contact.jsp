<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - SmartBank</title>
    <style>
    /* Reset */
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', sans-serif;
}


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

/* Contact Section */
.contact {
    display: flex;
    gap: 40px;
    padding: 50px 0;
    flex-wrap: wrap;
}
.contact-form, .contact-info {
    flex: 1 1 400px;
    background-color: #f5f5f5;
    padding: 30px;
    border-radius: 10px;
}
.contact-form h2, .contact-info h2 {
    color: #0a3d62;
    margin-bottom: 20px;
}
.contact-form input, 
.contact-form textarea {
    width: 100%;
    padding: 12px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 5px;
}
.contact-form button {
    background-color: #0a3d62;
    color: #fff;
    border: none;
    padding: 12px 25px;
    cursor: pointer;
    border-radius: 5px;
    transition: 0.3s;
}
.contact-form button:hover {
    background-color: #1e6091;
}

/* Map */
.map {
    margin-bottom: 50px;
}

/* Footer */
footer {
    background-color: #0a3d62;
    color: #fff;
    text-align: center;
    padding: 20px 0;
}

/* Responsive */
@media(max-width:768px){
    .contact {
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
            <h1>Contact SmartBank</h1>
            <p>We are here to help you. Reach out to us for any queries, support, or feedback.</p>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact container">
        <div class="contact-form">
            <h2>Send Us a Message</h2>
            <form action="ContactSubmit.jsp" method="post">
                <input type="text" name="name" placeholder="Your Name" required>
                <input type="email" name="email" placeholder="Your Email" required>
                <input type="text" name="subject" placeholder="Subject" required>
                <textarea name="message" rows="5" placeholder="Your Message" required></textarea>
                <button type="submit">Submit</button>
            </form>
        </div>

        <div class="contact-info">
            <h2>Our Contact Info</h2>
            <p><strong>Address:</strong> 123 SmartBank Street, New Delhi, India</p>
            <p><strong>Phone:</strong> +91 98765 43210</p>
            <p><strong>Email:</strong> support@smartbank.com</p>
            <h3>Working Hours:</h3>
            <p>Mon - Fri: 9:00 AM - 6:00 PM</p>
            <p>Sat: 10:00 AM - 2:00 PM</p>
        </div>
    </section>

    <!-- Map Section -->
    <section class="map">
        <iframe 
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3503.0000000000005!2d77.0000000000000!3d28.0000000000000!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2sSmartBank!5e0!3m2!1sen!2sin!4v0000000000000" 
            width="100%" 
            height="350" 
            style="border:0;" 
            allowfullscreen="" 
            loading="lazy">
        </iframe>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p>&copy; 2025 SmartBank. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
