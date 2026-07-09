import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/internacao', component: 'Dashboard', label: 'internacao' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/internacao', component: 'AdminDashboard', label: 'internacao Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/internacao', component: 'ApiList', label: 'internacao API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/internacao', component: 'MobileDashboard', label: 'internacao Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/internacao', component: 'DisplayBoard', label: 'internacao Display' },
];
