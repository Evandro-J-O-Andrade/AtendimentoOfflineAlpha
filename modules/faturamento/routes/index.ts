import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/faturamento', component: 'Dashboard', label: 'faturamento' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/faturamento', component: 'AdminDashboard', label: 'faturamento Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/faturamento', component: 'ApiList', label: 'faturamento API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/faturamento', component: 'MobileDashboard', label: 'faturamento Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/faturamento', component: 'DisplayBoard', label: 'faturamento Display' },
];
