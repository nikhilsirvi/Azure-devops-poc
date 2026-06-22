import { apiClient } from '@/lib/axiosClient'

export interface Metric {
  metricId: string
  value: number
  trend: number
  trendDirection: 'up' | 'down'
}

export interface RevenuePoint {
  period: string
  month: string
  revenue: number
  orders: number
  customers: number
}

export interface MetricsResponse {
  items: Metric[]
}

export interface RevenueResponse {
  items: RevenuePoint[]
}

export const analyticsApi = {
  getMetrics: () =>
    apiClient.get<MetricsResponse>('/analytics/metrics').then((r) => r.data),

  getRevenue: () =>
    apiClient.get<RevenueResponse>('/analytics/revenue').then((r) => r.data),
}
