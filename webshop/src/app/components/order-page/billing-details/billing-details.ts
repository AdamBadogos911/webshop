import { Component, inject } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { OtherService } from '../../../services/other-service';
import { OrderService } from '../../../services/order-service';
import { Router, RouterModule } from '@angular/router';
import { AddressType } from '../../../models/addressType.model';
import { PaymentMethod } from '../../../models/paymentMethod.model';
import { BillingDetail } from '../../../models/billingDetails.model';

@Component({
  selector: 'app-billing-details',
  imports: [ReactiveFormsModule, RouterModule],
  templateUrl: './billing-details.html',
  styleUrl: './billing-details.css',
})
export class BillingDetails {
  otherService = inject(OtherService)
  orderService = inject(OrderService)
  private router = inject(Router)
  addressTypes: AddressType[] = []
  paymentMethods: PaymentMethod[] = []
  isCompany: boolean = false
  form!: FormGroup

  ngOnInit(): void {
    this.otherService.getAllAddressType().subscribe({
      next: response => this.addressTypes = response
    })

    this.otherService.getAllPaymentMethod().subscribe({
      next: response => this.paymentMethods = response
    })

    this.form = new FormGroup({
      postCode: new FormControl(this.orderService.actualOrder.orderBillingDetail?.postCode, [Validators.required]),
      town: new FormControl(this.orderService.actualOrder.orderBillingDetail?.town, [Validators.required]),
      addressType: new FormControl(this.orderService.actualOrder.orderBillingDetail?.billingAddressType.id, [Validators.required]),
      address: new FormControl(this.orderService.actualOrder.orderBillingDetail?.address, [Validators.required]),
      houseNumber: new FormControl(this.orderService.actualOrder.orderBillingDetail?.houseNumber, [Validators.required]),
      other: new FormControl(this.orderService.actualOrder.orderBillingDetail?.other, []),
      paymentMethod: new FormControl(this.orderService.actualOrder.paymentMethod?.id, [Validators.required])
    })
  }

  continue() {
    const billingDetail: BillingDetail = new BillingDetail(
      null,
      this.form.controls["postCode"].value,
      this.form.controls["town"].value,
      this.form.controls["address"].value,
      this.form.controls["houseNumber"].value,
      this.isCompany ? this.form.controls["companyName"].value : null,
      this.isCompany ? this.form.controls["taxNumber"].value : null,
      this.form.controls["other"].value,
      this.addressTypes[this.addressTypes.findIndex(at => at.id === +this.form.controls["addressType"].value)],
    )

    this.orderService.actualOrder.orderBillingDetail = billingDetail
    this.orderService.actualOrder.paymentMethod = this.paymentMethods[this.paymentMethods.findIndex(pm => pm.id === this.form.controls["paymentMethod"].value)]
    this.router.navigate(["orderPage", "summary"])
  }

  setPaymentMethod(selectedId: number) {
    this.form.controls["paymentMethod"].setValue(selectedId)
  }

  handleCompany() {
    if (this.isCompany) {
      this.form.removeControl("companyName")
      this.form.removeControl("taxNumber")
    } else {
      this.form.addControl("companyName", new FormControl(this.orderService.actualOrder.orderBillingDetail?.companyName, [Validators.required]))
      this.form.addControl("taxNumber", new FormControl(this.orderService.actualOrder.orderBillingDetail?.taxNumber, [Validators.required]))
    }

    this.isCompany = !this.isCompany
  }
}
