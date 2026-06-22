import { useState, type FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { authApi } from '@/features/auth/api/authApi'
import { useAuthStore } from '@/store/authStore'

export function LoginPage() {
  const navigate = useNavigate()
  const setAuth = useAuthStore((s) => s.setAuth)

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      const { accessToken, user } = await authApi.login({ email, password })
      setAuth(accessToken, user)
      navigate(user.role === 'EMPLOYEE' ? '/surgeons' : '/', { replace: true })
    } catch {
      setError('Invalid email or password')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={styles.page}>
      <div style={styles.card}>
        <h1 style={styles.title}>GaitWay Analytics</h1>
        <p style={styles.subtitle}>Sign in to your account</p>

        <form onSubmit={handleSubmit} style={styles.form}>
          <div style={styles.field}>
            <label htmlFor="email" style={styles.label}>
              Email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoComplete="email"
              style={styles.input}
              placeholder="you@hospital.com"
            />
          </div>

          <div style={styles.field}>
            <label htmlFor="password" style={styles.label}>
              Password
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              autoComplete="current-password"
              style={styles.input}
              placeholder="••••••••"
            />
          </div>

          {error && <p style={styles.error}>{error}</p>}

          <button type="submit" disabled={loading} style={styles.button}>
            {loading ? 'Signing in…' : 'Sign in'}
          </button>
        </form>

        <div style={styles.hint}>
          <p style={styles.hintTitle}>Demo credentials</p>
          <p style={styles.hintRow}>Employee: employee@hospital.com / employee123</p>
          <p style={styles.hintRow}>Surgeon: dr.smith@hospital.com / surgeon123</p>
        </div>
      </div>
    </div>
  )
}

const styles: Record<string, React.CSSProperties> = {
  page: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    background: '#f3f4f6',
  },
  card: {
    background: '#fff',
    borderRadius: '0.75rem',
    padding: '2rem',
    width: '100%',
    maxWidth: '400px',
    boxShadow: '0 1px 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.06)',
  },
  title: {
    margin: '0 0 0.25rem',
    fontSize: '1.5rem',
    fontWeight: 700,
    color: '#111827',
    textAlign: 'center',
  },
  subtitle: {
    margin: '0 0 1.5rem',
    fontSize: '0.875rem',
    color: '#6b7280',
    textAlign: 'center',
  },
  form: {
    display: 'flex',
    flexDirection: 'column',
    gap: '1rem',
  },
  field: {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.25rem',
  },
  label: {
    fontSize: '0.875rem',
    fontWeight: 500,
    color: '#374151',
  },
  input: {
    padding: '0.5rem 0.75rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.375rem',
    fontSize: '0.875rem',
    outline: 'none',
    color: '#111827',
  },
  error: {
    margin: 0,
    fontSize: '0.875rem',
    color: '#dc2626',
  },
  button: {
    padding: '0.625rem',
    background: '#2563eb',
    color: '#fff',
    border: 'none',
    borderRadius: '0.375rem',
    fontSize: '0.875rem',
    fontWeight: 600,
    cursor: 'pointer',
    marginTop: '0.25rem',
  },
  hint: {
    marginTop: '1.5rem',
    padding: '0.75rem',
    background: '#f9fafb',
    borderRadius: '0.5rem',
    border: '1px solid #e5e7eb',
  },
  hintTitle: {
    margin: '0 0 0.25rem',
    fontSize: '0.75rem',
    fontWeight: 600,
    color: '#6b7280',
    textTransform: 'uppercase',
    letterSpacing: '0.05em',
  },
  hintRow: {
    margin: '0.125rem 0 0',
    fontSize: '0.75rem',
    color: '#6b7280',
    fontFamily: 'monospace',
  },
}
