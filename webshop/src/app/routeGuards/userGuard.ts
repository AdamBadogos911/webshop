import { inject, Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, CanActivate, RedirectCommand, Route, Router, RouterStateSnapshot, UrlSegment } from "@angular/router";
import { UserService } from "../services/user-service";

@Injectable({
  providedIn: "root"
})
export class UserGuard implements CanActivate {
  userService = inject(UserService)
  private router = inject(Router)

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (this.userService.user != null) {
      return true;
    }

    return new RedirectCommand(this.router.parseUrl("/unauthorized"))
  }
}
