import { Component, inject, input } from '@angular/core';
import { Router } from '@angular/router';
import { Product } from '../../models/product.model';

@Component({
  selector: 'app-product-card',
  imports: [],
  templateUrl: './product-card.html',
  styleUrl: './product-card.css',
})
export class ProductCard {
  product = input.required<Product>()
  private router = inject(Router)

  navigateToDetails() {
    this.router.navigate(["productDetails", this.product()?.id])
    window.scrollTo(0, 0)
  }
}
