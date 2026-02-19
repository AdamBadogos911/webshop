import { Component, inject, OnInit } from '@angular/core';
import { ProductCard } from "../product-card/product-card";
import { Product } from '../../models/product.model';
import { ProductService } from '../../services/product-service';

@Component({
  selector: 'app-home-page',
  imports: [ProductCard],
  templateUrl: './home-page.html',
  styleUrl: './home-page.css',
})
export class HomePage implements OnInit{
  products: Product[] = []
  productService = inject(ProductService)

  ngOnInit(): void {
    this.productService.getMostViewedProducts().subscribe({
      next: response => {
        console.log(response)
        this.products = response
      }
    })
  }
}
