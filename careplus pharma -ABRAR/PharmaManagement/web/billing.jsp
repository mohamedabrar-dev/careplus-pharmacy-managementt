<%-- 
    Document    : billing
    Created on : Dec 31, 2025, 12:06:25 PM
    Author     : admin
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
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
<html>
<head>
<meta charset="UTF-8">
<title>CarePlus POS | Billing</title>
<style>
    /* Reset and Core Layout */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f1f5f9; color: #1e293b; }

    /* Fix for Sidebar Overlap (Sidebar width is 260px) */
    .main-content {
        margin-left: 260px; 
        padding: 25px;
        height: 100vh;
        overflow: hidden;
    }

    .billing-layout { 
        display: flex; 
        gap: 20px; 
        height: 100%;
    }
    
    /* LEFT SIDE: THE BILL */
    .billing-center { 
        flex: 1.8; 
        background: white; 
        border-radius: 16px; 
        box-shadow: 0 4px 25px rgba(0,0,0,0.05); 
        display: flex; 
        flex-direction: column; 
        overflow: hidden; 
        border: 1px solid #e2e8f0;
    }
    
    /* RIGHT SIDE: CATALOGUE */
    .billing-right-catalogue { 
        flex: 1.1; 
        display: flex; 
        flex-direction: column; 
        background: #ffffff; 
        padding: 20px; 
        border-radius: 16px; 
        border: 1px solid #e2e8f0;
        box-shadow: 0 4px 25px rgba(0,0,0,0.05);
    }
    
    .bill-header { text-align: center; padding: 20px; border-bottom: 2px dashed #e2e8f0; }
    .bill-logo { height: 45px; margin-bottom: 8px; }
    
    .customer-info-top { 
        display: grid; 
        grid-template-columns: 1fr 1fr; 
        gap: 15px; 
        padding: 20px; 
        background: #f8fafc; 
        border-bottom: 1px solid #e2e8f0; 
    }

    .input-group { display: flex; flex-direction: column; }
    .input-group label { font-size: 11px; font-weight: 700; color: #64748b; margin-bottom: 6px; text-transform: uppercase; }
    .input-group input { padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px; outline: none; transition: 0.2s; }
    .input-group input:focus { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }

    .items-scroll-area { 
        flex-grow: 1; 
        overflow-y: auto; 
        padding: 10px;
    }
    
    .invoice-table { width: 100%; border-collapse: collapse; }
    .invoice-table th { position: sticky; top: 0; background: #fff; padding: 12px; text-align: left; font-size: 12px; color: #64748b; border-bottom: 2px solid #f1f5f9; z-index: 5; }
    .invoice-table td { padding: 12px; border-bottom: 1px solid #f8fafc; font-size: 14px; }

    /* Catalogue Search */
    #searchMed { width:100%; padding:12px 15px; border-radius:10px; border:1px solid #e2e8f0; margin-bottom:15px; background: #f8fafc; font-size: 14px; outline: none; }
    #searchMed:focus { border-color: #10b981; background: #fff; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }

    .medicine-scroll { overflow-y: auto; flex-grow: 1; padding-right: 5px; }
    .product-card { 
        padding: 15px; 
        border: 1px solid #f1f5f9; 
        border-radius: 12px; 
        margin-bottom: 10px; 
        cursor: pointer; 
        transition: 0.2s;
        background: #fff;
    }
    .product-card:hover { border-color: #10b981; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    
    /* Summary / Checkout */
    .bill-footer { 
        padding: 20px; 
        background: #ffffff; 
        border-top: 1px solid #e2e8f0; 
    }
    .summary-line { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 14px; color: #64748b; }
    .grand-total { display: flex; justify-content: space-between; font-size: 22px; font-weight: 800; color: #0f172a; margin: 10px 0; border-top: 1px solid #f1f5f9; padding-top: 10px; }
    
    .btn-checkout { 
        width: 100%; padding: 16px; background: #111827; color: white; border: none; 
        border-radius: 10px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.3s;
    }
    .btn-checkout:hover { background: #10b981; transform: scale(1.01); }
    .btn-checkout:disabled { background: #e2e8f0; cursor: not-allowed; color: #94a3b8; }

    /* Custom Scrollbar */
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
</style>
</head>

<body>

<jsp:include page="sidebar.jsp"/>

<div class="main-content">
    <div class="billing-layout">

        <div class="billing-center">
            <form id="billForm" action="billing" method="post" style="display:contents;">
                
                <input type="hidden" name="customer_name" id="finalCustName">
                <input type="hidden" name="customer_phone" id="finalCustPhone">
                <input type="hidden" name="total_amount" id="finalTotal">
                <div id="cartHiddenInputs"></div>

                <div class="bill-header">
                    <img src="images/careplus.png" class="bill-logo">
                    <h2 style="letter-spacing: -0.5px; font-weight: 800;">POINT OF SALE</h2>
                </div>

                <div class="customer-info-top">
                    <div class="input-group">
                        <label>Patient/Customer Name</label>
                        <input type="text" id="uiCustName" placeholder="Search or enter name">
                    </div>
                    <div class="input-group">
                        <label>Mobile Number</label>
                        <input type="text" id="uiCustPhone" placeholder="10-digit mobile">
                    </div>
                </div>

                <div class="items-scroll-area">
                    <table class="invoice-table">
                        <thead>
                            <tr>
                                <th>Medicine Details</th>
                                <th width="80">Qty</th>
                                <th>Unit Price</th>
                                <th>Total</th>
                                <th width="30"></th>
                            </tr>
                        </thead>
                        <tbody id="cartBody"></tbody>
                    </table>
                </div>

                <div class="bill-footer">
                    <div class="summary-line"><span>Sub-Total</span> <span id="dispSub">₹0.00</span></div>
                    <div class="summary-line"><span>GST (5%)</span> <span id="dispTax">₹0.00</span></div>
                    <div class="grand-total"><span>Total Amount</span> <span id="dispTotal">₹0.00</span></div>
                    <button type="button" class="btn-checkout" id="checkoutBtn" onclick="processCheckout()" disabled>
                        GENERATE INVOICE & PAY
                    </button>
                </div>
            </form>
        </div>

        <div class="billing-right-catalogue">
            <input type="text" id="searchMed" placeholder="🔍 Search medicine or generic name..." onkeyup="filterItems()">
            
            <div class="medicine-scroll">
                <%
                try {
                    Connection con = new dbconfig().getConnection();
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery("SELECT id, name, generic_name, price, stock FROM medicines WHERE stock > 0 ORDER BY name");
                    while(rs.next()){
                %>
                <div class="product-card" onclick="addToCart(<%=rs.getInt("id")%>, '<%=rs.getString("name")%>', <%=rs.getDouble("price")%>, <%=rs.getInt("stock")%>)">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <strong style="color: #1e293b; font-size: 15px;"><%=rs.getString("name")%></strong>
                        <span style="color:#10b981; font-weight: 800;">₹<%=rs.getDouble("price")%></span>
                    </div>
                    <div style="font-size:12px; color:#94a3b8; margin-top:2px;"><%=rs.getString("generic_name")%></div>
                    <div style="display:flex; align-items:center; margin-top:8px; gap:8px;">
                        <span style="background:#f1f5f9; color:#475569; padding:3px 8px; border-radius:6px; font-size:11px; font-weight: 600;">
                            Stock: <%=rs.getInt("stock")%>
                        </span>
                    </div>
                </div>
                <% 
                    } 
                    con.close(); 
                } catch(Exception e) { out.print("Error loading medicines."); }
                %>
            </div>
        </div>

    </div>
</div>

<script>
let cart = [];
const TAX_RATE = 0.05;

function addToCart(id, name, price, stock) {
    let item = cart.find(x => x.id === id);
    if (item) {
        if (item.qty < stock) item.qty++;
        else alert("Warning: Maximum available stock reached!");
    } else {
        cart.push({ id, name, price, qty: 1, stock });
    }
    renderTable();
}

function updateQty(index, qty) {
    qty = parseInt(qty);
    if (qty > cart[index].stock) {
        alert("Only " + cart[index].stock + " units left in inventory.");
        cart[index].qty = cart[index].stock;
    } else if (qty < 1) {
        cart.splice(index, 1);
    } else {
        cart[index].qty = qty;
    }
    renderTable();
}

function renderTable() {
    const tbody = document.getElementById("cartBody");
    tbody.innerHTML = "";
    let subtotal = 0;

    cart.forEach((item, i) => {
        let lineTotal = item.price * item.qty;
        subtotal += lineTotal;
        let row = `<tr>
                    <td><div style="font-weight:700; color:#1e293b;">${item.name}</div></td>
                    <td><input type="number" value="${item.qty}" onchange="updateQty(${i}, this.value)" 
                        style="width:55px; padding:6px; border-radius:6px; border:1px solid #cbd5e1; outline:none;"></td>
                    <td>₹${item.price.toFixed(2)}</td>
                    <td style="font-weight:700; color:#0f172a;">₹${lineTotal.toFixed(2)}</td>
                    <td><button type="button" onclick="cart.splice(${i},1);renderTable()" 
                        style="color:#f43f5e; border:none; background:none; cursor:pointer; font-size:20px;">&times;</button></td>
                  </tr>`;
        tbody.innerHTML += row;
    });

    let tax = subtotal * TAX_RATE;
    let grand = subtotal + tax;
    document.getElementById("dispSub").innerText = "₹" + subtotal.toFixed(2);
    document.getElementById("dispTax").innerText = "₹" + tax.toFixed(2);
    document.getElementById("dispTotal").innerText = "₹" + grand.toFixed(2);
    document.getElementById("checkoutBtn").disabled = (cart.length === 0);
}

function processCheckout() {
    const hiddenContainer = document.getElementById("cartHiddenInputs");
    hiddenContainer.innerHTML = "";
    
    cart.forEach(item => {
        hiddenContainer.innerHTML += `<input type='hidden' name='med_id' value='${item.id}'>
                                      <input type='hidden' name='med_qty' value='${item.qty}'>
                                      <input type='hidden' name='med_price' value='${item.price}'>`;
    });
    
    document.getElementById("finalCustName").value = document.getElementById("uiCustName").value || "Walk-in Customer";
    document.getElementById("finalCustPhone").value = document.getElementById("uiCustPhone").value || "N/A";
    
    let total = 0;
    cart.forEach(i => total += i.price * i.qty);
    document.getElementById("finalTotal").value = (total + (total * TAX_RATE)).toFixed(2);
    
    document.getElementById("billForm").submit();
}

function filterItems() {
    let term = document.getElementById("searchMed").value.toLowerCase();
    let cards = document.getElementsByClassName("product-card");
    for (let c of cards) { 
        c.style.display = c.innerText.toLowerCase().includes(term) ? "block" : "none"; 
    }
}
</script>
</body>
</html>