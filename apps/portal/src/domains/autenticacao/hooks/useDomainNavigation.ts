import { useState, useCallback } from 'react'
import { useRouter } from '../../../app/router'
import type { DomainConfig } from '../../index'

export interface UseDomainNavigationOptions {
  onNavigate?: (domain: DomainConfig) => void
}

export function useDomainNavigation(options: UseDomainNavigationOptions = {}) {
  const router = useRouter()
  const [activeDomain, setActiveDomain] = useState<DomainConfig | null>(null)

  const navigateToDomain = useCallback((domain: DomainConfig) => {
    setActiveDomain(domain)
    router.navigate('portal')
    options.onNavigate?.(domain)
  }, [router, options])

  return {
    activeDomain,
    navigateToDomain,
    clearDomain: useCallback(() => setActiveDomain(null), [])
  }
}
