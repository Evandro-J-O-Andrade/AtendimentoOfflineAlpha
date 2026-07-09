import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/ffa', component: 'Dashboard', label: 'ffa' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/ffa', component: 'AdminDashboard', label: 'ffa Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/ffa', component: 'ApiList', label: 'ffa API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/ffa', component: 'MobileDashboard', label: 'ffa Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/ffa', component: 'DisplayBoard', label: 'ffa Display' },
];
