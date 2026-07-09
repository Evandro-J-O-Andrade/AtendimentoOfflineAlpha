import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/configuracao', component: 'Dashboard', label: 'configuracao' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/configuracao', component: 'AdminDashboard', label: 'configuracao Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/configuracao', component: 'ApiList', label: 'configuracao API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/configuracao', component: 'MobileDashboard', label: 'configuracao Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/configuracao', component: 'DisplayBoard', label: 'configuracao Display' },
];
