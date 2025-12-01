import { Routes } from '@angular/router';
import { HomePage } from './components/home-page/home-page';
import { LoginPage } from './components/login-page/login-page';
import { RegistrationPage } from './components/registration-page/registration-page';
import { PasswordResetPage } from './components/password-reset-page/password-reset-page';

export const routes: Routes = [
  { path: "homePage", component: HomePage, },
  { path: "", pathMatch: "full", redirectTo: "homePage" },
  { path: "login", component: LoginPage },
  { path: "register", component: RegistrationPage },
  { path: "passwordReset", component: PasswordResetPage }
];
