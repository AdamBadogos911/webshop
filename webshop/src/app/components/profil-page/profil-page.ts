import { Component, inject, OnInit } from '@angular/core';
import { UserService } from '../../services/user-service';
import { Review } from '../../models/review.model';
import { OrderHistory } from '../../models/orderHistory.model';
import { AddressUser } from '../../models/addressUser.model';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ReviewService } from '../../services/review-service';
import { ReviewCard } from '../review-card/review-card';
import { OrderService } from '../../services/order-service';
import { OrderCard } from '../order-card/order-card';

@Component({
  selector: 'app-profil-page',
  imports: [ReactiveFormsModule, ReviewCard, OrderCard],
  templateUrl: './profil-page.html',
  styleUrl: './profil-page.css',
})
export class ProfilPage implements OnInit {
  userService = inject(UserService)
  reviewService = inject(ReviewService)
  orderService = inject(OrderService)
  selectedContent: "profilPage" | "orderHistory" | "reviews" = "profilPage"
  reviewList: Review[] = []
  orderHistories: OrderHistory[] = []
  addressList: AddressUser[] = []

  updateForm!: FormGroup

  ngOnInit(): void {
    this.selectedContent = "profilPage"
    this.updateForm = new FormGroup({
      firstName: new FormControl("", [Validators.required]),
      lastName: new FormControl("", [Validators.required]),
      email: new FormControl("", [Validators.required, Validators.email]),
      phoneNumber: new FormControl("", [Validators.required])
    })
  }

  selectContent(newContent: "profilPage" | "orderHistory" | "reviews") {
    this.selectedContent = newContent
    if (this.selectedContent == "profilPage") {
      this.updateForm = new FormGroup({
        email: new FormControl("", [Validators.required]),
        firstName: new FormControl("", [Validators.required]),
        lastName: new FormControl("", [Validators.required]),
        phoneNumber: new FormControl("", [Validators.required])
      })
    } else if (this.selectedContent == "orderHistory") {
      this.getOrderHistory()
    } else if (this.selectedContent == "reviews") {
      this.getReviews()
    }
  }

  getOrderHistory() {
    this.orderService.getOrderHistoryByUserId(this.userService.user?.id!).subscribe({
      next: response => this.orderHistories = response
    })
  }

  getReviews() {
    this.reviewService.getReviewsByUser(this.userService.user?.id!).subscribe({
      next: response => {
        this.reviewList = response
      }
    })
  }

  deleteUser() {

  }

  updateUser() {

  }

  updatePfp() {

  }
}
