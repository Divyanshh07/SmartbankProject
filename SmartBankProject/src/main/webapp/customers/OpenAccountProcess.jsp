<%@ page import="conn.Conn, java.sql.*" %>
<%
int customerId = Integer.parseInt(request.getParameter("customerId"));
String accountType = request.getParameter("accountType");
double deposit = Double.parseDouble(request.getParameter("deposit"));

try {
    Connection con = Conn.getCon();

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO account_requests(CustomerID, AccountType, Deposit, Status) VALUES(?,?,?,?)"
    );
    ps.setInt(1, customerId);
    ps.setString(2, accountType);
    ps.setDouble(3, deposit);
    ps.setString(4, "Pending");

    int rows = ps.executeUpdate();
    ps.close();
    con.close();

    if(rows > 0){
        response.sendRedirect("CustomerDashboard.jsp?msg=requestSent");
    } else {
        response.sendRedirect("OpenAccount.jsp?msg=error");
    }

} catch(Exception e){
    e.printStackTrace();
    response.sendRedirect("OpenAccount.jsp?msg=error");
}
%>
