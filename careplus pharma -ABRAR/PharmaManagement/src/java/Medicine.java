import com.pharma.config.dbconfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MedicineServlet")
public class Medicine extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException {
             response.setContentType("text/html;charset=UTF-8");
             PrintWriter out = response.getWriter();
try {
            // 1. Get and Split Category/Supplier data
            String categoryInfo = request.getParameter("category_info"); 
            String categoryName = "Others";
            int supplierId = 0;

            if (categoryInfo != null && categoryInfo.contains("|")) {
                String[] parts = categoryInfo.split("\\|");
                categoryName = parts[0]; 
                supplierId = Integer.parseInt(parts[1]); 
            }

            // 2. Get Form Parameters
            String name = request.getParameter("name");
            String genericName = request.getParameter("generic_name");
            String manufacturer = request.getParameter("manufacturer");
            String price = request.getParameter("price");
            String stock = request.getParameter("stock");
            String unit = request.getParameter("unit");
            String expiryDate = request.getParameter("expiry_date");
            String batchNumber = request.getParameter("batch_number");
            String shelfLocation = request.getParameter("shelf_location");
            String requiresPrescription = request.getParameter("requires_prescription");

            Connection con = new dbconfig().getConnection();

            // 3. SQL matching your 12-column structure
            String sql = "INSERT INTO medicines "
                    + "(name, generic_name, category, manufacturer, price, stock, unit, expiry_date, batch_number, shelf_location, requires_prescription, supplier_id) "
                    + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, genericName);
            ps.setString(3, categoryName);
            ps.setString(4, manufacturer);
            ps.setDouble(5, (price != null && !price.isEmpty()) ? Double.parseDouble(price) : 0);
            ps.setInt(6, (stock != null && !stock.isEmpty()) ? Integer.parseInt(stock) : 0);
            ps.setString(7, unit);

            if (expiryDate != null && !expiryDate.isEmpty()) {
                ps.setDate(8, java.sql.Date.valueOf(expiryDate));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }

            ps.setString(9, (batchNumber != null) ? batchNumber : "");
            ps.setString(10, (shelfLocation != null) ? shelfLocation : "");
            ps.setInt(11, (requiresPrescription != null) ? 1 : 0);
            ps.setInt(12, supplierId);

            ps.executeUpdate();
            con.close();
            
            response.sendRedirect("inventory.jsp?msg=added");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventory.jsp?msg=error");
        }
    }
}