import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private http = inject(HttpClient);
  private baseURL = "http://localhost:8080/user";
  user: User | null = null;

  login(email: string, password: string): Observable<User> {
    return this.http.post<User>(`${this.baseURL}/login`, { email: email, password: password });
  }

  register(newUser: User) {
    return this.http.post<User>(`${this.baseURL}/register`, newUser);
  }

  updateUser(updatedDetails: { firstName: string, lastName: string, email: string, phoneNumber: string }) {
    return this.http.put<User>(`${this.baseURL}/${this.user?.id}`, updatedDetails)
  }

  deleteUser() {
    return this.http.delete(`${this.baseURL}/${this.user?.id}`)
  }

  changePfp(formData: FormData): Observable<User> {
    return this.http.patch<User>(`${this.baseURL}/pfp/${this.user?.id}`, formData)
  }
}
