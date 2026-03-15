import { Component, inject, OnInit } from '@angular/core';
import { CartService } from '../../../services/cart-service';
import { UserService } from '../../../services/user-service';
import { CartCard } from './cart-card/cart-card';
import { RouterModule } from '@angular/router';
import { ProductService } from '../../../services/product-service';
import { Product } from '../../../models/product.model';
import { ProductCard } from '../../product-card/product-card';

@Component({
  selector: 'app-cart',
  imports: [CartCard, RouterModule, ProductCard],
  templateUrl: './cart.html',
  styleUrl: './cart.css',
})
export class CartPage implements OnInit {
  cartService = inject(CartService);
  productService = inject(ProductService)
  userService = inject(UserService);
  sumPrice: number = 0;
  highlightedProducts: Product[] = []

  ngOnInit(): void {
    this.cartService.getCartByUserId(this.userService.user?.id!).subscribe({
      next: (response) => {
        this.cartService.usersCart = response;

        if (this.cartService.usersCart.cartProductList.length == 0) {
          this.productService.getMostViewedProducts().subscribe({
            next: response => this.highlightedProducts = response
          })
        }
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
