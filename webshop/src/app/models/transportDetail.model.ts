import { AddressType } from "./addressType.model";

export class TransportDetail {
  constructor(
    public id: number | null,
    public postalCode: number,
    public town: string,
    public address: string,
    public houseNumber: number,
    public other: string | null,
    public transportAddressType: AddressType
  ) {}
}
