import { useContext } from 'react';
import { RuntimeContext } from '@/app/providers/RuntimeContext';

export const useRuntime = () => useContext(RuntimeContext);