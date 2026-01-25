import { Component, inject, Input, Output } from '@angular/core';
import { UserService } from '../../services/user-service';
import { Router, RouterModule } from '@angular/router';
import { FormControl, FormGroup, Validators, ReactiveFormsModule, AbstractControl } from '@angular/forms';
import { User } from '../../models/user.model';

function validatePassword(control: AbstractControl): { [key: string]: any } | null {
  const password: string = control.value

  const specialCharacters: string = "!@#$%^&*()-_=+[]{};:,.?/"
  const numberTexts: string = "1234567890"
  const checkerList: boolean[] = [false, false, false, false]

  for (let i: number = 0; i < password.length; i++) {
    if (specialCharacters.includes(password[i])) {
      checkerList[0] = true
    } else if (numberTexts.includes(password[i])) {
      checkerList[1] = true
    } else if (password[i] === password[i].toUpperCase()) {
      checkerList[2] = true
    } else if (password[i] === password[i].toLowerCase()) {
      checkerList[3] = true
    }
  }

  if (!checkerList.includes(false)) {
    return null
  } else {
    return { invalid: false }
  }
}

@Component({
  selector: 'app-registration-page',
  standalone: true,
  imports: [ReactiveFormsModule, RouterModule],
  templateUrl: './registration-page.html',
  styleUrls: ['./registration-page.css'],
})
export class RegistrationPage {
  private userService = inject(UserService)
  private router = inject(Router)
  registerForm!: FormGroup

  samePasswordValidator = (control: AbstractControl): { [key: string]: any } | null => {
    let originalPassword = this.registerForm.controls["password"].value
    if (control.value === originalPassword) {
      return null
    } else {
      return { invalid: false }
    }
  }

  ngOnInit(): void {
    this.registerForm = new FormGroup({
      firstName: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      lastName: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      email: new FormControl('', [Validators.required, Validators.email]),
      password: new FormControl('', [Validators.required, Validators.minLength(8), validatePassword]),
      passwordAgain: new FormControl('', [Validators.required, Validators.minLength(8), validatePassword])
    })

    this.registerForm.controls["passwordAgain"].addValidators(this.samePasswordValidator)
  }

  sendRegister() {
    const newUser = new User(this.registerForm.controls["email"].value, this.registerForm.controls["password"].value, this.registerForm.controls["firstName"].value, this.registerForm.controls["lastName"].value)
    this.userService.register(newUser).subscribe({
      error: error => console.log(error),
      complete: () => {
        this.router.navigate(["/login"])
      }
    })
  }
}
