import type { BrandingContract } from '../branding/BrandingContract'

export interface TenantContract {
  id: string
  name: string
  slug: string
  branding?: BrandingContract
}
