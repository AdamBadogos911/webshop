import { Component, inject, output } from '@angular/core';
import { RouterModule } from "@angular/router";
import { UserService } from '../../services/user-service';

@Component({
  selector: 'app-navbar',
  imports: [RouterModule],
  templateUrl: './navbar.html',
  styleUrl: './navbar.css',
})
export class Navbar {
  userService = inject(UserService);
  navbarIsOpen: boolean = false
  openNavBar = output<boolean>()

  handleNavbar() {
    this.navbarIsOpen = !this.navbarIsOpen
    this.openNavBar.emit(this.navbarIsOpen)
  }
}
