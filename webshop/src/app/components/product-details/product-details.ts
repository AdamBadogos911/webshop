import { Component, inject, OnInit } from '@angular/core';
import { ReviewService } from '../../services/review-service';
import { ActivatedRoute } from '@angular/router';
import { ProductService } from '../../services/product-service';
import { Review } from '../../models/review.model';
import { ReviewCard } from '../review-card/review-card';
import { Product } from '../../models/product.model';
import { ProductCard } from '../product-card/product-card';
import { UserService } from '../../services/user-service';
import { CartService } from '../../services/cart-service';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-product-details',
  imports: [ReviewCard, ProductCard, ReactiveFormsModule],
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
  reviewForm!: FormGroup
  isShowReviewForm: boolean = false

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

    this.reviewForm = new FormGroup({
      reviewText: new FormControl("", new FormControl([Validators.required])),
      rating: new FormControl("", new FormControl([Validators.required, Validators.min(0), Validators.max(5)])),
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
        console.log(this.reviews)
      }
    })
  }

  addToCart(amount: number) {
    if (this.userService.user == null) {
      alert("Előbb jelentkezzen be.")
    }

    this.cartService.addProductToBasket(this.userService.user?.id!, this.selectedProduct.id!, amount).subscribe({
      next: response => {
        console.log(response)
      }
    })
  }

  handleReviewCreate() {
    if (this.userService.user == null) {
      alert("Előbb jelentkezzen be.")
      return
    }

    if(this.isShowReviewForm) {

      const review = new Review(
        null,
        this.reviewForm.controls["reviewText"].value,
        this.reviewForm.controls["rating"].value,
        new Date(),
        this.selectedProduct,
        this.userService.user!
      )

      this.reviewService.addReview(review).subscribe({
        next: response => {
          console.log(response)
          this.reviews.push(response)
        }
      })
    }

    this.isShowReviewForm = !this.isShowReviewForm
  }
}
