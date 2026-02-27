import { Component, inject, OnInit } from '@angular/core';
import { Product } from '../../../models/product.model';
import { ProductService } from '../../../services/product-service';

@Component({
  selector: 'app-storage-page',
  imports: [],
  templateUrl: './storage-page.html',
  styleUrl: './storage-page.css',
})
export class StoragePage implements OnInit{
  products: Product[] = []
  productService = inject(ProductService)

  ngOnInit(): void {
    this.productService.getAllProduct().subscribe({
      next: response => {
        this.products = response
      }
    })
  }
}
