<%@ page import="java.sql.*, conn.Conn" %>
<%
    String reqIdParam = request.getParameter("requestId");
    if (reqIdParam == null || reqIdParam.trim().isEmpty()) {
        response.sendRedirect("ManageAccounts.jsp?msg=invalidId");
        return;
    }

    int requestId = Integer.parseInt(reqIdParam);

    Connection con = null;
    PreparedStatement ps = null, ps2 = null, ps3 = null;
    ResultSet rs = null;

    try {
        con = Conn.getCon();

        // ✅ Get request details
        ps = con.prepareStatement("SELECT * FROM account_requests WHERE RequestID=? AND Status='Pending'");
        ps.setInt(1, requestId);
        rs = ps.executeQuery();

        if (rs.next()) {
            int customerId = rs.getInt("CustomerID");
            String accountType = rs.getString("AccountType");
            double deposit = rs.getDouble("Deposit");

            // ✅ Generate account number
            String accountNumber = "SB" + (long)(Math.random() * 10000000000L);

            // ✅ Insert into accounts
            ps2 = con.prepareStatement(
                "INSERT INTO accounts(CustomerID, AccountNumber, AccountType, Balance) VALUES (?,?,?,?)"
            );
            ps2.setInt(1, customerId);
            ps2.setString(2, accountNumber);
            ps2.setString(3, accountType);
            ps2.setDouble(4, deposit);
            ps2.executeUpdate();

            // ✅ Update request status
            ps3 = con.prepareStatement("UPDATE account_requests SET Status='Approved' WHERE RequestID=?");
            ps3.setInt(1, requestId);
            ps3.executeUpdate();

            response.sendRedirect("ManageAccounts.jsp?msg=approved");
        } else {
            response.sendRedirect("ManageAccounts.jsp?msg=notFound");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("ManageAccounts.jsp?msg=error");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ex) {}
        if (ps != null) try { ps.close(); } catch (Exception ex) {}
        if (ps2 != null) try { ps2.close(); } catch (Exception ex) {}
        if (ps3 != null) try { ps3.close(); } catch (Exception ex) {}
        if (con != null) try { con.close(); } catch (Exception ex) {}
    }
%>
