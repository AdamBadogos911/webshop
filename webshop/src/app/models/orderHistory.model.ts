import { BillingDetail } from "./billingDetails.model";
import { OrderProduct } from "./orderProduct.model";
import { PaymentMethod } from "./paymentMethod.model";
import { Status } from "./status.model";
import { TransportDetail } from "./transportDetail.model";
import { User } from "./user.model";

export class OrderHistroy {
  constructor(
    public id: number | null,
    public firstNaeme: string,
    public lastName: string,
    public phone: string,
    public email: string,
    public orderedAt: Date,
    public canceledAt: Date | null,
    public isCanceled: boolean,
    public orderId: number,
    public orderBillingDetail: BillingDetail,
    public orderTransportDetail: TransportDetail,
    public paymentMethod: PaymentMethod,
    public status: Status,
    public canceledUser: User | null,
    public products: OrderProduct[]
  ) {}
}
