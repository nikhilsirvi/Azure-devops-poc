import { apiClient } from '@/lib/axiosClient'

export interface Surgeon {
  userId: string
  name: string
  speciality?: string
}

export const surgeonsApi = {
  getSurgeons: (): Promise<{ items: Surgeon[] }> =>
    apiClient.get<{ items: Surgeon[] }>('/users/surgeons').then((r) => r.data),
}
