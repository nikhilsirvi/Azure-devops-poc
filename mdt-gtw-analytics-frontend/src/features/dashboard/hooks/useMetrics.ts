import { useQuery } from '@tanstack/react-query'
import { analyticsApi } from '../api/analyticsApi'

export function useMetrics() {
  return useQuery({
    queryKey: ['analytics', 'metrics'],
    queryFn: analyticsApi.getMetrics,
  })
}
