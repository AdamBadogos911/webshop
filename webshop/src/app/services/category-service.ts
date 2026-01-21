import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Category } from '../models/category.model';

@Injectable({
  providedIn: 'root',
})
export class CategoryService {
  private http = inject(HttpClient);
  private baseURL = "http://localhost:8080/category";

  getAllMainCategory(): Observable<Category[]> {
    return this.http.get<Category[]>(`${this.baseURL}/main`)
  }

  getAllSubCategoryFromMainCategory(mainCategoryId: number): Observable<Category[]> {
    return this.http.get<Category[]>(`${this.baseURL}/main/${mainCategoryId}/sub`)
  }
}
