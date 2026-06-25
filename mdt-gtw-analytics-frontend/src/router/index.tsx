import { Routes, Route, Navigate } from 'react-router-dom'
import { DashboardPage } from '../pages/Dashboard'
import { NotFoundPage } from '../pages/NotFound'
import { LoginPage } from '../pages/Login'
import { SurgeonsPage } from '../pages/Surgeons'
import { ProtectedRoute } from '../components/ProtectedRoute'

export function AppRouter() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />

      {/* Surgeon-only routes */}
      <Route element={<ProtectedRoute requiredRole="SURGEON" />}>
        <Route path="/" element={<DashboardPage />} />
      </Route>

      {/* Employee-only routes */}
      <Route element={<ProtectedRoute requiredRole="EMPLOYEE" />}>
        <Route path="/surgeons" element={<SurgeonsPage />} />
      </Route>

      {/* Any authenticated route catches unauthenticated users */}
      <Route element={<ProtectedRoute />}>
        <Route path="*" element={<NotFoundPage />} />
      </Route>

      {/* Root redirect for unauthenticated goes through ProtectedRoute */}
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  )
}
