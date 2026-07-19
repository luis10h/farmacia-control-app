import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="flex h-screen bg-gray-100">
      <!-- Sidebar -->
      <aside class="w-64 bg-slate-800 text-white shadow-lg">
        <div class="p-6 border-b border-slate-700">
          <h1 class="text-2xl font-bold">💊 FarmaControl</h1>
          <p class="text-sm text-slate-400 mt-1">v1.0.0</p>
        </div>
        <nav class="mt-8 px-4 space-y-2">
          <a href="/" class="block px-4 py-2 rounded-lg hover:bg-slate-700 transition">📊 Dashboard</a>
          <a href="/medicamentos" class="block px-4 py-2 rounded-lg hover:bg-slate-700 transition">💊 Medicamentos</a>
          <a href="/ventas" class="block px-4 py-2 rounded-lg hover:bg-slate-700 transition">🛒 Ventas</a>
          <a href="/inventario" class="block px-4 py-2 rounded-lg hover:bg-slate-700 transition">📦 Inventario</a>
          <a href="/reportes" class="block px-4 py-2 rounded-lg hover:bg-slate-700 transition">📈 Reportes</a>
        </nav>
      </aside>

      <!-- Main Content -->
      <main class="flex-1 overflow-auto">
        <header class="bg-white shadow-sm border-b border-gray-200 p-6">
          <h2 class="text-3xl font-bold text-gray-800">Farmacia Control</h2>
          <p class="text-gray-600 mt-1">Sistema de gestión de farmacia</p>
        </header>
        <div class="p-8">
          <router-outlet></router-outlet>
        </div>
      </main>
    </div>
  `,
  styles: []
})
export class AppComponent {
  title = 'farmacia-control-app';
}
