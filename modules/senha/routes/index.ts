import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/senha', component: 'Dashboard', label: 'senha' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/senha', component: 'AdminDashboard', label: 'senha Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/senha', component: 'ApiList', label: 'senha API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/senha', component: 'MobileDashboard', label: 'senha Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/senha', component: 'DisplayBoard', label: 'senha Display' },
];
