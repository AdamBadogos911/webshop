import { Component, inject, Input, Output } from '@angular/core';
import { UserService } from '../../services/user-service';
import { Router, RouterModule } from '@angular/router';
import { FormControl, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-registration-page',
  standalone: true,
  imports: [ ReactiveFormsModule, RouterModule ],
  templateUrl: './registration-page.html',
  styleUrls: ['./registration-page.css'],
})
export class RegistrationPage {
  private userService = inject(UserService)
  private router = inject(Router)
  registerForm!: FormGroup


  ngOnInit(): void {
    this.registerForm = new FormGroup({
      firstName: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      lastName: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      email: new FormControl('', [Validators.required, Validators.email]),
      password: new FormControl('', [Validators.required, Validators.minLength(8)]),
      passwordAgain: new FormControl('', [Validators.required, Validators.minLength(8)])
    })
  }

  sendRegister() {
    const newUser = new User(this.registerForm.controls["email"].value, this.registerForm.controls["password"].value, this.registerForm.controls["firstName"].value, this.registerForm.controls["lastName"].value)
    this.userService.register(newUser).subscribe({
      next: response => {
        console.log(response)

      },
      error: error => console.log(error),
      complete: () => {
        this.router.navigate(["/login"])
      }
    })
  }
}
