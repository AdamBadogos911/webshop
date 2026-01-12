import { Component, input } from '@angular/core';
import { OrderHistroy } from '../../models/orderHistory.model';

@Component({
  selector: 'app-order-card',
  imports: [],
  templateUrl: './order-card.html',
  styleUrl: './order-card.css',
})
export class OrderCard {
  orderHistory = input.required<OrderHistroy>()
}
