import { useContext } from 'react';
import { AuthContext } from '@/apps/operacional/auth/AuthProvider';

export const useAuth = () => useContext(AuthContext);