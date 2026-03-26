import com.pharma.config.dbconfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PurchaseServlet")
public class PurchaseServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
             response.setContentType("text/html;charset=UTF-8");
                     PrintWriter out = response.getWriter();
            Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;

        try {
            // 1. Get data from JSP
            int supplierId = Integer.parseInt(request.getParameter("supplier_id"));
            String cartData = request.getParameter("cartData");

            // 2. AUTO-GENERATE Invoice Number (e.g., INV-202602231230)
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
            String autoInvoice = "INV-" + sdf.format(new java.util.Date());

            if (cartData == null || cartData.trim().isEmpty()) {
                response.getWriter().println("Error: Your cart is empty.");
                return;
            }

            con = new com.pharma.config.dbconfig().getConnection();
            con.setAutoCommit(false); // Start Transaction

            String[] items = cartData.split(",");
            double totalAmount = 0;

            // Calculate grand total first
            for (String item : items) {
                String[] parts = item.split("\\|");
                totalAmount += Double.parseDouble(parts[3]);
            }

            // 3. Insert Master Purchase Record using our generated 'autoInvoice'
            ps1 = con.prepareStatement(
                "INSERT INTO purchases (supplier_id, invoice_number, purchase_date, total_amount) VALUES (?, ?, NOW(), ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps1.setInt(1, supplierId);
            ps1.setString(2, autoInvoice); // Set the auto-generated number here
            ps1.setDouble(3, totalAmount);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            int purchaseId = rs.next() ? rs.getInt(1) : 0;

            // 4. Loop through items to update records and stock
            for (String item : items) {
                String[] parts = item.split("\\|");
                int medicineId = Integer.parseInt(parts[0]);
                int quantity = Integer.parseInt(parts[1]);
                double price = Double.parseDouble(parts[2]);
                double subtotal = Double.parseDouble(parts[3]);

                // Insert into purchase_items
                ps2 = con.prepareStatement(
                    "INSERT INTO purchase_items (purchase_id, medicine_id, quantity, purchase_price, subtotal) VALUES (?, ?, ?, ?, ?)"
                );
                ps2.setInt(1, purchaseId);
                ps2.setInt(2, medicineId);
                ps2.setInt(3, quantity);
                ps2.setDouble(4, price);
                ps2.setDouble(5, subtotal);
                ps2.executeUpdate();

                // Update stock in medicines table
                ps3 = con.prepareStatement(
                    "UPDATE medicines SET stock = stock + ? WHERE id = ?"
                );
                ps3.setInt(1, quantity);
                ps3.setInt(2, medicineId);
                ps3.executeUpdate();
            }

            con.commit(); // Save all changes
            response.sendRedirect("inventory.jsp?success=Purchase+Saved+Invoice+" + autoInvoice);

        } catch (Exception e) {
            if (con != null) { try { con.rollback(); } catch (SQLException se) { se.printStackTrace(); } }
            e.printStackTrace();
            response.getWriter().println("Critical Error: " + e.getMessage());
        } finally {
            try {
                if (ps1 != null) ps1.close();
                if (ps2 != null) ps2.close();
                if (ps3 != null) ps3.close();
                if (con != null) con.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
