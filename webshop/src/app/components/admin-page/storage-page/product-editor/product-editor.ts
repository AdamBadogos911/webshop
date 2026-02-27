import { Component, inject, input, OnInit, output } from '@angular/core';
import { Product } from '../../../../models/product.model';
import { ProductService } from '../../../../services/product-service';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Brand } from '../../../../models/brand.model';
import { OtherService } from '../../../../services/other-service';

@Component({
  selector: 'app-product-editor',
  imports: [ReactiveFormsModule],
  templateUrl: './product-editor.html',
  styleUrl: './product-editor.css',
})
export class ProductEditor implements OnInit{
  productService = inject(ProductService)
  otherService = inject(OtherService)
  product = input.required<Product | null>()
  save = output<Product>()
  editorForm!: FormGroup
  brands: Brand[] = []

  ngOnInit(): void {
    this.otherService.getAllBrand().subscribe({
      next: response => {
        this.brands = response
      }
    })

    this.editorForm = new FormGroup({
      name: new FormControl("", [Validators.required]),
      brand: new FormControl("", [Validators.required]),
      amount: new FormControl("", [Validators.required]),
      price: new FormControl("", [Validators.required]),
      weightInKg: new FormControl("", [Validators.required]),
      material: new FormControl("", [Validators.required]),
      lengthInCm: new FormControl("", [Validators.required]),
      heightInCm: new FormControl("", [Validators.required]),
      widthInCm: new FormControl("", [Validators.required]),
      size: new FormControl("", [Validators.required])
    })
  }

  deleteProduct() {

  }

  updateProduct() {

  }

  createProduct() {

  }
}
