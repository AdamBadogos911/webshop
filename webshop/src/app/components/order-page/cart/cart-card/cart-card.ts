import { Component, inject, input, output } from '@angular/core';
import { CartService } from '../../../../services/cart-service';
import { UserService } from '../../../../services/user-service';
import { CartProduct } from '../../../../models/cartProduct.model';

@Component({
  selector: 'app-cart-card',
  imports: [],
  templateUrl: './cart-card.html',
  styleUrl: './cart-card.css',
})
export class CartCard {
  cartProduct = input.required<CartProduct>()
  cartService = inject(CartService)
  userService = inject(UserService)
  changeAmount = output<number>()
  delete = output()

  changeAmountOfProduct(plusValue: 1 | -1) {
    this.cartService.changeAmountOfProduct(this.userService.user?.id!, this.cartProduct().id!, this.cartProduct().amount + plusValue).subscribe({
      next: response => {
        if (this.cartProduct().amount + plusValue === 0) {
          this.cartService.usersCart.cartProductList = this.cartService.usersCart.cartProductList?.filter((cp) => cp.id != this.cartProduct().id)
        } else {
          this.changeAmount.emit(this.cartProduct().amount + plusValue)
        }
      }
    })
  }

  deleteProductFromBasket() {
    this.cartService.deleteProductFromCart(this.cartProduct().id!, this.userService.user?.id!).subscribe({
      next: response => {
        this.cartService.usersCart.cartProductList = this.cartService.usersCart.cartProductList?.filter((cp) => cp.id != this.cartProduct().id)
      }, complete: () => {
        this.delete.emit()
      }
    })
  }
}
