import { Component, inject } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { UserService } from '../../services/user-service';

@Component({
  selector: 'app-login-page',
  imports: [RouterModule, ReactiveFormsModule],
  templateUrl: './login-page.html',
  styleUrl: './login-page.css',
})
export class LoginPage {
  private userService = inject(UserService);
  private router = inject(Router);
  loginForm!: FormGroup;

  ngOnInit(): void {
    this.loginForm = new FormGroup({
      email: new FormControl("", [Validators.required, Validators.email]),
      password: new FormControl("", [Validators.required, Validators.minLength(8)])
    })
  }

  login() {
    this.userService.login(this.loginForm.controls["email"].value, this.loginForm.controls["password"].value).subscribe({
      next: response => {
        this.userService.user = response;
      }, error: error => {
        console.log(error)
      }, complete: () => {
        console.log(this.userService.user)
        this.router.navigate(["/homePage"])
      }
    })
  }
}
