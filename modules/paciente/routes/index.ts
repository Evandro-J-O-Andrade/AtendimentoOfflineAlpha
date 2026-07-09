import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/paciente', component: 'Dashboard', label: 'paciente' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/paciente', component: 'AdminDashboard', label: 'paciente Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/paciente', component: 'ApiList', label: 'paciente API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/paciente', component: 'MobileDashboard', label: 'paciente Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/paciente', component: 'DisplayBoard', label: 'paciente Display' },
];
