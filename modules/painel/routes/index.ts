import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/painel', component: 'Dashboard', label: 'painel' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/painel', component: 'AdminDashboard', label: 'painel Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/painel', component: 'ApiList', label: 'painel API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/painel', component: 'MobileDashboard', label: 'painel Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/painel', component: 'DisplayBoard', label: 'painel Display' },
];
