import { Component, inject, input, OnInit, output } from '@angular/core';
import { Product } from '../../../../models/product.model';
import { ProductService } from '../../../../services/product-service';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Brand } from '../../../../models/brand.model';
import { OtherService } from '../../../../services/other-service';
import { Category } from '../../../../models/category.model';
import { CategoryService } from '../../../../services/category-service';

@Component({
  selector: 'app-product-editor',
  imports: [ReactiveFormsModule],
  templateUrl: './product-editor.html',
  styleUrl: './product-editor.css',
})
export class ProductEditor implements OnInit {
  productService = inject(ProductService)
  otherService = inject(OtherService)
  categoryService = inject(CategoryService)
  product = input.required<Product | null>()
  save = output<Product>()
  editorForm!: FormGroup
  brands: Brand[] = []
  categories: Category[] = []
  close = output()

  ngOnInit(): void {
    this.otherService.getAllBrand().subscribe({
      next: response => {
        this.brands = response
      }
    })

    this.categoryService.getAllCategory().subscribe({
      next: response => {
        this.categories = response
      }
    })

    this.editorForm = new FormGroup({
      name: new FormControl(this.product() != null ? this.product()?.name : "", [Validators.required]),
      brand: new FormControl(this.product() != null ? this.product()?.brand.id : "", [Validators.required]),
      amount: new FormControl(this.product() != null ? this.product()?.amount : "", [Validators.required]),
      price: new FormControl(this.product() != null ? this.product()?.price : "", [Validators.required]),
      weightInKg: new FormControl(this.product() != null ? this.product()?.detail.weightInKg : 0, []),
      material: new FormControl(this.product() != null ? this.product()?.detail.material : "-", []),
      lengthInCm: new FormControl(this.product() != null ? this.product()?.detail.lengthInCm : 0, []),
      heightInCm: new FormControl(this.product() != null ? this.product()?.detail.heightInCm : 0, []),
      widthInCm: new FormControl(this.product() != null ? this.product()?.detail.widthInCm : 0, []),
      size: new FormControl(this.product() != null ? this.product()?.detail.size : 0, []),
      isSet: new FormControl(this.product() != null ? this.product()?.detail.isSet : false, []),
      stockKeepingUnit: new FormControl(this.product() != null ? this.product()?.stockKeepingUnit : "", []),
      description: new FormControl(this.product() != null ? this.product()?.description : "", [Validators.required]),
      category: new FormControl(this.product() != null ? this.product()?.category.id : "", [Validators.required]),
    })
  }

  saveChanges() {
    if (this.product() == null) {
      this.createProduct()
    } else {
      this.updateProduct()
    }
  }

  updateProduct() {
    this.productService.updateProduct(this.product()!.id! ,{
      name: this.editorForm.controls["name"].value,
      brandId: this.editorForm.controls["brand"].value,
      amount: this.editorForm.controls["amount"].value,
      price: this.editorForm.controls["price"].value,
      weightInKg: this.editorForm.controls["weightInKg"].value,
      material: this.editorForm.controls["material"].value,
      lengthInCm: this.editorForm.controls["lengthInCm"].value,
      heightInCm: this.editorForm.controls["heightInCm"].value,
      widthInCm: this.editorForm.controls["widthInCm"].value,
      size: this.editorForm.controls["size"].value,
      isSet: this.editorForm.controls["isSet"].value,
      stockKeepingUnit: this.editorForm.controls["stockKeepingUnit"].value,
      description: this.editorForm.controls["description"].value,
      categoryId: this.editorForm.controls["category"].value,
    }).subscribe({
      next: response => {
        this.save.emit(response)
      }
    })
  }
  createProduct() {
    console.log("addProduct()")
    this.productService.addProduct({
      name: this.editorForm.controls["name"].value,
      brandId: this.editorForm.controls["brand"].value,
      amount: this.editorForm.controls["amount"].value,
      price: this.editorForm.controls["price"].value,
      weightInKg: this.editorForm.controls["weightInKg"].value,
      material: this.editorForm.controls["material"].value,
      lengthInCm: this.editorForm.controls["lengthInCm"].value,
      heightInCm: this.editorForm.controls["heightInCm"].value,
      widthInCm: this.editorForm.controls["widthInCm"].value,
      size: this.editorForm.controls["size"].value,
      isSet: this.editorForm.controls["isSet"].value,
      stockKeepingUnit: this.editorForm.controls["stockKeepingUnit"].value,
      description: this.editorForm.controls["description"].value,
      categoryId: this.editorForm.controls["category"].value,
    }).subscribe({
      next: response => {
        this.save.emit(response)
      }
    })
  }
}
