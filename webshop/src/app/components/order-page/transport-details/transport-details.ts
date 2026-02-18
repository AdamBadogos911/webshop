import { Component, inject } from '@angular/core';
import { OtherService } from '../../../services/other-service';
import { OrderService } from '../../../services/order-service';
import { Router } from '@angular/router';
import { AddressType } from '../../../models/addressType.model';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { TransportDetail } from '../../../models/transportDetail.model';

@Component({
  selector: 'app-transport-details',
  imports: [ReactiveFormsModule],
  templateUrl: './transport-details.html',
  styleUrl: './transport-details.css',
})
export class TransportDetails {
private otherService = inject(OtherService)
  private orderService = inject(OrderService)
  private router = inject(Router)
  addressTypes: AddressType[] = []
  detailsForm!: FormGroup

  ngOnInit(): void {
    this.otherService.getAllAddressType().subscribe({
      next: response => this.addressTypes = response
    })

    this.detailsForm = new FormGroup({
      firstName: new FormControl(this.orderService.actualOrder.firstName, [Validators.required]),
      lastName: new FormControl(this.orderService.actualOrder.lastName, [Validators.required]),
      email: new FormControl(this.orderService.actualOrder.email, [Validators.required, Validators.email]),
      phoneNumber: new FormControl(this.orderService.actualOrder.phone, [Validators.required]),
      postCode: new FormControl(this.orderService.actualOrder.orderTransportDetail?.postCode, [Validators.required]),
      town: new FormControl(this.orderService.actualOrder.orderTransportDetail?.town, [Validators.required]),
      addressType: new FormControl(this.orderService.actualOrder.orderTransportDetail?.transportAddressType.id, [Validators.required]),
      address: new FormControl(this.orderService.actualOrder.orderTransportDetail?.address, [Validators.required]),
      houseNumber: new FormControl(this.orderService.actualOrder.orderTransportDetail?.houseNumber, [Validators.required]),
      other: new FormControl(this.orderService.actualOrder.orderTransportDetail?.other, [])
    })
  }

  continue() {
    this.orderService.actualOrder.firstName = this.detailsForm.controls["firstName"].value
    this.orderService.actualOrder.lastName = this.detailsForm.controls["lastName"].value
    this.orderService.actualOrder.phone = this.detailsForm.controls["phoneNumber"].value
    this.orderService.actualOrder.email = this.detailsForm.controls["email"].value
    this.orderService.actualOrder.orderTransportDetail = new TransportDetail(
      null,
      this.detailsForm.controls["postCode"].value,
      this.detailsForm.controls["town"].value,
      this.detailsForm.controls["address"].value,
      this.detailsForm.controls["houseNumber"].value,
      this.detailsForm.controls["other"].value,
      this.addressTypes[this.addressTypes.findIndex((at) => at.id === +this.detailsForm.controls["addressType"].value)]
    )

    this.router.navigate(["orderPage", "billingDetails"])
  }
}
