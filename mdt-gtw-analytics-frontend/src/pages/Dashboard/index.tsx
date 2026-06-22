import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import type { Metric } from '../../features/dashboard/api/analyticsApi'
import { MetricCard } from '../../features/dashboard/components/MetricCard'
import { RevenueChart } from '../../features/dashboard/components/RevenueChart'
import { useMetrics } from '../../features/dashboard/hooks/useMetrics'
import { useRevenue } from '../../features/dashboard/hooks/useRevenue'
import { ImpersonationBanner } from '../../components/ImpersonationBanner'
import { useAuthStore } from '../../store/authStore'
import { useMe } from '../../features/auth/hooks/useMe'

export function DashboardPage() {
  const { t } = useTranslation('dashboard')
  const navigate = useNavigate()
  const { user, logout } = useAuthStore()
  const { data: metricsData, isLoading: metricsLoading, isError: metricsError } = useMetrics()
  const { data: revenueData, isLoading: revenueLoading } = useRevenue()
  const { data: meData } = useMe()

  function handleLogout() {
    logout()
    navigate('/login', { replace: true })
  }

  return (
    <div>
      <ImpersonationBanner />

      <header
        style={{
          background: '#fff',
          borderBottom: '1px solid #e5e7eb',
          padding: '0.75rem 2rem',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}
      >
        <h1 style={{ margin: 0, fontSize: '1rem', fontWeight: 700, color: '#111827' }}>
          GaitWay Analytics
        </h1>
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
          {user && (
            <span style={{ fontSize: '0.875rem', color: '#374151' }}>{user.name}</span>
          )}
          <button
            onClick={handleLogout}
            style={{
              padding: '0.375rem 0.75rem',
              background: 'transparent',
              border: '1px solid #d1d5db',
              borderRadius: '0.375rem',
              fontSize: '0.875rem',
              color: '#374151',
              cursor: 'pointer',
            }}
          >
            Sign out
          </button>
        </div>
      </header>

      <main style={{ padding: '2rem', maxWidth: '1280px', margin: '0 auto' }}>
        <h2 style={{ margin: '0 0 1.5rem', fontSize: '1.5rem', fontWeight: 700, color: '#111827' }}>
          {t('title')}
        </h2>

        {/* Metric cards */}
        <section aria-label="Key metrics" style={{ marginBottom: '2rem' }}>
          {metricsError ? (
            <p style={{ color: '#dc2626' }}>{t('errors.generic', { ns: 'common' })}</p>
          ) : metricsLoading ? (
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
                gap: '1rem',
              }}
            >
              {[...Array(4)].map((_, i) => (
                <div
                  key={i}
                  style={{
                    height: '6rem',
                    borderRadius: '0.75rem',
                    background: '#f3f4f6',
                    animation: 'pulse 1.5s ease-in-out infinite',
                  }}
                />
              ))}
            </div>
          ) : (
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
                gap: '1rem',
              }}
            >
              {metricsData?.items.map((metric: Metric) => (
                <MetricCard key={metric.metricId} {...metric} />
              ))}
            </div>
          )}
        </section>

        {/* Revenue chart */}
        <section
          aria-label={t('charts.revenueOverTime')}
          style={{
            background: '#fff',
            border: '1px solid #e5e7eb',
            borderRadius: '0.75rem',
            padding: '1.25rem 1.5rem',
          }}
        >
          <h2 style={{ margin: '0 0 1rem', fontSize: '1rem', fontWeight: 600, color: '#374151' }}>
            {t('charts.revenueOverTime')}
          </h2>
          <RevenueChart data={revenueData?.items} isLoading={revenueLoading} />
        </section>

        {/* Token debug panel */}
        {meData && (
          <section
            style={{
              marginTop: '1.5rem',
              background: '#111827',
              borderRadius: '0.75rem',
              padding: '1rem 1.25rem',
            }}
          >
            <p
              style={{
                margin: '0 0 0.5rem',
                fontSize: '0.75rem',
                fontWeight: 600,
                color: '#9ca3af',
                textTransform: 'uppercase',
                letterSpacing: '0.05em',
              }}
            >
              Active JWT payload (GET /api/auth/me)
            </p>
            <pre
              style={{
                margin: 0,
                fontSize: '0.8125rem',
                color: '#d1fae5',
                whiteSpace: 'pre-wrap',
                wordBreak: 'break-all',
              }}
            >
              {JSON.stringify(
                {
                  ...meData,
                  iat: new Date(meData.iat * 1000).toISOString(),
                  exp: new Date(meData.exp * 1000).toISOString(),
                },
                null,
                2,
              )}
            </pre>
          </section>
        )}
      </main>
    </div>
  )
}
