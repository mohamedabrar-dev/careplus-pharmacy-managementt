<%-- 
    Document   : deletemedicine
    Created on : Feb 5, 2026, 11:24:10 AM
    Author     : admin
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    String name = "Unknown Product";
    try {
        Connection con = new dbconfig().getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT name FROM medicines WHERE id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){ name = rs.getString("name"); }
        con.close();
    } catch(Exception e) { }
%>

<!DOCTYPE html>
<html>
<head>
    <title>CarePlus | Delete Medicine</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background: #0f172a; height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; }
        .delete-card {
            background: #1e293b; padding: 40px; border-radius: 24px; text-align: center;
            width: 100%; max-width: 450px; border: 1px solid rgba(255,255,255,0.1);
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            animation: fadeIn 0.5s ease;
        }
        @keyframes fadeIn { from { opacity:0; transform: scale(0.95); } to { opacity:1; transform: scale(1); } }
        .icon-warn { font-size: 60px; color: #f43f5e; margin-bottom: 20px; }
        h2 { color: white; margin: 0 0 10px; font-weight: 800; }
        p { color: #94a3b8; font-size: 15px; margin-bottom: 25px; }
        .item-name { background: rgba(244, 63, 94, 0.1); color: #f43f5e; padding: 12px; border-radius: 12px; font-weight: 700; font-size: 18px; margin-bottom: 30px; border: 1px solid rgba(244, 63, 94, 0.2); }
        .btn-row { display: flex; gap: 15px; }
        .btn-delete { flex: 2; background: #f43f5e; color: white; border: none; padding: 15px; border-radius: 12px; font-weight: 700; cursor: pointer; transition: 0.3s; }
        .btn-delete:hover { background: #e11d48; transform: translateY(-2px); }
        .btn-cancel { flex: 1; background: #334155; color: white; text-decoration: none; padding: 15px; border-radius: 12px; font-weight: 700; display: flex; align-items: center; justify-content: center; transition: 0.3s; }
        .btn-cancel:hover { background: #475569; }
    </style>
</head>
<body>

<div class="delete-card">
    <i class="fas fa-exclamation-triangle icon-warn"></i>
    <h2>Confirm Deletion</h2>
    <p>This action cannot be undone. Are you sure you want to remove this medicine from inventory?</p>
    
    <div class="item-name"><%= name %></div>

    <form action="delete" method="get">
        <input type="hidden" name="id" value="<%= id %>">
        <div class="btn-row">
            <a href="inventory.jsp" class="btn-cancel">Cancel</a>
            <button type="submit" class="btn-delete">Yes, Delete Item</button>
        </div>
    </form>
</div>

</body>
</html>