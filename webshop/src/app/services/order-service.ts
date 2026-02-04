import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { OrderHistory } from '../models/orderHistory.model';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class OrderService {
  private http = inject(HttpClient)
  private baseUrl = "http://localhost:8080/order"

  getOrderHistoryByUserId(userId: number): Observable<OrderHistory[]> {
    return this.http.get<OrderHistory[]>(`${this.baseUrl}/user/${userId}`)
  }
}
