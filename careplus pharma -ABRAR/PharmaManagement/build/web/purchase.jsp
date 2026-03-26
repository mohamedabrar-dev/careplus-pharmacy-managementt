<%-- 
    Document   : purchase
    Created on : Feb 11, 2026, 12:08:31 PM
    Author     : admin
--%>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
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
    <title>Stock Procurement - CAREPLUS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f1f5f9; margin: 0; color: #1e293b; }
        .main-content { margin-left: 280px; padding: 40px; }
        
        /* Grid Layout */
        .procure-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; align-items: start; }
        
        /* Left Panel Style */
        .glass-card { background: white; padding: 30px; border-radius: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 700; font-size: 13px; color: #64748b; text-transform: uppercase; }
        .pos-input { width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px; margin-bottom: 20px; font-size: 15px; box-sizing: border-box; }
        
        /* Right Panel (Bill Style) */
        .bill-container { background: #0f172a; color: white; border-radius: 24px; padding: 0; overflow: hidden; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.2); }
        .bill-header { background: #1e293b; padding: 25px; border-bottom: 1px dashed #334155; }
        .bill-body { padding: 25px; min-height: 250px; }
        .bill-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #1e293b; }
        .bill-footer { padding: 25px; background: #1e293b; }
        
        /* Buttons */
        .btn-add { background: #0f172a; color: white; padding: 14px; border: none; border-radius: 12px; width: 100%; cursor: pointer; font-weight: 800; transition: 0.3s; }
        .btn-add:hover { background: #334155; }
        .btn-confirm { background: #10b981; color: white; padding: 16px; border: none; border-radius: 14px; width: 100%; cursor: pointer; font-weight: 800; font-size: 16px; transition: 0.3s; }
        .btn-confirm:hover { background: #059669; transform: translateY(-2px); }
        .trash-btn { color: #f87171; cursor: pointer; transition: 0.2s; }
        .trash-btn:hover { color: #ef4444; }
    </style>

    <script>
        // Filter medicines when supplier is chosen
        function filterMedicinesBySupplier(supplierId) {
            const medSelect = document.getElementById("medicineSelect");
            if (!supplierId) {
                medSelect.innerHTML = '<option value="">Select Supplier First</option>';
                return;
            }
            fetch('getMedicinesBySupplier.jsp?supplier_id=' + supplierId)
                .then(res => res.text())
                .then(data => { medSelect.innerHTML = data; });
        }
    </script>
</head>
<body>

<jsp:include page="sidebar.jsp"/>

<div class="main-content">
    <h1 style="font-weight: 800; font-size: 28px; margin-bottom: 30px;">Stock Procurement</h1>

    <form action="PurchaseServlet" method="post" id="purchaseForm">
        <div class="procure-grid">
            
            <div class="glass-card">
                <label class="form-label">Step 1: Select Supplier</label>
                <select name="supplier_id" class="pos-input" required onchange="filterMedicinesBySupplier(this.value)">
                    <option value="">Choose Supplier...</option>
                    <%
                        try {
                            Connection con = new dbconfig().getConnection();
                            ResultSet rs = con.createStatement().executeQuery("SELECT * FROM suppliers");
                            while(rs.next()){
                                out.println("<option value='"+rs.getInt("supplier_id")+"'>"+rs.getString("supplier_name")+"</option>");
                            }
                            con.close();
                        } catch(Exception e) {}
                    %>
                </select>

                <div style="background: #f8fafc; padding: 25px; border-radius: 15px; border: 1px dashed #cbd5e1;">
                    <label class="form-label">Step 2: Add Medicine</label>
                    <select id="medicineSelect" class="pos-input">
                        <option value="">Select Medicine</option>
                    </select>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div>
                            <label class="form-label">Quantity</label>
                            <input type="number" id="quantity" class="pos-input" placeholder="0">
                        </div>
                        <div>
                            <label class="form-label">Purchase Price (Rs)</label>
                            <input type="number" step="0.01" id="price" class="pos-input" placeholder="0.00">
                        </div>
                    </div>
                    
                    <button type="button" class="btn-add" onclick="addToCart()">
                        <i class="fa-solid fa-plus" style="margin-right: 8px;"></i> Add to List
                    </button>
                </div>
            </div>

            <div class="bill-container">
                <div class="bill-header">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h3 style="margin: 0; font-weight: 800; color: #10b981;">Order Summary</h3>
                        <i class="fa-solid fa-file-invoice" style="opacity: 0.5;"></i>
                    </div>
                    <p style="font-size: 12px; color: #94a3b8; margin: 5px 0 0;">CarePlus Procurement System v1.0</p>
                </div>

                <div class="bill-body" id="cartBody">
                    <div style="text-align: center; margin-top: 50px; color: #475569;">
                        <i class="fa-solid fa-cart-shopping" style="font-size: 30px; margin-bottom: 10px; display: block;"></i>
                        <p style="font-size: 13px;">No items in the list yet.</p>
                    </div>
                </div>

                <div class="bill-footer">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
                        <span style="font-weight: 600; color: #94a3b8;">Grand Total</span>
                        <span id="grandTotal" style="font-weight: 800; font-size: 24px; color: #10b981;">Rs. 0.00</span>
                    </div>
                    
                    <input type="hidden" name="cartData" id="cartData">
                    <button type="submit" class="btn-confirm">
                        <i class="fa-solid fa-check-double" style="margin-right: 8px;"></i> Confirm & Restock
                    </button>
                </div>
            </div>

        </div>
    </form>
</div>

<script>
    let cart = [];

    function addToCart() {
        const medSelect = document.getElementById("medicineSelect");
        const qtyInput = document.getElementById("quantity");
        const priceInput = document.getElementById("price");

        // Validate selection
        if (!medSelect.value || medSelect.value === "") {
            alert("Please select a medicine.");
            return;
        }

        // 1. Get the combined "ID|Name" and split it
        const rawValue = medSelect.value; 
        const parts = rawValue.split("|");
        
        const medicineId = parts[0];   // The ID (e.g., 10)
        const medicineName = parts[1]; // The Name (e.g., Dolo 650)

        const qty = parseFloat(qtyInput.value);
        const price = parseFloat(priceInput.value);

        if (isNaN(qty) || qty <= 0 || isNaN(price) || price <= 0) {
            alert("Please enter valid quantity and price.");
            return;
        }

        const subtotal = qty * price;

        // 2. Add object to the cart array
        cart.push({
            id: medicineId,
            name: medicineName,
            qty: qty,
            price: price,
            subtotal: subtotal
        });

        // Reset inputs for next item
        qtyInput.value = "";
        priceInput.value = "";
        
        updateUI();
    }

    function updateUI() {
        const cartDiv = document.getElementById("cartBody");
        const dataInput = document.getElementById("cartData");
        const totalSpan = document.getElementById("grandTotal");
        
        cartDiv.innerHTML = "";
        let total = 0;

        if (cart.length === 0) {
            cartDiv.innerHTML = `<div style="text-align: center; margin-top: 50px; color: #475569;">
                                    <p style="font-size: 13px;">No items in the list yet.</p>
                                 </div>`;
        }

        cart.forEach((item, index) => {
            total += item.subtotal;
            
            // 3. Injecting the name into the UI
            cartDiv.innerHTML += `
                <div class="bill-row" style="display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #1e293b;">
                    <div>
                        <div style="font-weight: 700; font-size: 15px; color: #10b981;">\${item.name}</div>
                        <div style="font-size: 12px; color: #94a3b8;">Qty: \${item.qty} × Rs.\${item.price}</div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <span style="font-weight: 700; color: #ffffff;">Rs.\${item.subtotal.toFixed(2)}</span>
                        <i class="fa-solid fa-trash-can" style="color: #f87171; cursor: pointer;" onclick="removeItem(\${index})"></i>
                    </div>
                </div>`;
        });

        totalSpan.innerText = "Rs. " + total.toFixed(2);
        
        // Prepare hidden input data for PurchaseServlet: ID|QTY|PRICE|SUBTOTAL
        dataInput.value = cart.map(i => i.id + "|" + i.qty + "|" + i.price + "|" + i.subtotal).join(",");
    }

    function removeItem(index) {
        cart.splice(index, 1);
        updateUI();
    }
</script>

</body>
</html>