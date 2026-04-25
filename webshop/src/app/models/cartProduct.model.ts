import { Cart } from "./cart.model";
import { Product } from "./product.model";

export class CartProduct {
  constructor(
    public id: number | null,
    public amount: number,
    public cartProduct: Product,
    public cart: Cart
  ) { }
}
