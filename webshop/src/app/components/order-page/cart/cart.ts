import { Component, inject, OnInit } from '@angular/core';
import { CartService } from '../../../services/cart-service';
import { UserService } from '../../../services/user-service';
import { CartCard } from './cart-card/cart-card';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-cart',
  imports: [CartCard, RouterModule],
  templateUrl: './cart.html',
  styleUrl: './cart.css',
})
export class CartPage implements OnInit {
  cartService = inject(CartService);
  userService = inject(UserService);
  sumPrice: number = 0;

  ngOnInit(): void {
    this.cartService.getCartByUserId(this.userService.user?.id!).subscribe({
      next: (response) => {
        this.cartService.usersCart = response;
      },
      complete: () => {
        this.calculatePrice()
      },
    });
  }

  deleteProductFromCart() {}

  calculatePrice() {
    this.sumPrice = 0;
    this.cartService.usersCart.cartProductList.forEach((cp) => {
      this.sumPrice += cp.amount * cp.cartProduct.price;
    });
  }

  changeAmount(newAmount: number, index: number) {
    const searchedProduct = this.cartService.usersCart.cartProductList![index];
    searchedProduct.amount = newAmount;
    this.cartService.usersCart.cartProductList![index] = searchedProduct;
    this.calculatePrice()
  }

  clearCart() {}
}
