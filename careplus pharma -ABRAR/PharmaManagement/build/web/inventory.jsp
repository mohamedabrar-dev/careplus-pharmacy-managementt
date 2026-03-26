<%-- 
    Document   : inventory
    Created on : Dec 31, 2025, 12:05:50 PM
    Author     : admin
--%>
<%-- Inventory Page (DB Connected, Styled) --%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

if(session.getAttribute("username") == null){
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Inventory Master - CAREPLUS</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
    body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0;}
    .main-content { margin-left: 240px; padding: 40px; transition: 0.3s; }
    
    .inventory-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; }
    
    .control-bar { 
        background: white; padding: 20px; border-radius: 16px; 
        display: flex; gap: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        margin-bottom: 30px; align-items: center;
    }
    
    .search-input { 
        flex: 2; border: 1.5px solid #e2e8f0; padding: 12px 20px; 
        border-radius: 12px; font-size: 14px; outline: none; transition: 0.3s;
    }
    .search-input:focus { border-color: #6366f1; box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }

    .data-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; }
    .data-table thead th { padding: 0 20px 10px; text-align: left; font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: 700; letter-spacing: 1px;}
    .data-table tbody tr { background: white; border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: 0.3s; }
    .data-table tbody tr:hover { transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
    .data-table td { padding: 18px 20px; border: none; }

    .status-pill { padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 700; text-transform: uppercase; display: inline-block;}
    .stock-high { background: #dcfce7; color: #166534; }
    .stock-low { background: #fef9c3; color: #854d0e; }
    .stock-out { background: #fee2e2; color: #991b1b; }

    .btn-action { 
        padding: 10px 18px; border-radius: 10px; text-decoration: none; 
        font-size: 13px; font-weight: 700; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-edit { background: #eef2ff; color: #4338ca; border: 1px solid #c7d2fe; }
    .btn-edit:hover { background: #4338ca; color: white; }
    .btn-delete { background: #fff1f2; color: #be123c; border: 1px solid #fecdd3; cursor: pointer; }
    .btn-delete:hover { background: #be123c; color: white; }

    .btn-restock { background: #10b981; color: white; border: none; padding: 14px 28px; border-radius: 14px; font-weight: 700; cursor: pointer; }

    /* AUTO-HIDE TOAST STYLING */
    #statusAlert {
        position: fixed; top: 30px; right: 30px; z-index: 10001;
        padding: 16px 24px; border-radius: 16px; 
        display: flex; align-items: center; gap: 12px; font-weight: 600;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        animation: slideInRight 0.5s ease-out forwards;
    }
    @keyframes slideInRight { 
        from { transform: translateX(100%); opacity: 0; } 
        to { transform: translateX(0); opacity: 1; } 
    }
    @keyframes fadeOut { 
        from { opacity: 1; } 
        to { opacity: 0; } 
    }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp"/>

<div class="app-wrapper">
    <div class="main-content">
       <div class="inventory-header">
            <div>
                <h1 style="margin:0; font-weight: 850; font-size: 32px; letter-spacing: -1px; color: #0f172a;">Inventory Control</h1>
                <p style="color: #64748b; margin: 5px 0 0; font-size: 15px;">Manage your pharmaceutical stock and assets.</p>
            </div>
            <button class="btn-restock" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Add New Medicine
            </button>
        </div>

        <%-- AUTO-HIDING TOAST MESSAGE --%>
        <% 
            String msg = request.getParameter("msg"); 
            if(msg != null) { 
                String bgColor = "#dcfce7", textColor = "#15803d", icon = "fa-check-circle", text = "Success!";
                if(msg.equals("deleted")) text = "Medicine successfully removed.";
                if(msg.equals("used")) { bgColor = "#fee2e2"; textColor = "#991b1b"; icon = "fa-ban"; text = "Action Denied: Item in use."; }
                if(msg.equals("error")) { bgColor = "#fef9c3"; textColor = "#854d0e"; icon = "fa-exclamation-triangle"; text = "Database Error."; }
        %>
            <div id="statusAlert" style="background: <%=bgColor%>; color: <%=textColor%>; border: 1px solid <%=textColor%>44;">
                <i class="fas <%=icon%>"></i>
                <span><%=text%></span>
            </div>
            <script>
                setTimeout(() => {
                    const alert = document.getElementById('statusAlert');
                    alert.style.animation = 'fadeOut 0.5s ease-out forwards';
                    setTimeout(() => alert.remove(), 500);
                }, 3000); // Disappears after 3 seconds
            </script>
        <% } %>

        <div class="control-bar">
            <input type="text" id="searchInv" placeholder="Quick search..." class="search-input" onkeyup="searchInventory()">
            <select class="search-input" style="flex: 1;" onchange="filterCategory(this.value)">
                <option value="ALL">All Categories</option>
                <% 
                   try { 
                       Connection con = new dbconfig().getConnection(); 
                       ResultSet rsCat = con.createStatement().executeQuery("SELECT name FROM categories ORDER BY name");
                       while(rsCat.next()){ %> <option><%=rsCat.getString("name")%></option> <% }
                       con.close();
                   } catch(Exception e){} 
                %>
            </select>
        </div>

        <table class="data-table" id="medicineTable">
            <thead>
                <tr>
                    <th>Medicine Details</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock Level</th>
                    <th>Expiry</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    Connection con = new dbconfig().getConnection();
                    ResultSet rs = con.createStatement().executeQuery("SELECT * FROM medicines ORDER BY id DESC");
                    while(rs.next()) {
                        int stock = rs.getInt("stock");
                        String statusClass = (stock > 20) ? "stock-high" : (stock > 0 ? "stock-low" : "stock-out");
                        String statusText = (stock > 20) ? "In Stock" : (stock > 0 ? "Low" : "Out");
                %>
                <tr data-category="<%=rs.getString("category")%>">
                    <td style="width: 250px;">
                        <div style="font-weight: 700; color: #1e293b; font-size: 15px;"><%=rs.getString("name")%></div>
                        <div style="font-size: 12px; color: #94a3b8;"><%=rs.getString("generic_name")%></div>
                    </td>
                    <td><span style="background:#f1f5f9; padding:5px 12px; border-radius:8px; font-size:12px; font-weight:600;"><%=rs.getString("category")%></span></td>
                    <td style="font-weight: 700; color: #0f172a;">₹<%=String.format("%.2f", rs.getDouble("price"))%></td>
                    <td>
                        <div class="status-pill <%=statusClass%>"><%=statusText%></div>
                        <%-- FIXED: SIDE BY SIDE QTY AND UNIT --%>
                        <div style="display: flex; align-items: center; gap: 4px; font-size: 13px; color: #64748b; font-weight: 600; margin-top: 4px;">
                            <span><%=stock%></span>
                            <span style="color: #94a3b8; font-size: 10px; text-transform: uppercase;"><%=rs.getString("unit")%></span>
                        </div>
                    </td>
                    <td style="font-size: 13px; font-weight: 500;"><%=rs.getDate("expiry_date")%></td>
                    <td style="white-space: nowrap;">
                        <a href="editmedicine.jsp?id=<%=rs.getInt("id")%>" class="btn-action btn-edit"><i class="fas fa-edit"></i> Edit</a>
                        <a href="deletemedicine.jsp?id=<%=rs.getInt("id")%>" class="btn-action btn-delete"><i class="fas fa-trash"></i> Delete</a>
                    </td>
                </tr>
                <% } con.close(); } catch(Exception e) { } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function openAddModal(){ document.getElementById("medicineModal").style.display="flex"; }
    function closeModal(){ document.getElementById("medicineModal").style.display="none"; }
    
    function searchInventory(){
        var q = document.getElementById("searchInv").value.toLowerCase();
        document.querySelectorAll("#medicineTable tbody tr").forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(q) ? "" : "none";
        });
    }

    function filterCategory(cat){
        document.querySelectorAll("#medicineTable tbody tr").forEach(row => {
            row.style.display = (cat === "ALL" || row.getAttribute("data-category") === cat) ? "" : "none";
        });
    }
</script>
</body>
</html>