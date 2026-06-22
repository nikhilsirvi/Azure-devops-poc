import { useTranslation } from 'react-i18next'
import { formatCurrency, formatNumber, formatPercent } from '@/utils/format'
import type { Metric } from '../api/analyticsApi'

const CURRENCY_METRICS = new Set(['totalRevenue', 'avgOrderValue'])
const PERCENT_METRICS = new Set(['conversionRate'])

function formatValue(metricId: string, value: number): string {
  if (CURRENCY_METRICS.has(metricId)) return formatCurrency(value)
  if (PERCENT_METRICS.has(metricId)) return formatPercent(value / 100)
  return formatNumber(value)
}

export function MetricCard({ metricId, value, trend, trendDirection }: Metric) {
  const { t } = useTranslation('dashboard')
  const isUp = trendDirection === 'up'

  return (
    <article
      style={{
        background: '#fff',
        border: '1px solid #e5e7eb',
        borderRadius: '0.75rem',
        padding: '1.25rem 1.5rem',
        display: 'flex',
        flexDirection: 'column',
        gap: '0.5rem',
      }}
    >
      <p style={{ margin: 0, fontSize: '0.875rem', color: '#6b7280', fontWeight: 500 }}>
        {t(`metrics.${metricId}`)}
      </p>
      <p style={{ margin: 0, fontSize: '1.75rem', fontWeight: 700, color: '#111827' }}>
        {formatValue(metricId, value)}
      </p>
      <p
        style={{
          margin: 0,
          fontSize: '0.8125rem',
          fontWeight: 500,
          color: isUp ? '#16a34a' : '#dc2626',
        }}
      >
        {isUp ? '↑' : '↓'} {Math.abs(trend)}%
      </p>
    </article>
  )
}
