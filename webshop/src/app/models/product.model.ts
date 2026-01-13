import { Brand } from "./brand.model";
import { Category } from "./category.model";
import { Details } from "./details.model";
import { ProductImages } from "./productImages.model";
import { Review } from "./review.model";

export class Product {
  constructor(
    public id: number | null,
    public name: string,
    public description: string,
    public price: number,
    public discount: number,
    public amount: number,
    public stockKeepingUnit: string,
    public detail: Details,
    public brand: Brand,
    public images: ProductImages,
    public productReviewList: Review[],
    public categories: Category[]
  ) { }
}
