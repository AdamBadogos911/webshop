import { Component, inject, OnInit } from '@angular/core';
import { ReviewService } from '../../services/review-service';
import { ActivatedRoute } from '@angular/router';
import { ProductService } from '../../services/product-service';
import { Product } from '../../models/product.model';
import { Review } from '../../models/review.model';
import { ReviewCard } from '../review-card/review-card';

@Component({
  selector: 'app-product-details',
  imports: [ReviewCard],
  templateUrl: './product-details.html',
  styleUrl: './product-details.css',
})
export class ProductDetails implements OnInit{
  reviewService = inject(ReviewService)
  productService = inject(ProductService)
  route = inject(ActivatedRoute)
  showReviews = false
  selectedProduct!: Product
  reviews: Review[] = []

  ngOnInit(): void {
    this.route.params.subscribe({
      next: params => {
        this.productService.getProductById(params["productId"]).subscribe({
          next: response => {
            this.selectedProduct = response
          }
        })
      }
    })
  }

  handleReview(isShowReview: boolean) {
    this.showReviews = isShowReview
    if (this.showReviews) {
      this.getReviewsAboutProduct()
    } else {
      this.reviews = []
    }
  }

  getReviewsAboutProduct() {
    this.reviewService.getReviewsAboutProduct(this.selectedProduct.id!).subscribe({
      next: response => {
        this.reviews = response
      }
    })
  }
}
