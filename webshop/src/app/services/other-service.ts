import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { PaymentMethod } from '../models/paymentMethod.model';
import { AddressType } from '../models/addressType.model';
import { Brand } from '../models/brand.model';

@Injectable({
  providedIn: 'root',
})
export class OtherService {
  private http = inject(HttpClient)
  private baseUrl: string = "http://localhost:8080"

  getAllPaymentMethod(): Observable<PaymentMethod[]> {
    return this.http.get<PaymentMethod[]>(`${this.baseUrl}/paymentMethods`)
  }

  getAllAddressType(): Observable<AddressType[]> {
    return this.http.get<AddressType[]>(`${this.baseUrl}/addressType`)
  }

  getAllBrand(): Observable<Brand[]> {
    return this.http.get<Brand[]>(`${this.baseUrl}/brand`)
  }
}
