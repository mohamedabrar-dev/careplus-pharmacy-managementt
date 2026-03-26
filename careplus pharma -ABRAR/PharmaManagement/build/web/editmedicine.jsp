<%-- 
    Document   : editmedicine
    Created on : Feb 3, 2026, 12:13:16 PM
    Author     : admin
--%>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

if(session.getAttribute("username")==null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    Connection con = new dbconfig().getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM medicines WHERE id=?");
    ps.setInt(1,id);
    ResultSet rs = ps.executeQuery();
    rs.next();
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Medicine</title>
<link rel="stylesheet" href="css/main.css?v=99">
<link rel="stylesheet" href="css/components.css">

<style>
.edit-wrapper{
    max-width:900px;
    margin:40px auto;
}
.edit-card{
    background:#fff;
    padding:30px;
    border-radius:16px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
}
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:20px;
}
.form-grid .full{
    grid-column:1 / -1;
}
.actions{
    margin-top:25px;
    display:flex;
    justify-content:flex-end;
    gap:10px;
}
</style>
</head>

<body>

<div class="edit-wrapper">
<div class="edit-card">

<h2 style="margin-bottom:20px;">Edit Medicine Details</h2>

<form action="editmedicine" method="post">
<input type="hidden" name="id" value="<%=id%>">

<div class="form-grid">

<div class="full">
<label>Medicine Name</label>
<input class="form-input" name="name" value="<%=rs.getString("name")%>">
</div>

<div>
<label>Generic Name</label>
<input class="form-input" name="generic_name" value="<%=rs.getString("generic_name")%>">
</div>

<div>
<label>Category</label>
<input class="form-input" name="category" value="<%=rs.getString("category")%>">
</div>

<div>
<label>Manufacturer</label>
<input class="form-input" name="manufacturer" value="<%=rs.getString("manufacturer")%>">
</div>

<div>
<label>Price (?)</label>
<input class="form-input" name="price" value="<%=rs.getDouble("price")%>">
</div>

<div>
<label>Stock</label>
<input class="form-input" name="stock" value="<%=rs.getInt("stock")%>">
</div>

<div>
<label>Unit</label>
<input class="form-input" name="unit" value="<%=rs.getString("unit")%>">
</div>

<div>
<label>Expiry Date</label>
<input type="date" class="form-input" name="expiry_date" value="<%=rs.getDate("expiry_date")%>">
</div>

</div>

<div class="actions">
<a href="inventory.jsp" class="btn btn-secondary">Cancel</a>
<button class="btn btn-primary">Update Medicine</button>
</div>

</form>

</div>
</div>

</body>
</html>