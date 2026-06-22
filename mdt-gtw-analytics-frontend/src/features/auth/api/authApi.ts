import { apiClient } from '@/lib/axiosClient'
import type { AuthUser } from '@/store/authStore'

export interface LoginRequest {
  email: string
  password: string
}

export interface AuthResponse {
  accessToken: string
  user: AuthUser
}

export const authApi = {
  login: (data: LoginRequest): Promise<AuthResponse> =>
    apiClient.post<AuthResponse>('/auth/login', data).then((r) => r.data),

  impersonate: (surgeonId: string): Promise<AuthResponse> =>
    apiClient.post<AuthResponse>('/auth/impersonate', { surgeonId }).then((r) => r.data),
}
