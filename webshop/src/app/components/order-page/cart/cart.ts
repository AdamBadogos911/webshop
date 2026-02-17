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
export class CartPage implements OnInit{
  cartService = inject(CartService)
  userService = inject(UserService)

  ngOnInit(): void {
    this.cartService.getCartByUserId(this.userService.user?.id!).subscribe({
      next: response => {
        this.cartService.usersCart = response
      }
    })
  }

  deleteProductFromCart() {

  }

  changeAmount(newAmount: number, index: number) {
    const searchedProduct = this.cartService.usersCart.cartProductList![index]
    searchedProduct.amount = newAmount
    this.cartService.usersCart.cartProductList![index] = searchedProduct
  }

  clearCart() {

  }
}
