<%-- 
    Document   : sidebar
    Created on : Jan 8, 2026, 10:59:42 AM
    Author     : admin
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<style>
.sidebar {
    position: fixed;
    left: 0;
    top: 0;
    width: 250px;
    height: 100vh;
    background: #0f172a; /* Navy Blue */
    color: #ffffff;
    display: flex;
    flex-direction: column;
    font-family: 'Segoe UI', Arial, sans-serif;
    z-index: 1000;
}

/* LOGO SECTION */
.sidebar-header {
    padding: 25px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.sidebar-header img {
    height: 40px; /* Adjust height based on your logo shape */
    width: auto;
    border-radius: 6px;
}

.brand-name {
    font-weight: 700;
    font-size: 18px;
    color: #ffffff;
    letter-spacing: 0.5px;
}

/* NAVIGATION */
.sidebar-nav {
    flex: 1;
    padding: 15px 10px;
    overflow-y: auto;
}

.label {
    font-size: 10px;
    text-transform: uppercase;
    color: #64748b;
    letter-spacing: 1.2px;
    font-weight: 700;
    margin: 15px 10px 8px;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 11px 15px;
    color: #94a3b8;
    text-decoration: none;
    font-weight: 500;
    border-radius: 8px;
    margin-bottom: 4px;
    transition: 0.2s;
}

.nav-link i {
    width: 20px;
    text-align: center;
    font-size: 16px;
}

.nav-link:hover {
    background: #1e293b;
    color: #ffffff;
}

.nav-link.active {
    background: rgba(16, 185, 129, 0.15); 
    color: #10b981;
    font-weight: 600;
}

/* FOOTER */
.sidebar-footer {
    padding: 20px;
    border-top: 1px solid rgba(255,255,255,0.1);
}

.logout-btn {
    width: 100%;
    padding: 12px;
    background: #ef4444; 
    color: #ffffff;
    border: none;
    border-radius: 8px;
    font-weight: 700;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <img src="images/careplus.png" alt="Logo">
        <div class="brand-name">CarePlus Pharmacy<span style="color:#10b981">+</span></div>
    </div>

    <nav class="sidebar-nav">
        <div class="label">Main</div>
        <a href="dashboard.jsp" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
        <a href="inventory.jsp" class="nav-link"><i class="fas fa-pills"></i> Inventory</a>
        
        <div class="label">Transactions</div>
        <a href="billing.jsp" class="nav-link"><i class="fas fa-receipt"></i> New Bill</a>
        <a href="history.jsp" class="nav-link"><i class="fas fa-history"></i> Sales History</a>
        
        <div class="label">Supply Chain</div>
        <a href="suppliers.jsp" class="nav-link"><i class="fas fa-truck-fast"></i> Suppliers</a>
        <a href="purchase.jsp" class="nav-link"><i class="fas fa-cart-shopping"></i> Purchase</a>

        <div class="label">Reports</div>
        <a href="salesreport.jsp" class="nav-link"><i class="fas fa-chart-line"></i> Performance</a>

        <div class="label">Admin</div>
        <a href="users.jsp" class="nav-link"><i class="fas fa-user-shield"></i> System Users</a>
    </nav>

    <div class="sidebar-footer">
        <form action="Logout" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-power-off"></i> Logout
            </button>
        </form>
    </div>
</div>

<script>
    var path = window.location.pathname.split("/").pop();
    if (!path) path = "dashboard.jsp";
    
    var navLinks = document.querySelectorAll('.nav-link');
    for (var i = 0; i < navLinks.length; i++) {
        if (navLinks[i].getAttribute('href') === path) {
            navLinks[i].classList.add('active');
        }
    }
</script>