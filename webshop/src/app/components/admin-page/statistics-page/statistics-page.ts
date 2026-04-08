import { Component, inject, OnInit } from '@angular/core';
import { OrderService } from '../../../services/order-service';
import { ProductService } from '../../../services/product-service';
import { Product } from '../../../models/product.model';

@Component({
  selector: 'app-statistics-page',
  imports: [],
  templateUrl: './statistics-page.html',
  styleUrl: './statistics-page.css',
})
export class StatisticsPage implements OnInit {
  orderService = inject(OrderService)
  productService = inject(ProductService)
  statistic: { income: number, numberOfOrder: number, averageOrderedPrice: number, numberOfSoldProduct: number } | null = null
  mostViewedProduct: Product[] = []

  ngOnInit(): void {
    this.orderService.getStatistic().subscribe({
      next: response => this.statistic = response
    })

    this.productService.getMostViewedProducts().subscribe({
      next: response => this.mostViewedProduct = response
    })
  }
}
