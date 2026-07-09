import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/display', component: 'Dashboard', label: 'display' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/display', component: 'AdminDashboard', label: 'display Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/display', component: 'ApiList', label: 'display API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/display', component: 'MobileDashboard', label: 'display Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/display', component: 'DisplayBoard', label: 'display Display' },
];
