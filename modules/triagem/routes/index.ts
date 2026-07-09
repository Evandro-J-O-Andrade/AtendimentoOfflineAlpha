import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/triagem', component: 'Dashboard', label: 'triagem' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/triagem', component: 'AdminDashboard', label: 'triagem Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/triagem', component: 'ApiList', label: 'triagem API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/triagem', component: 'MobileDashboard', label: 'triagem Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/triagem', component: 'DisplayBoard', label: 'triagem Display' },
];
