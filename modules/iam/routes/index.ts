import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/iam', component: 'Dashboard', label: 'iam' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/iam', component: 'AdminDashboard', label: 'iam Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/iam', component: 'ApiList', label: 'iam API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/iam', component: 'MobileDashboard', label: 'iam Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/iam', component: 'DisplayBoard', label: 'iam Display' },
];
