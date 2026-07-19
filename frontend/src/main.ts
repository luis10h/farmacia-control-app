import { bootstrapApplication } from '@angular/platform-browser';
import { provideRouter } from '@angular/router';
import { provideHttpClient, withInterceptors } from '@angular/platform-browser/http';
import { AppComponent } from './app/app.component';
import { routes } from './app/app.routes';
import { httpErrorInterceptor } from './app/core/interceptors/error.interceptor';

bootstrapApplication(AppComponent, {
  providers: [
    provideRouter(routes),
    provideHttpClient(
      withInterceptors([httpErrorInterceptor])
    )
  ]
}).catch(err => console.error(err));
