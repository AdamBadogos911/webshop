import { Component, inject, OnInit } from '@angular/core';
import { OrderService } from '../../../services/order-service';
import { CartService } from '../../../services/cart-service';
import { UserService } from '../../../services/user-service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-summary-page',
  imports: [],
  templateUrl: './summary-page.html',
  styleUrl: './summary-page.css',
})
export class SummaryPage implements OnInit {
  orderService = inject(OrderService)
  cartService = inject(CartService)
  userService = inject(UserService)
  transportAddress: string = ""
  billingAddress: string = ""
  router = inject(Router)
  sumPrice: number = 0

  ngOnInit(): void {
    this.transportAddress = this.orderService.actualOrder.orderTransportDetail?.postCode + " " + this.orderService.actualOrder.orderTransportDetail?.town + this.orderService.actualOrder.orderTransportDetail?.address + this.orderService.actualOrder.orderTransportDetail?.houseNumber
    this.billingAddress = this.orderService.actualOrder.orderBillingDetail?.postCode + " " + this.orderService.actualOrder.orderBillingDetail?.town + this.orderService.actualOrder.orderBillingDetail?.address + this.orderService.actualOrder.orderBillingDetail?.houseNumber
    this.calculatePrice()
  }

  calculatePrice() {
    this.sumPrice = 0;
    this.cartService.usersCart.cartProductList.forEach((cp) => {
      this.sumPrice += cp.amount * cp.cartProduct.price;
    });
  }

  sendOrder() {
    this.orderService.actualOrder.orderUser = this.userService.user!
    this.orderService.sendOrder(this.cartService.usersCart.id!).subscribe({
      next: response => console.log(response),
      complete: () => {
        this.router.navigate(["/home"])
      }
    })
  }
}
