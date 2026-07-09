import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/runtime', component: 'Dashboard', label: 'runtime' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/runtime', component: 'AdminDashboard', label: 'runtime Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/runtime', component: 'ApiList', label: 'runtime API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/runtime', component: 'MobileDashboard', label: 'runtime Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/runtime', component: 'DisplayBoard', label: 'runtime Display' },
];
