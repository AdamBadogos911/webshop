import { Component, inject, input } from '@angular/core';
import { Product } from '../../models/product.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-product-card',
  imports: [],
  templateUrl: './product-card.html',
  styleUrl: './product-card.css',
})
export class ProductCard {
  product = input<Product>()
  private router = inject(Router)


  navigateToDetails() {
    this.router.navigate(["product", this.product()?.id])
  }
}
