
package com.codequest;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {

        try (Connection con =
                DbConnection.getConnection()) {

            System.out.println(
                "MySQL Connected Successfully!"
            );

        } catch (Exception e) {
            System.out.println("Connection Failed!");
            e.printStackTrace();
        }
    }
}
