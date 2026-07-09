import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/atendimento', component: 'Dashboard', label: 'atendimento' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/atendimento', component: 'AdminDashboard', label: 'atendimento Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/atendimento', component: 'ApiList', label: 'atendimento API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/atendimento', component: 'MobileDashboard', label: 'atendimento Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/atendimento', component: 'DisplayBoard', label: 'atendimento Display' },
];
