import { useState, type ReactNode } from 'react'
import styles from './LoginPage.module.css'

interface IconItem {
  label: string
  icon: ReactNode
}

const icons: IconItem[] = [
  {
    label: 'Analytics',
    icon: <IconBarChart2 />,
  },
  {
    label: 'Usuários',
    icon: <IconUsers />,
  },
  {
    label: 'Documentos',
    icon: <IconFileText />,
  },
  {
    label: 'Mensagens',
    icon: <IconMessageSquare />,
  },
  {
    label: 'Segurança',
    icon: <IconShield />,
  },
  {
    label: 'Inteligência Analítica',
    icon: <IconPieChart />,
  },
]

function BrandIcon({ children, label, onActivate }: { children: ReactNode; label: string; onActivate: () => void }) {
  return (
    <div className={styles.brandIconItem} onClick={onActivate} role="button" tabIndex={0}>
      {children}
    </div>
  )
}

function IconBarChart2() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M18 20V10" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <rect x="14" y="10" width="4" height="10" rx="1" stroke="currentColor" strokeWidth="1.25" fill="none" />
      <path d="M12 20V4" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <rect x="8" y="4" width="4" height="16" rx="1" stroke="currentColor" strokeWidth="1.25" fill="none" />
      <path d="M6 20v-6" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <rect x="2" y="14" width="4" height="6" rx="1" stroke="currentColor" strokeWidth="1.25" fill="none" />
    </svg>
  )
}

function IconUsers() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="9" cy="7" r="4" stroke="currentColor" strokeWidth="1.25" fill="none" />
      <path d="M22 21v-2a4 4 0 0 0-3-3.87" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="17" cy="8" r="3" stroke="currentColor" strokeWidth="1.25" fill="none" />
    </svg>
  )
}

function IconFileText() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M14 2v6h6" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M16 13H8" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M16 17H8" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M10 9H8" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconMessageSquare() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M8 9h.01M12 9h.01M16 9h.01" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" fill="none" />
    </svg>
  )
}

function IconShield() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M9 12l2 2 4-4" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
    </svg>
  )
}

function IconPieChart() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="M21.21 15.89A10 10 0 1 1 8 2.83" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <path d="M22 12A10 10 0 0 0 12 2v10h10z" stroke="currentColor" strokeWidth="1.25" strokeLinecap="round" strokeLinejoin="round" fill="none" />
      <circle cx="12" cy="12" r="1" fill="currentColor" />
    </svg>
  )
}

interface LoginHeroProps {
  darkMode: boolean
}

export function LoginHero({ darkMode }: LoginHeroProps) {
  const [activeIcon, setActiveIcon] = useState<IconItem | null>(null)

  return (
    <section className={`${styles.leftPanel} ${darkMode ? styles.themeDark : styles.themeLight}`}>
      <div className={styles.leftOverlay} />
      <div className={styles.leftContent}>
        <img
          src="/assets/branding/logoSaaSHeros.png"
          alt="New Wave Enterprise Logo"
          className={styles.leftLogo}
        />
        <h2 className={styles.leftTitle}>
          New Wave <span>Enterprise</span>
        </h2>
        <p className={styles.leftText}>
          Plataforma SaaS Corporativa de Gestão e Inteligência Analítica
        </p>

        <div className={styles.brandIcons}>
          {icons.map((item) => (
            <BrandIcon key={item.label} label={item.label} onActivate={() => setActiveIcon(item)}>
              {item.icon}
            </BrandIcon>
          ))}
        </div>
      </div>

      {activeIcon && (
        <div className={styles.brandIconOverlay} onClick={() => setActiveIcon(null)}>
          <div className={styles.brandIconOverlayInner} onClick={(e) => e.stopPropagation()}>
            <div className={styles.brandIconOverlayIcon}>{activeIcon.icon}</div>
            <div className={styles.brandIconOverlayLabel}>{activeIcon.label}</div>
          </div>
        </div>
      )}
    </section>
  )
}
