import { Component, inject, OnInit } from '@angular/core';
import { CategoryService } from '../../services/category-service';
import { Category } from '../../models/category.model';

@Component({
  selector: 'app-opened-navbar',
  imports: [],
  templateUrl: './opened-navbar.html',
  styleUrl: './opened-navbar.css',
})
export class OpenedNavbar implements OnInit {
  categoryService = inject(CategoryService)
  mainCategories: Category[] = []
  subCategories: Category[] = []

  ngOnInit(): void {
    this.categoryService.getAllMainCategory().subscribe({
      next: response => this.mainCategories = response
    })
  }

  getAllSubCategory(mainCategoryId: number) {
    console.log(mainCategoryId)
    this.categoryService.getAllSubCategoryFromMainCategory(mainCategoryId).subscribe({
      next: response => this.subCategories = response
    })
  }
}
