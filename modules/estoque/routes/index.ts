import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/estoque', component: 'Dashboard', label: 'estoque' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/estoque', component: 'AdminDashboard', label: 'estoque Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/estoque', component: 'ApiList', label: 'estoque API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/estoque', component: 'MobileDashboard', label: 'estoque Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/estoque', component: 'DisplayBoard', label: 'estoque Display' },
];
