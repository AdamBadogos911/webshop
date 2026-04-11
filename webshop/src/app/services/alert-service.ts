import { Injectable } from '@angular/core';

type alertDetails = {
  type: "error" | "success",
  message: string
}

@Injectable({
  providedIn: 'root',
})
export class AlertService {
  alert: alertDetails = {
    type: "error",
    message: ""
  }
  showAlert: boolean = false

  setAlert(type: "error" | "success", message: string) {
    this.alert = {
      type: type,
      message: message
    }
  }
}
