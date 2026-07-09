import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/governanca', component: 'Dashboard', label: 'governanca' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/governanca', component: 'AdminDashboard', label: 'governanca Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/governanca', component: 'ApiList', label: 'governanca API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/governanca', component: 'MobileDashboard', label: 'governanca Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/governanca', component: 'DisplayBoard', label: 'governanca Display' },
];
