import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useSurgeons } from '@/features/surgeons/hooks/useSurgeons'
import { authApi } from '@/features/auth/api/authApi'
import { useAuthStore } from '@/store/authStore'
import type { Surgeon } from '@/features/surgeons/api/surgeonsApi'

export function SurgeonsPage() {
  const navigate = useNavigate()
  const { user, logout } = useAuthStore()
  const setImpersonation = useAuthStore((s) => s.setImpersonation)
  const { data, isLoading, isError } = useSurgeons()
  const [impersonating, setImpersonating] = useState<string | null>(null)

  async function handleImpersonate(surgeon: Surgeon) {
    setImpersonating(surgeon.userId)
    try {
      const { accessToken, user: surgeonUser } = await authApi.impersonate(surgeon.userId)
      setImpersonation(accessToken, surgeonUser)
      navigate('/', { replace: true })
    } catch {
      setImpersonating(null)
    }
  }

  return (
    <div style={styles.page}>
      <header style={styles.header}>
        <div>
          <h1 style={styles.title}>Surgeons</h1>
          <p style={styles.subtitle}>Select a surgeon to view their dashboard</p>
        </div>
        <div style={styles.headerRight}>
          <span style={styles.userBadge}>{user?.name}</span>
          <button onClick={logout} style={styles.logoutBtn}>
            Sign out
          </button>
        </div>
      </header>

      <main style={styles.main}>
        {isError && (
          <p style={styles.errorMsg}>Failed to load surgeons. Please try again.</p>
        )}

        {isLoading ? (
          <div style={styles.grid}>
            {[...Array(3)].map((_, i) => (
              <div key={i} style={styles.skeleton} />
            ))}
          </div>
        ) : (
          <div style={styles.grid}>
            {data?.items.map((surgeon) => (
              <SurgeonCard
                key={surgeon.userId}
                surgeon={surgeon}
                loading={impersonating === surgeon.userId}
                onImpersonate={() => handleImpersonate(surgeon)}
              />
            ))}
          </div>
        )}
      </main>
    </div>
  )
}

interface SurgeonCardProps {
  surgeon: Surgeon
  loading: boolean
  onImpersonate: () => void
}

function SurgeonCard({ surgeon, loading, onImpersonate }: SurgeonCardProps) {
  return (
    <div style={styles.card}>
      <div style={styles.avatar}>{getInitials(surgeon.name)}</div>
      <div style={styles.cardBody}>
        <p style={styles.surgeonName}>{surgeon.name}</p>
        {surgeon.speciality && (
          <p style={styles.speciality}>{surgeon.speciality}</p>
        )}
      </div>
      <button
        onClick={onImpersonate}
        disabled={loading}
        style={styles.viewBtn}
      >
        {loading ? 'Opening…' : 'View Dashboard'}
      </button>
    </div>
  )
}

function getInitials(name: string) {
  return name
    .split(' ')
    .filter((p) => p.length > 0 && p !== 'Dr.')
    .slice(0, 2)
    .map((p) => p[0].toUpperCase())
    .join('')
}

const styles: Record<string, React.CSSProperties> = {
  page: {
    minHeight: '100vh',
    background: '#f3f4f6',
  },
  header: {
    background: '#fff',
    borderBottom: '1px solid #e5e7eb',
    padding: '1rem 2rem',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  headerRight: {
    display: 'flex',
    alignItems: 'center',
    gap: '0.75rem',
  },
  title: {
    margin: 0,
    fontSize: '1.25rem',
    fontWeight: 700,
    color: '#111827',
  },
  subtitle: {
    margin: '0.125rem 0 0',
    fontSize: '0.875rem',
    color: '#6b7280',
  },
  userBadge: {
    fontSize: '0.875rem',
    color: '#374151',
    fontWeight: 500,
  },
  logoutBtn: {
    padding: '0.375rem 0.75rem',
    background: 'transparent',
    border: '1px solid #d1d5db',
    borderRadius: '0.375rem',
    fontSize: '0.875rem',
    color: '#374151',
    cursor: 'pointer',
  },
  main: {
    padding: '2rem',
    maxWidth: '1280px',
    margin: '0 auto',
  },
  errorMsg: {
    color: '#dc2626',
    fontSize: '0.875rem',
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap: '1rem',
  },
  skeleton: {
    height: '8rem',
    borderRadius: '0.75rem',
    background: '#e5e7eb',
    animation: 'pulse 1.5s ease-in-out infinite',
  },
  card: {
    background: '#fff',
    border: '1px solid #e5e7eb',
    borderRadius: '0.75rem',
    padding: '1.25rem',
    display: 'flex',
    flexDirection: 'column',
    gap: '0.75rem',
  },
  avatar: {
    width: '3rem',
    height: '3rem',
    borderRadius: '50%',
    background: '#dbeafe',
    color: '#1d4ed8',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontWeight: 700,
    fontSize: '1rem',
  },
  cardBody: {
    flex: 1,
  },
  surgeonName: {
    margin: 0,
    fontWeight: 600,
    fontSize: '0.9375rem',
    color: '#111827',
  },
  speciality: {
    margin: '0.125rem 0 0',
    fontSize: '0.8125rem',
    color: '#6b7280',
  },
  viewBtn: {
    padding: '0.5rem 1rem',
    background: '#2563eb',
    color: '#fff',
    border: 'none',
    borderRadius: '0.375rem',
    fontSize: '0.875rem',
    fontWeight: 600,
    cursor: 'pointer',
    alignSelf: 'flex-start',
  },
}
