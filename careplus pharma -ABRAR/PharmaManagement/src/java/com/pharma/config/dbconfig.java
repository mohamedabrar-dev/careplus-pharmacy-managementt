/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.pharma.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author admin
 */
public class dbconfig {
    public Connection getConnection() {
        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            
           
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmamanagement", "root", "");
            
          
            return con;
        }
        catch (ClassNotFoundException | SQLException e) 
        {
         
            System.out.println(e);
        }
        return null;
    }
    
    
}
