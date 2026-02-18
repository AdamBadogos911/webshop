import { AddressType } from "./addressType.model";

export class BillingDetail {
  constructor(
    public id: number | null,
    public postCode: number,
    public town: string,
    public address: string,
    public houseNumber: number,
    public companyName: string | null,
    public taxNumber: string | null,
    public other: string | null,
    public billingAddressType: AddressType
  ){}
}
