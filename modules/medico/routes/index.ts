import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/medico', component: 'Dashboard', label: 'medico' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/medico', component: 'AdminDashboard', label: 'medico Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/medico', component: 'ApiList', label: 'medico API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/medico', component: 'MobileDashboard', label: 'medico Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/medico', component: 'DisplayBoard', label: 'medico Display' },
];
