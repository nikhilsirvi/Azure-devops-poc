import { useQuery } from '@tanstack/react-query'
import { apiClient } from '@/lib/axiosClient'
import { useAuthStore } from '@/store/authStore'

interface MeResponse {
  sub: string
  email: string
  name: string
  role: string
  originalRole?: string
  impersonatingSurgeonId?: string
  impersonatingSurgeonName?: string
  iat: number
  exp: number
}

export function useMe() {
  const token = useAuthStore((s) => s.token)
  return useQuery({
    queryKey: ['me', token],
    queryFn: () => apiClient.get<MeResponse>('/auth/me').then((r) => r.data),
    enabled: !!token,
  })
}
