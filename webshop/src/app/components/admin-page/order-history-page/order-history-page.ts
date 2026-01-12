import { Component, OnInit } from '@angular/core';
import { OrderCard } from '../../order-card/order-card';
import { OrderHistory } from '../../../models/orderHistory.model';

@Component({
  selector: 'app-order-history-page',
  imports: [OrderCard],
  templateUrl: './order-history-page.html',
  styleUrl: './order-history-page.css',
})
export class OrderHistoryPage implements OnInit{
  allOrderHistory: OrderHistory[] = []

  ngOnInit(): void {

  }
}
