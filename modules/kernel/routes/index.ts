import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/kernel', component: 'Dashboard', label: 'kernel' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/kernel', component: 'AdminDashboard', label: 'kernel Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/kernel', component: 'ApiList', label: 'kernel API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/kernel', component: 'MobileDashboard', label: 'kernel Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/kernel', component: 'DisplayBoard', label: 'kernel Display' },
];
