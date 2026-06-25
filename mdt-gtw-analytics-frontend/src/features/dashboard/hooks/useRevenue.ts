import { useQuery } from '@tanstack/react-query'
import { analyticsApi } from '../api/analyticsApi'

export function useRevenue() {
  return useQuery({
    queryKey: ['analytics', 'revenue'],
    queryFn: analyticsApi.getRevenue,
  })
}
