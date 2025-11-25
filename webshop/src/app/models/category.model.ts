import { Product } from "./product.mode";

export class Category {
  constructor(
    public id: number | null,
    public name: string,
    public productList: Product
  ) {}
}
