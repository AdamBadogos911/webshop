import { HttpEvent, HttpEventType, HttpHandlerFn, HttpRequest } from "@angular/common/http";
import { inject } from "@angular/core";
import { CookieService } from "ngx-cookie-service";
import { Observable, tap } from "rxjs";

export function CookieSetterInterceptor(req: HttpRequest<unknown>, next: HttpHandlerFn): Observable<HttpEvent<unknown>> {
  const cookieService = inject(CookieService)

  return next(req).pipe(
    tap((event) => {
      if (event.type === HttpEventType.Response) {

        const jwtToken: string | null = event.headers.get("bearer")
        const refreshToken: string | null = event.headers.get("refreshToken")

        if (jwtToken != null && refreshToken != null) {
          cookieService.set("jwt", jwtToken)
          cookieService.set("refreshToken", refreshToken)
        }
      }
    })
  )
}
