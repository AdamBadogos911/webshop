import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Product } from '../models/product.mode';

@Injectable({
  providedIn: 'root',
})
export class ProductService {
  private http = inject(HttpClient)
  private baseUrl = "http://localhost:8080/product"

  getProductByCategory(categoryId: number) {
    return this.http.get<Product[]>(`${this.baseUrl}/category/${categoryId}?page=0&size=20`)
  }
}
