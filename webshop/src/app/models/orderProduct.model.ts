import { OrderHistory } from './orderHistory.model';
import { Product } from './product.mode';

export class OrderProduct {
  constructor(
    public id: number | null,
    public amount: number,
    public orderProduct: Product,
    public OrderHistroy: OrderHistory
  ) {}
}
