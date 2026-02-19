import { Product } from "./product.model";
import { User } from "./user.model";

export class Review {
  constructor(
    public id: number | null,
    public reviewText: string,
    public rating: number,
    public createdAt: Date,
    public product: Product,
    public author: User
  ) {}
}
