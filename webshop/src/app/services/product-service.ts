import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product } from '../models/product.model';

interface productDto {
  name: string,
  brandId: string,
  amount: string,
  price: number,
  weightInKg: number,
  material: string,
  lengthInCm: number,
  heightInCm: number,
  widthInCm: number,
  size: string,
  isSet: boolean,
  stockKeepingUnit: string,
  description: string,
  categoryId: number
}

@Injectable({
  providedIn: 'root',
})
export class ProductService {
  private http = inject(HttpClient)
  private baseUrl = "http://localhost:8080/product"

  getProductByCategory(categoryId: number): Observable<Product[]> {
    console.log(`${this.baseUrl}/category/${categoryId}?page=0&size=20`)
    return this.http.get<Product[]>(`${this.baseUrl}/category/${categoryId}?page=0&size=20`)
  }

  getProductById(id: number): Observable<Product> {
    return this.http.get<Product>(`${this.baseUrl}/${id}`)
  }

  getMostViewedProducts(): Observable<Product[]> {
    return this.http.get<Product[]>(`${this.baseUrl}/mostViewed`)
  }

  getAllProduct(): Observable<Product[]> {
    return this.http.get<Product[]>(this.baseUrl)
  }

  addProduct(newProduct: productDto):Observable<Product> {
    return this.http.post<Product>(this.baseUrl, newProduct)
  }

  updateProduct(id: number, updatedProduct: productDto):Observable<Product> {
    return this.http.put<Product>(`${this.baseUrl}/${id}`, updatedProduct)
  }
}
