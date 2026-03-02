import { Component, inject, OnInit } from '@angular/core';
import { Product } from '../../../models/product.model';
import { ProductService } from '../../../services/product-service';
import { ProductEditor } from './product-editor/product-editor';

@Component({
  selector: 'app-storage-page',
  imports: [ProductEditor],
  templateUrl: './storage-page.html',
  styleUrl: './storage-page.css',
})
export class StoragePage implements OnInit{
  products: Product[] = []
  productService = inject(ProductService)
  showEditor: boolean = false
  selectedProduct: Product | null = null

  ngOnInit(): void {
    this.productService.getAllProduct().subscribe({
      next: response => {
        console.log(response)
        this.products = response
      }
    })
  }

  addProductToList(newProduct: Product) {
    if (this.selectedProduct == null) {
      this.products.push(newProduct)
    } else {
      this.products[this.products.findIndex(p => p.id == newProduct.id)] = newProduct
    }
    this.showEditor = false
  }
}
