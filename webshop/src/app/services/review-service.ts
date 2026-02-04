import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Review } from '../models/review.model';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ReviewService {
  private http = inject(HttpClient)
  private baseUrl: string = "http://localhost:8080/review"

  getReviewsByUser(userId: number): Observable<Review[]> {
    return this.http.get<Review[]>(`${this.baseUrl}/user/${userId}`)
  }

  getReviewsAboutProduct(productId: number): Observable<Review[]> {
    return this.http.get<Review[]>(`${this.baseUrl}/product/${productId}`)
  }
}
