import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/farmacia', component: 'Dashboard', label: 'farmacia' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/farmacia', component: 'AdminDashboard', label: 'farmacia Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/farmacia', component: 'ApiList', label: 'farmacia API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/farmacia', component: 'MobileDashboard', label: 'farmacia Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/farmacia', component: 'DisplayBoard', label: 'farmacia Display' },
];
