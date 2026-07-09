import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/financeiro', component: 'Dashboard', label: 'financeiro' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/financeiro', component: 'AdminDashboard', label: 'financeiro Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/financeiro', component: 'ApiList', label: 'financeiro API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/financeiro', component: 'MobileDashboard', label: 'financeiro Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/financeiro', component: 'DisplayBoard', label: 'financeiro Display' },
];
