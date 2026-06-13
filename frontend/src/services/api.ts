// Re-export API from operacional services
export { api, callSP, setAccessToken, getAccessToken } from '@/apps/operacional/services/api';
export default (await import('@/apps/operacional/services/api')).default;