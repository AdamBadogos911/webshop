import { Routes } from '@angular/router';
import { AboutUsPage } from './components/about-us-page/about-us-page';
import { AdminPage } from './components/admin-page/admin-page';
import { HomePage } from './components/home-page/home-page';
import { LoginPage } from './components/login-page/login-page';
import { NotFound } from './components/not-found/not-found';
import { BillingDetails } from './components/order-page/billing-details/billing-details';
import { CartPage } from './components/order-page/cart/cart';
import { OrderPage } from './components/order-page/order-page';
import { SummaryPage } from './components/order-page/summary-page/summary-page';
import { TransportDetails } from './components/order-page/transport-details/transport-details';
import { PasswordResetPage } from './components/password-reset-page/password-reset-page';
import { ProfilPage } from './components/profil-page/profil-page';
import { RegistrationPage } from './components/registration-page/registration-page';
import { Unauthorized } from './components/unauthorized/unauthorized';
import { UserGuard } from './routeGuards/userGuard';
import { AdminGuard } from './routeGuards/adminGuard';

export const routes: Routes = [
  { path: "homePage", component: HomePage, },
  { path: "", pathMatch: "full", redirectTo: "homePage" },
  { path: "login", component: LoginPage },
  { path: "register", component: RegistrationPage },
  { path: "passwordReset", component: PasswordResetPage },
  { path: "aboutUs", component: AboutUsPage },
  { path: "unauthorized", component: Unauthorized },
  { path: "profile", component: ProfilPage, canActivate: [UserGuard] },
  { path: "adminPage", component: AdminPage, canActivate: [UserGuard, AdminGuard] },

  {
    path: "orderPage", component: OrderPage, canActivate: [UserGuard], children: [
      { path: "cart", component: CartPage },
      { path: "transportDetails", component: TransportDetails },
      { path: "billingDetails", component: BillingDetails },
      { path: "summary", component: SummaryPage }
    ]
  },

  //lazyLoading:
  { path: "productList/:categoryId", loadComponent: () => import("./components/product-list/product-list").then((c) => c.ProductList) },
  { path: "productDetails/:productId", loadComponent: () => import("./components/product-details/product-details").then((c) => c.ProductDetails) },
  { path: "orderHistoryPage", canActivate: [AdminGuard], loadComponent: () => import("./components/admin-page/order-history-page/order-history-page").then((c) => c.OrderHistoryPage) },
  { path: "storagePage", canActivate: [AdminGuard], loadComponent: () => import("./components/admin-page/storage-page/storage-page").then((c) => c.StoragePage) },
  { path: "statisticsPage", canActivate: [AdminGuard], loadComponent: () => import("./components/admin-page/statistics-page/statistics-page").then((c) => c.StatisticsPage) },
  { path: "**", component: NotFound },
];
