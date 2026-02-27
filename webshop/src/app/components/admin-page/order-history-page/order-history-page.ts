import { Component, inject, OnInit } from '@angular/core';
import { OrderCard } from '../../order-card/order-card';
import { OrderHistory } from '../../../models/orderHistory.model';
import { OrderService } from '../../../services/order-service';

@Component({
  selector: 'app-order-history-page',
  imports: [OrderCard],
  templateUrl: './order-history-page.html',
  styleUrl: './order-history-page.css',
})
export class OrderHistoryPage implements OnInit{
  allOrderHistory: OrderHistory[] = []
  orderService = inject(OrderService)

  ngOnInit(): void {
    this.orderService.getAllOrderHistory().subscribe({
      next: response => {
        this.allOrderHistory = response
      }
    })
  }
}
