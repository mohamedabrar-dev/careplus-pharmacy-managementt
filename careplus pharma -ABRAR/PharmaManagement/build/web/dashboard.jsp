<%-- 
    Document   : dashboard
    Created on : Dec 31, 2025, 12:05:02 PM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CarePlus | Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; }
        .main-content { margin-left: 250px; padding: 40px; min-height: 100vh; }
        
        /* HEADER SECTION */
        .dash-header { 
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 35px; 
            padding-bottom: 15px; 
            border-bottom: 2px solid #e2e8f0; 
        }
        .dash-header h1 { 
            margin: 0; 
            font-weight: 800; 
            font-size: 34px; 
            letter-spacing: -1.5px;
            background: linear-gradient(90deg, #0f172a 0%, #3b82f6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .dash-header p { color: #64748b; font-size: 14px; margin-top: 5px; font-weight: 500; }
        
        /* STATS CARDS & HOVER */
        .dashboard-cards { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { 
            padding: 22px; 
            border-radius: 18px; 
            color: white; 
            position: relative; 
            overflow: hidden; 
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); 
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2); }
        .stat-card i { position: absolute; right: -5px; bottom: -5px; font-size: 55px; opacity: 0.15; }
        .stat-val { font-size: 26px; font-weight: 800; display: block; margin-bottom: 2px; }
        .stat-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9; }

        /* GRID PANELS */
        .grid-layout { display: grid; grid-template-columns: 1.5fr 1fr; gap: 25px; margin-bottom: 25px; }
        .white-panel { background: white; padding: 25px; border-radius: 20px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.03); }
        .panel-title { font-size: 14px; font-weight: 800; color: #1e293b; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }

        /* BADGES */
        .top-item-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f1f5f9; }
        .top-item-row:last-child { border: none; }
        .qty-badge { background: #dcfce7; color: #15803d; padding: 4px 10px; border-radius: 20px; font-weight: 800; font-size: 12px; }
        .stock-badge { background: #fee2e2; color: #b91c1c; padding: 4px 10px; border-radius: 20px; font-weight: 800; font-size: 12px; }

        /* ANIMATION FOR LOW STOCK ALERT */
        .pulse-red { animation: pulse-red-bg 2s infinite; }
        @keyframes pulse-red-bg {
            0% { box-shadow: 0 0 0 0px rgba(244, 63, 94, 0.4); }
            100% { box-shadow: 0 0 0 10px rgba(244, 63, 94, 0); }
        }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>

<%
int totalMeds = 0; int lowStockCount = 0; double todaySales = 0; int todayBills = 0;
String stockLabels = ""; String stockValues = ""; String lowStockRows = ""; 
String revenueLabels = ""; String revenueValues = ""; String topSellingRows = "";

try {
    Connection con = new dbconfig().getConnection();
    Statement st = con.createStatement();

    // 1. Core Metrics
    ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM medicines"); if(rs1.next()) totalMeds = rs1.getInt(1);
    ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM medicines WHERE stock <= 10"); if(rs2.next()) lowStockCount = rs2.getInt(1);
    ResultSet rs5 = st.executeQuery("SELECT IFNULL(SUM(total_amount),0), COUNT(*) FROM sales WHERE DATE(sale_date) = CURDATE()");
    if(rs5.next()){ todaySales = rs5.getDouble(1); todayBills = rs5.getInt(2); }

    // 2. Charting Data
    ResultSet rs3 = st.executeQuery("SELECT name, stock FROM medicines ORDER BY stock DESC LIMIT 5");
    while(rs3.next()){
        stockLabels += "'" + rs3.getString("name") + "',";
        stockValues += rs3.getInt("stock") + ",";
    }
    ResultSet rs7 = st.executeQuery("SELECT DATE(sale_date) as sdate, SUM(total_amount) as total FROM sales WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) GROUP BY DATE(sale_date) ORDER BY sdate ASC");
    while(rs7.next()){
        revenueLabels += "'" + rs7.getString("sdate") + "',";
        revenueValues += rs7.getDouble("total") + ",";
    }

    // 3. Top Sellers
    ResultSet rsTop = st.executeQuery("SELECT m.name, SUM(si.quantity) as total_qty FROM sales_items si JOIN medicines m ON si.medicine_id = m.id GROUP BY m.id ORDER BY total_qty DESC LIMIT 5");
    while(rsTop.next()){
        topSellingRows += "<div class='top-item-row'><span>" + rsTop.getString("name") + "</span><span class='qty-badge'>" + rsTop.getInt("total_qty") + " Sold</span></div>";
    }

    // 4. Low Stock
    ResultSet rsLow = st.executeQuery("SELECT name, stock FROM medicines WHERE stock <= 20 ORDER BY stock ASC LIMIT 5");
    while(rsLow.next()){
        lowStockRows += "<div class='top-item-row'><span>" + rsLow.getString("name") + "</span><span class='stock-badge'>" + rsLow.getInt("stock") + " Left</span></div>";
    }
    con.close();
} catch(Exception e) { e.printStackTrace(); }
%>

<div class="main-content">
    <div class="dash-header">
        <div>
            <h1>CarePlus Dashboard</h1>
            <p>Real-time Pharmacy Performance Analytics</p>
        </div>
        <div style="text-align: right; margin-bottom: 10px;">
            <div id="liveClock" style="font-weight: 800; font-size: 20px; color: #0f172a;"></div>
            <div style="font-size: 12px; color: #64748b; font-weight: 600;"><%= new java.text.SimpleDateFormat("EEEE, MMM dd").format(new java.util.Date()) %></div>
        </div>
    </div>

    <div class="dashboard-cards">
        <div class="stat-card" style="background: #0f172a;">
            <span class="stat-label">Inventory Size</span>
            <span class="stat-val"><%= totalMeds %></span>
            <i class="fa-solid fa-boxes-stacked"></i>
        </div>
        <div class="stat-card" style="background: #10b981;">
            <span class="stat-label">Today's Revenue</span>
            <span class="stat-val">₹<%= String.format("%,.0f", todaySales) %></span>
            <i class="fa-solid fa-indian-rupee-sign"></i>
        </div>
        <div class="stat-card" style="background: #3b82f6;">
            <span class="stat-label">Invoices Today</span>
            <span class="stat-val"><%= todayBills %></span>
            <i class="fa-solid fa-file-invoice"></i>
        </div>
        <div class="stat-card <%= lowStockCount > 0 ? "pulse-red" : "" %>" style="background: #f43f5e;">
            <span class="stat-label">Stock Alerts</span>
            <span class="stat-val"><%= lowStockCount %></span>
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
    </div>

    <div class="grid-layout">
        <div class="white-panel">
            <div class="panel-title"><i class="fa-solid fa-chart-line" style="color:#6366f1"></i> Revenue Trend (7 Days)</div>
            <div style="height: 250px;"><canvas id="revenueChart"></canvas></div>
        </div>
        <div class="white-panel">
            <div class="panel-title"><i class="fa-solid fa-chart-pie" style="color:#10b981"></i> Stock Distribution</div>
            <div style="height: 250px;"><canvas id="stockDoughnut"></canvas></div>
        </div>
    </div>

    <div class="grid-layout">
        <div class="white-panel">
            <div class="panel-title"><i class="fa-solid fa-fire" style="color:#f59e0b"></i> Top Selling Items</div>
            <%= topSellingRows.isEmpty() ? "<p style='color:#94a3b8; font-size:13px;'>No sales recorded today.</p>" : topSellingRows %>
        </div>
        <div class="white-panel">
            <div class="panel-title"><i class="fa-solid fa-bolt" style="color:#f43f5e"></i> Low Stock Registry</div>
            <%= lowStockRows.isEmpty() ? "<p style='color:#94a3b8; font-size:13px;'>Stock is healthy.</p>" : lowStockRows %>
        </div>
    </div>
</div>

<script>
// LIVE CLOCK SCRIPT
function updateClock() {
    const now = new Date();
    document.getElementById('liveClock').innerText = now.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit', second:'2-digit'});
}
setInterval(updateClock, 1000);
updateClock();

// REVENUE LINE CHART WITH GRADIENT
const revCtx = document.getElementById("revenueChart").getContext("2d");
const gradient = revCtx.createLinearGradient(0, 0, 0, 300);
gradient.addColorStop(0, 'rgba(99, 102, 241, 0.3)');
gradient.addColorStop(1, 'rgba(99, 102, 241, 0)');

new Chart(revCtx, {
    type: "line",
    data: {
        labels: [<%= revenueLabels %>],
        datasets: [{
            data: [<%= revenueValues %>],
            borderColor: "#6366f1",
            backgroundColor: gradient,
            fill: true, tension: 0.4, borderWidth: 3, pointRadius: 5, pointBackgroundColor: "#fff"
        }]
    },
    options: { 
        responsive: true, 
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true }, x: { grid: { display: false } } }
    }
});

// STOCK DOUGHNUT CHART
new Chart(document.getElementById("stockDoughnut"), {
    type: "doughnut",
    data: {
        labels: [<%= stockLabels %>],
        datasets: [{
            data: [<%= stockValues %>],
            backgroundColor: ["#10b981", "#3b82f6", "#6366f1", "#f59e0b", "#f43f5e"],
            borderWidth: 0
        }]
    },
    options: {
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 10, weight: '600' } } }
        },
        cutout: '75%'
    }
});
</script>
</body>
</html>