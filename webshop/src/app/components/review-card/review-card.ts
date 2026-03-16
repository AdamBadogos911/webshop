import { Component, input, OnInit } from '@angular/core';
import { Review } from '../../models/review.model';

@Component({
  selector: 'app-review-card',
  imports: [],
  templateUrl: './review-card.html',
  styleUrl: './review-card.css',
})
export class ReviewCard implements OnInit{
  review = input.required<Review>()
  parentComponent = input.required<"profilPage" | "productDetails">()
  ratingList: number[] = []

  ngOnInit(): void {
    for (let i : number = 1; i <= 5; i++) {
      if (i <= this.review().rating) {
        this.ratingList.push(1)
      } else {
        this.ratingList.push(0)
      }
    }
  }
}
