export type PortalModuleAccent = "indigo" | "emerald" | "blue" | "purple" | "orange" | "rose" | "amber" | "cyan" | "teal" | "slate";

export type PortalModuleStatus = "active" | "inactive";

export interface PortalModule {
    id: string;
    name: string;
    description?: string;
    icon?: string;
    path?: string;
    category?: string;
    active?: boolean;
    component?: string;
    accent?: PortalModuleAccent;
    requiresContext?: boolean;
    favorite?: boolean;
}