import { Navigate, Outlet } from 'react-router-dom'
import { useAuthStore, type Role } from '@/store/authStore'

interface ProtectedRouteProps {
  requiredRole?: Role
}

export function ProtectedRoute({ requiredRole }: ProtectedRouteProps) {
  const { token, user } = useAuthStore()

  if (!token) {
    return <Navigate to="/login" replace />
  }

  if (requiredRole && user?.role !== requiredRole) {
    const redirect = user?.role === 'EMPLOYEE' ? '/surgeons' : '/'
    return <Navigate to={redirect} replace />
  }

  return <Outlet />
}
