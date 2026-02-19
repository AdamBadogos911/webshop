import { Product } from "./product.model";

export class Category {
  constructor(
    public id: number | null,
    public name: string,
    public productList: Product
  ) {}
}
