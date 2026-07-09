import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/fila', component: 'Dashboard', label: 'fila' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/fila', component: 'AdminDashboard', label: 'fila Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/fila', component: 'ApiList', label: 'fila API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/fila', component: 'MobileDashboard', label: 'fila Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/fila', component: 'DisplayBoard', label: 'fila Display' },
];
