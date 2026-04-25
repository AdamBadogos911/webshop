package com.example.badogosShop.repository;

import com.example.badogosShop.entity.OrderHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

public interface OrderHistoryRepository extends JpaRepository<OrderHistory, Integer> {

    @Procedure(name = "statistic_sum_profit", procedureName = "statistic_sum_profit")
    Long statistic_sum_profit(@Param("yearIN") Integer year, @Param("monthIN") Integer month);

    @Procedure(name = "statistic_sum_sold_items", procedureName = "statistic_sum_sold_items")
    Long statistic_sum_sold_items(@Param("yearIN") Integer year, @Param("monthIN") Integer month);

    @Procedure(name = "statistic_count_orders", procedureName = "statistic_count_orders")
    Long statistic_count_orders(@Param("yearIN") Integer year, @Param("monthIN") Integer month);

    @Procedure(name = "statistic_avg_order_price", procedureName = "statistic_avg_order_price")
    Long statistic_avg_order_price(@Param("yearIN") Integer year, @Param("monthIN") Integer month);
}
