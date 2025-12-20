import { User } from './../../models/user.model';
import { Component, inject } from '@angular/core';
import { RouterLink } from "@angular/router";
import { UserService } from '../../services/user-service';
import { ProductList } from "../product-list/product-list";

@Component({
  selector: 'app-navbar',
  imports: [RouterLink, ProductList],
  templateUrl: './navbar.html',
  styleUrl: './navbar.css',
})
export class Navbar {
  UserService = inject(UserService);
}
