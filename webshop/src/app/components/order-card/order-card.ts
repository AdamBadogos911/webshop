import { Component, input, OnInit } from '@angular/core';
import { OrderHistory } from '../../models/orderHistory.model';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-order-card',
  imports: [CommonModule],
  templateUrl: './order-card.html',
  styleUrl: './order-card.css',
})
export class OrderCard implements OnInit{
  orderHistory = input.required<OrderHistory>()
  transportAddress: string = ""

  ngOnInit(): void {
    this.transportAddress = this.orderHistory().orderTransportDetail?.postCode + " " + this.orderHistory().orderTransportDetail?.town + this.orderHistory().orderTransportDetail?.address + this.orderHistory().orderTransportDetail?.houseNumber
  }
}
