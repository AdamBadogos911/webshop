import { Component } from '@angular/core';

@Component({
  selector: 'app-registration-page',
  imports: [],
  templateUrl: './registration-page.html',
  styleUrl: './registration-page.css',
})
export class RegistrationPage {
  enteredLastName = '';
  enteredFirstName = '';
  enteredEmail = '';
  enteredPassword = '';
  enteredPasswordAgain = '';

  onSubmit() {
    if (
      !this.enteredLastName ||
      !this.enteredFirstName ||
      !this.enteredEmail ||
      !this.enteredPassword ||
      !this.enteredPasswordAgain
    ) {
      alert('Kérem töltsön ki minden mezőt!');
    } else if (
      this.enteredEmail.includes('@') === false ||
      this.enteredEmail.includes('.') === false
    ) {
      alert('Kérem érvényes email címet adjon meg!');
    } else if (this.enteredPassword !== this.enteredPasswordAgain) {
      alert('A jelszavak nem egyeznek!');
    } else {
      alert('Sikeres regisztráció!');
      console.log(this.enteredLastName);
      console.log(this.enteredFirstName);
      console.log(this.enteredEmail);
      console.log(this.enteredPassword);
    }
  }
}
