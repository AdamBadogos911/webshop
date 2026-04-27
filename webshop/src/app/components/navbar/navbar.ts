import { Component, inject, output } from '@angular/core';
import { Router, RouterModule } from "@angular/router";
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
  router = inject(Router)

  handleNavbar() {
    this.navbarIsOpen = true
    this.openNavBar.emit(this.navbarIsOpen)
  }

  navigateWithUserIcon() {
    if (this.userService.user == null) {
      this.router.navigate(["/login"])
    } else {
      this.router.navigate(["/profile"])
    }
  }
}
