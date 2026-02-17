import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Cart } from '../models/cart.model';

@Injectable({
  providedIn: 'root',
})
export class CartService {
  private http = inject(HttpClient)
  private baseUrl: string = "http://localhost:8080/cart"
  usersCart!: Cart

  getCartByUserId(userId: number): Observable<Cart> {
    return this.http.get<Cart>(`${this.baseUrl}/user/${userId}`)
  }

  deleteProductFromCart(cartProductId: number, userId: number) {
    return this.http.delete(`${this.baseUrl}/product?cartProductId=${cartProductId}&userId=${userId}`)
  }

  changeAmountOfProduct(userId: number, cartProductId: number, amount: number) {
    return this.http.patch(`${this.baseUrl}/${userId}`, {
      productId: cartProductId,
      newAmount: amount
    })
  }

  addProductToBasket(userId: number, productId: number, amount: number) {
    return this.http.post(`${this.baseUrl}/${userId}`, {productId: productId, amount: amount})
  }
}
