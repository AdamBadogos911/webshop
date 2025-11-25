export class Review {
  constructor(
    public id: number | null,
    public reviewText: string,
    public rating: number,
    public createdAt: Date
  ) {}
}
