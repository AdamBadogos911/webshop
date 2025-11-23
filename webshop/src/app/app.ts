import { Component, signal } from '@angular/core';
import { RegistrationPage } from "./components/registration-page/registration-page";
import { Navbar } from "./components/navbar/navbar";
import { LoginPage } from "./components/login-page/login-page";

@Component({
  selector: 'app-root',
  imports: [RegistrationPage, Navbar, LoginPage],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('webshop');
}
