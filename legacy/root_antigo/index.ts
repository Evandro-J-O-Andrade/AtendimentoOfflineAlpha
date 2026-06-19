import { LucideIcon } from 'lucide-react';

export interface Modulo {
  id: string;
  codigo: string;
  nome: string;
  description: string;
  icon: LucideIcon;
  path: string;
  active: boolean;
  categoria: 'OPERACIONAL' | 'CORPORATIVO' | 'GESTAO';
  color: string;
}

export interface ClienteConfig {
  nomeOrganizacao: string;
  logoUrl?: string;
  primaryColor: string;
}