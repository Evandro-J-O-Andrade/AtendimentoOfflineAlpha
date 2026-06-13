import { useContext } from 'react';
import { TenantContext } from '@/app/providers/TenantProvider';

export const useTenant = () => useContext(TenantContext);