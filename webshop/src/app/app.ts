import { Component, signal } from '@angular/core';
import { RouterOutlet } from "@angular/router";
import { Footer } from "./components/footer/footer";
import { Navbar } from "./components/navbar/navbar";
import { OpenedNavbar } from './components/opened-navbar/opened-navbar';

@Component({
  selector: 'app-root',
  imports: [ Navbar, RouterOutlet, Footer, OpenedNavbar],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  isNavbarOpen = signal<boolean>(false)
}
