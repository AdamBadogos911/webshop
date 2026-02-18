import { Component, inject, InjectionToken, OnInit } from '@angular/core';
import { ReviewService } from '../../services/review-service';
import { ActivatedRoute } from '@angular/router';
import { ProductService } from '../../services/product-service';
import { Review } from '../../models/review.model';
import { ReviewCard } from '../review-card/review-card';
import { Product } from '../../models/product.model';
import { ProductCard } from '../product-card/product-card';
import { UserService } from '../../services/user-service';
import { CartService } from '../../services/cart-service';

@Component({
  selector: 'app-product-details',
  imports: [ReviewCard, ProductCard],
  templateUrl: './product-details.html',
  styleUrl: './product-details.css',
})
export class ProductDetails implements OnInit {
  reviewService = inject(ReviewService)
  productService = inject(ProductService)
  userService = inject(UserService)
  cartService = inject(CartService)
  route = inject(ActivatedRoute)
  showReviews = false
  selectedProduct!: Product
  reviews: Review[] = []
  similarProducts: Product[] = []

  ngOnInit(): void {
    this.route.params.subscribe({
      next: params => {
        this.productService.getProductById(params["productId"]).subscribe({
          next: response => {
            this.selectedProduct = response
          },
          complete: () => {
            this.productService.getProductByCategory(this.selectedProduct.category.id!).subscribe({
              next: response => this.similarProducts = response.slice(0, 4)
            })
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

  addToCart(amount: number) {
    if (this.userService.user == null) {
      alert("Előbb jelentkezzél be!")
    }

    this.cartService.addProductToBasket(this.userService.user?.id!, this.selectedProduct.id!, amount).subscribe({
      next: response => {
        console.log(response)
      }
    })
  }
}
