import { Component, inject, OnInit } from '@angular/core';
import { UserService } from '../../services/user-service';
import { Review } from '../../models/review.model';
import { OrderHistory } from '../../models/orderHistory.model';
import { AddressUser } from '../../models/addressUser.model';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

@Component({
  selector: 'app-profil-page',
  imports: [ReactiveFormsModule],
  templateUrl: './profil-page.html',
  styleUrl: './profil-page.css',
})
export class ProfilPage implements OnInit {
  userService = inject(UserService)
  selectedContent: "profilPage" | "orderHistory" | "reviews" | "addresses" = "profilPage"
  reviewList: Review[] = []
  orderHistory: OrderHistory[] = []
  addressList: AddressUser[] = []

  updateForm!: FormGroup

  ngOnInit(): void {

  }

  selectContent(newContent: "profilPage" | "orderHistory" | "reviews" | "addresses") {
    this.selectedContent = newContent
    if (this.selectedContent == "profilPage") {
      this.updateForm = new FormGroup({
        email: new FormControl("", [Validators.required]),
        firstName: new FormControl("", [Validators.required]),
        lastName: new FormControl("", [Validators.required]),
        phoneNumber: new FormControl("", [Validators.required])
      })
    } else if (this.selectedContent == "orderHistory"){
      this.getOrderHistory()
    } else if (this.selectedContent == "reviews") {
      this.getReviews()
    }
  }

  getOrderHistory() {

  }

  getReviews() {

  }

  deleteUser() {

  }

  updateUser() {

  }

  updatePfp() {

  }
}
