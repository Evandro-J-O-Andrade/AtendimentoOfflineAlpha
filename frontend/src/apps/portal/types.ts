export type PortalModuleStatus = "active" | "inactive";

export type PortalModuleAccent =
  | "blue"
  | "emerald"
  | "amber"
  | "orange"
  | "violet"
  | "cyan"
  | "indigo"
  | "rose"
  | "teal";

export interface PortalModule {
  id: string;
  name: string;
  description: string;
  icon: string;
  path: string;
  active: boolean;
  requiresContext: boolean;
  accent: PortalModuleAccent;
  status: PortalModuleStatus;
}

export interface PortalBranding {
  productName: string;
  organizationName: string;
  companyName: string;
  logoUrl: string;
  primaryColor: string;
}
