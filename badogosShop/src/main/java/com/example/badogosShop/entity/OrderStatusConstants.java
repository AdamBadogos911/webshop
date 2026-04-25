package com.example.badogosShop.entity;

/**
 * Rendelés státusz konstansok.
 * Megfelel a 'status' tábla ID-inek az adatbázisban.
 */
public final class OrderStatusConstants {

    public static final int PENDING = 1;
    public static final int SHIPPED = 2;
    public static final int CANCELED = 3;

    private OrderStatusConstants() {
        // Nem példányosítható
    }
}
