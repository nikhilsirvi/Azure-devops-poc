import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export type Role = 'EMPLOYEE' | 'SURGEON'

export interface AuthUser {
  userId: string
  email: string
  name: string
  role: Role
  originalRole?: 'EMPLOYEE'
  impersonatingSurgeonId?: string
  impersonatingSurgeonName?: string
}

interface AuthState {
  token: string | null
  originalToken: string | null
  user: AuthUser | null
  originalUser: AuthUser | null
  setAuth: (token: string, user: AuthUser) => void
  setImpersonation: (token: string, user: AuthUser) => void
  stopImpersonating: () => void
  logout: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      token: null,
      originalToken: null,
      user: null,
      originalUser: null,
      setAuth: (token, user) =>
        set({ token, user, originalToken: null, originalUser: null }),
      setImpersonation: (token, user) =>
        set((state) => ({
          token,
          user,
          originalToken: state.token,
          originalUser: state.user,
        })),
      stopImpersonating: () => {
        const { originalToken, originalUser } = get()
        if (!originalToken || !originalUser) return
        set({ token: originalToken, user: originalUser, originalToken: null, originalUser: null })
      },
      logout: () =>
        set({ token: null, originalToken: null, user: null, originalUser: null }),
    }),
    { name: 'auth' },
  ),
)
