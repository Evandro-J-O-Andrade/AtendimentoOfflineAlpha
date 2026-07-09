import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/notificacao', component: 'Dashboard', label: 'notificacao' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/notificacao', component: 'AdminDashboard', label: 'notificacao Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/notificacao', component: 'ApiList', label: 'notificacao API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/notificacao', component: 'MobileDashboard', label: 'notificacao Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/notificacao', component: 'DisplayBoard', label: 'notificacao Display' },
];
