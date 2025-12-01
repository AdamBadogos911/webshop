import { Component, signal } from '@angular/core';
import { RegistrationPage } from "./components/registration-page/registration-page";
import { Navbar } from "./components/navbar/navbar";
import { LoginPage } from "./components/login-page/login-page";
import { RouterOutlet } from "@angular/router";

@Component({
  selector: 'app-root',
  imports: [RegistrationPage, Navbar, LoginPage, RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('webshop');
}
