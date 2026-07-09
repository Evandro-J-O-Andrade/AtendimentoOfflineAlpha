import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/identity', component: 'Dashboard', label: 'identity' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/identity', component: 'AdminDashboard', label: 'identity Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/identity', component: 'ApiList', label: 'identity API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/identity', component: 'MobileDashboard', label: 'identity Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/identity', component: 'DisplayBoard', label: 'identity Display' },
];
