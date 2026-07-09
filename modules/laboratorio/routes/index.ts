import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/laboratorio', component: 'Dashboard', label: 'laboratorio' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/laboratorio', component: 'AdminDashboard', label: 'laboratorio Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/laboratorio', component: 'ApiList', label: 'laboratorio API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/laboratorio', component: 'MobileDashboard', label: 'laboratorio Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/laboratorio', component: 'DisplayBoard', label: 'laboratorio Display' },
];
