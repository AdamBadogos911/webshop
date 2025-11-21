import { Component, signal } from '@angular/core';
import { RegistrationPage } from "./components/registration-page/registration-page";
import { Navbar } from "./components/navbar/navbar";

@Component({
  selector: 'app-root',
  imports: [RegistrationPage, Navbar],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('webshop');
}
