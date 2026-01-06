import { Routes } from '@angular/router';
import { HomePage } from './components/home-page/home-page';
import { LoginPage } from './components/login-page/login-page';
import { RegistrationPage } from './components/registration-page/registration-page';
import { PasswordResetPage } from './components/password-reset-page/password-reset-page';
import { NotFound } from './components/not-found/not-found';
import { StoragePage } from './components/admin-page/storage-page/storage-page';
import { OrderHistoryPage } from './components/admin-page/order-history-page/order-history-page';
import { AdminPage } from './components/admin-page/admin-page';
import { ProfilPage } from './components/profil-page/profil-page';
import { ProductDetails } from './components/product-details/product-details';
import { Unauthorized } from './components/unauthorized/unauthorized';
import { Basket } from './components/basket/basket';
import { AboutUsPage } from './components/about-us-page/about-us-page';
import { ProductList } from './components/product-list/product-list';

export const routes: Routes = [
  { path: "homePage", component: HomePage, },
  { path: "", pathMatch: "full", redirectTo: "homePage" },
  { path: "login", component: LoginPage },
  { path: "register", component: RegistrationPage },
  { path: "passwordReset", component: PasswordResetPage },
  { path: "productList", component: ProductList },
  { path: "aboutUs", component: AboutUsPage },
  { path: "basket", component: Basket },
  { path: "unauthorized", component: Unauthorized },
  { path: "product", component: ProductDetails },
  { path: "profilPage", component: ProfilPage },
  { path: "adminPage", component: AdminPage },
  { path: "orderHistoryPage", component: OrderHistoryPage},
  { path: "storagePage", component: StoragePage},

  { path: "**", component: NotFound },
];
