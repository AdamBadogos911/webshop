import { Component, inject, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ProductService } from '../../services/product-service';
import { ProductCard } from '../product-card/product-card';
import { Product } from '../../models/product.model';

@Component({
  selector: 'app-product-list',
  imports: [ProductCard],
  templateUrl: './product-list.html',
  styleUrl: './product-list.css',
})
export class ProductList implements OnInit {
  private route = inject(ActivatedRoute)
  productService = inject(ProductService)
  productList: Product[] = []
  isError: boolean = false

  ngOnInit(): void {
    this.route.params.subscribe({
      next: param => {
        const categoryId: number = param["categoryId"]
        this.productService.getProductByCategory(categoryId).subscribe({
          next: response => this.productList = response,
          error: error => this.isError = true
        })
      }
    })
  }

  getRows(): Product[][] {
    const rows: Product[][] = []
    for (let i: number = 0; i < this.productList.length; i+=4) {
      const row: Product[] = []
      for (let j: number = i; j < i+4; j++) {
        if (this.productList[j] != undefined) {
          row.push(this.productList[j])
        }
      }
      rows.push(row)
    }

    return rows;
  }
}
