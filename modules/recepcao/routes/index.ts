import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/recepcao', component: 'Dashboard', label: 'recepcao' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/recepcao', component: 'AdminDashboard', label: 'recepcao Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/recepcao', component: 'ApiList', label: 'recepcao API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/recepcao', component: 'MobileDashboard', label: 'recepcao Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/recepcao', component: 'DisplayBoard', label: 'recepcao Display' },
];
