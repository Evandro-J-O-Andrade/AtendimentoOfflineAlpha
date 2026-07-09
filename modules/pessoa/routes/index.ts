import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/pessoa', component: 'Dashboard', label: 'pessoa' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/pessoa', component: 'AdminDashboard', label: 'pessoa Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/pessoa', component: 'ApiList', label: 'pessoa API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/pessoa', component: 'MobileDashboard', label: 'pessoa Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/pessoa', component: 'DisplayBoard', label: 'pessoa Display' },
];
