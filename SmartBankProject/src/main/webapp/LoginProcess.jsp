<%@ page import="conn.Conn, java.sql.*" %>
<%
String email = request.getParameter("email");
String pass = request.getParameter("pass");

Connection db = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    db = Conn.getCon();

    // --- Admin Login ---
    ps = db.prepareStatement("SELECT AdminID, Name, Email FROM admin WHERE Email=? AND Password=?");
    ps.setString(1, email);
    ps.setString(2, pass);
    rs = ps.executeQuery();

    if(rs.next()){
        session.setAttribute("role","admin");
        session.setAttribute("adminId", rs.getInt("AdminID"));
        session.setAttribute("username", rs.getString("Name"));
        session.setAttribute("email", rs.getString("Email"));

        rs.close(); ps.close(); db.close();
        response.sendRedirect("admin/AdminDashboard.jsp");
        return;
    }
    rs.close(); ps.close();

    // --- Employee Login ---
    ps = db.prepareStatement("SELECT EmployeeID, Name, Email FROM employees WHERE Email=? AND Password=?");
    ps.setString(1,email);
    ps.setString(2,pass);
    rs = ps.executeQuery();

    if(rs.next()){
        session.setAttribute("role","employee");
        session.setAttribute("employeeId", rs.getInt("EmployeeID"));
        session.setAttribute("username", rs.getString("Name"));
        session.setAttribute("email", rs.getString("Email"));

        rs.close(); ps.close(); db.close();
        response.sendRedirect("employees/EmployeeHome.jsp");
        return;
    }
    rs.close(); ps.close();

    // --- Customer Login ---
    ps = db.prepareStatement("SELECT CustomerID, Name, Email FROM customers WHERE Email=? AND Password=?");
    ps.setString(1,email);
    ps.setString(2,pass);
    rs = ps.executeQuery();

    if(rs.next()){
        int custId = rs.getInt("CustomerID");
        session.setAttribute("role","customer");
        session.setAttribute("customerId", custId);
        session.setAttribute("username", rs.getString("Name"));
        session.setAttribute("email", rs.getString("Email"));

        rs.close(); ps.close();

        // Check if customer already has account
        ps = db.prepareStatement("SELECT * FROM accounts WHERE CustomerID=?");
        ps.setInt(1, custId);
        rs = ps.executeQuery();

        if(rs.next()){
            rs.close(); ps.close(); db.close();
            response.sendRedirect("customers/CustomerDashboard.jsp");
        } else {
            rs.close(); ps.close(); db.close();
            response.sendRedirect("customers/OpenAccount.jsp");
        }
        return;
    }

    rs.close(); ps.close(); db.close();
    response.sendRedirect("Login.jsp?msg=invalid");

} catch(Exception e){
    e.printStackTrace();
    try { if(rs != null) rs.close(); } catch(Exception ex) {}
    try { if(ps != null) ps.close(); } catch(Exception ex) {}
    try { if(db != null) db.close(); } catch(Exception ex) {}
    response.sendRedirect("Login.jsp?msg=error");
}
%>
