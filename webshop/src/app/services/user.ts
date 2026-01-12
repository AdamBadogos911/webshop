import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private http = inject(HttpClient)
  private baseURL = "http://localhost:8080/user"

  login(email: string, password: string): Observable<User> {
    return this.http.post<User>(`${this.baseURL}/login`, {email: email, password: password})
  }

  register(newUser: User){
    return this.http.post(`${this.baseURL}/register`, newUser)
  }
}
