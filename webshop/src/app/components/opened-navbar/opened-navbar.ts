import { Component, inject, OnInit, output } from '@angular/core';
import { CategoryService } from '../../services/category-service';
import { Category } from '../../models/category.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-opened-navbar',
  imports: [],
  templateUrl: './opened-navbar.html',
  styleUrl: './opened-navbar.css',
})
export class OpenedNavbar implements OnInit {
  private categoryService = inject(CategoryService)
  private router = inject(Router)
  mainCategories: Category[] = []
  subCategories: Category[] = []
  close = output()
  isError: boolean = false

  ngOnInit(): void {
    this.categoryService.getAllMainCategory().subscribe({
      next: response => this.mainCategories = response,
      error: err => this.isError = true,
      complete: () => {
        this.getAllSubCategory(this.mainCategories[0].id!)
      }
    })
  }

  getAllSubCategory(mainCategoryId: number) {
    this.categoryService.getAllSubCategoryFromMainCategory(mainCategoryId).subscribe({
      next: response => this.subCategories = response
    })
  }

  navigateToProductList(categoryId: number) {
    this.router.navigate(["productList", categoryId])
    this.close.emit()
  }
}
