import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/auditoria', component: 'Dashboard', label: 'auditoria' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/auditoria', component: 'AdminDashboard', label: 'auditoria Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/auditoria', component: 'ApiList', label: 'auditoria API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/auditoria', component: 'MobileDashboard', label: 'auditoria Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/auditoria', component: 'DisplayBoard', label: 'auditoria Display' },
];
