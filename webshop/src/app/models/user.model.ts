import { Review } from "./review.model";

export class User {
  constructor(
    public email: string,
    public password: string,
    public firstName: string,
    public lastName: string,
    public phoneNumber?: string,
    public id: number | null = null,
    public pfpPath: string = "assets/pfp/default.png",
    public isAdmin: boolean = false,
    public reviewList: Review[] = []
  ) {}
}
