export class Details {
  constructor(
    public id: number | null,
    public weightInKg: number,
    public species: string,
    public lengthInCm: number,
    public heightInCm: number,
    public widthInCm: number,
    public size: number,
    public isSet: boolean
  ) {}
}
