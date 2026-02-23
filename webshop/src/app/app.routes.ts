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
import { AboutUsPage } from './components/about-us-page/about-us-page';
import { StatisticsPage } from './components/admin-page/statistics-page/statistics-page';
import { OrderPage } from './components/order-page/order-page';
import { CartPage } from './components/order-page/cart/cart';
import { TransportDetails } from './components/order-page/transport-details/transport-details';
import { BillingDetails } from './components/order-page/billing-details/billing-details';
import { SummaryPage } from './components/order-page/summary-page/summary-page';

export const routes: Routes = [
  { path: "homePage", component: HomePage, },
  { path: "", pathMatch: "full", redirectTo: "homePage" },
  { path: "login", component: LoginPage },
  { path: "register", component: RegistrationPage },
  { path: "passwordReset", component: PasswordResetPage },
  { path: "productList/:categoryId", loadComponent: () => import("./components/product-list/product-list").then((c) => c.ProductList) },
  { path: "aboutUs", component: AboutUsPage },
  { path: "unauthorized", component: Unauthorized },
  { path: "profile", component: ProfilPage },
  { path: "adminPage", component: AdminPage },
  { path: "orderHistoryPage", component: OrderHistoryPage},
  { path: "storagePage", component: StoragePage},
  { path: "productDetails/:productId", component: ProductDetails },
  { path: "statisticsPage", component: StatisticsPage},

  {
    path: "orderPage", component: OrderPage, children: [
      { path: "cart", component: CartPage },
      { path: "transportDetails", component: TransportDetails },
      { path: "billingDetails", component: BillingDetails },
      { path: "summary", component: SummaryPage }
    ]
  },

  { path: "**", component: NotFound },
];
