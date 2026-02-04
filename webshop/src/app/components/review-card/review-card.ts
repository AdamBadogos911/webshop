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

  ngOnInit(): void {

  }
}
