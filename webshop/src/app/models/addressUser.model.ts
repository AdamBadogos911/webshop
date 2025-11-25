import { BillingDetail } from "./billingDetails.model";
import { TransportDetail } from "./transportDetail.model";
import { User } from "./user.model";

export class AddressUser {
  constructor(
    public id: number | null,
    public addressUser: User,
    public savedBillingDetails: BillingDetail,
    public savedTransportDetails: TransportDetail
  ) {}
}
