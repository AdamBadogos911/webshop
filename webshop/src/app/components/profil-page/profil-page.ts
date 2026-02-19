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
import { Router } from '@angular/router';

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
  private router = inject(Router)
  selectedContent: "profilPage" | "orderHistory" | "reviews" = "profilPage"
  reviewList: Review[] = []
  orderHistories: OrderHistory[] = []
  addressList: AddressUser[] = []
  updateForm!: FormGroup
  isEdit: boolean = false

  ngOnInit(): void {
    this.selectedContent = "profilPage"
    this.updateForm = new FormGroup({
      firstName: new FormControl(this.userService.user?.firstName, [Validators.required]),
      lastName: new FormControl(this.userService.user?.lastName, [Validators.required]),
      email: new FormControl(this.userService.user?.email, [Validators.required, Validators.email]),
      phoneNumber: new FormControl(this.userService.user?.phoneNumber, [Validators.required])
    })
  }

  selectContent(newContent: "profilPage" | "orderHistory" | "reviews") {
    this.selectedContent = newContent
    if (this.selectedContent == "profilPage") {
      this.updateForm = new FormGroup({
        firstName: new FormControl(this.userService.user?.firstName, [Validators.required]),
        lastName: new FormControl(this.userService.user?.lastName, [Validators.required]),
        email: new FormControl(this.userService.user?.email, [Validators.required]),
        phoneNumber: new FormControl(this.userService.user?.phoneNumber, [Validators.required])
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
        console.log(response)
        console.log(this.reviewList)
      }
    })
  }

  deleteUser() {
    this.userService.deleteUser().subscribe({

    })
  }

  handleUpdate() {
    if(this.isEdit) {
      this.userService.updateUser({
        firstName: this.updateForm.controls["firstName"].value,
        lastName: this.updateForm.controls["lastName"].value,
        email: this.updateForm.controls["email"].value,
        phoneNumber: this.updateForm.controls["phoneNumber"].value
      }).subscribe({
        next: response => {
          this.userService.user = response
        }
      })
    }

    this.isEdit = !this.isEdit
  }

  updatePfp(event: any) {
    const file: File = event.target.files[0];
     if (file) {
      const formData = new FormData()
      formData.append("image", file)
      this.userService.changePfp(formData).subscribe({
        next: response => this.userService.user = response
      })
    }
  }

  logout() {
    this.userService.user = null
    this.router.navigate(["/homePage"])
  }
}
