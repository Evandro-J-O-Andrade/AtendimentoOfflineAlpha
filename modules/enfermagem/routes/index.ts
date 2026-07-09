import { RouteConfig } from '@/core/types';

export const portalRoutes: RouteConfig[] = [
  { path: '/enfermagem', component: 'Dashboard', label: 'enfermagem' },
];

export const adminRoutes: RouteConfig[] = [
  { path: '/admin/enfermagem', component: 'AdminDashboard', label: 'enfermagem Admin' },
];

export const apiRoutes: RouteConfig[] = [
  { path: '/api/enfermagem', component: 'ApiList', label: 'enfermagem API' },
];

export const mobileRoutes: RouteConfig[] = [
  { path: '/mobile/enfermagem', component: 'MobileDashboard', label: 'enfermagem Mobile' },
];

export const displayRoutes: RouteConfig[] = [
  { path: '/display/enfermagem', component: 'DisplayBoard', label: 'enfermagem Display' },
];
