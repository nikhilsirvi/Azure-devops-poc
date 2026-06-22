import { useNavigate } from 'react-router-dom'
import { useAuthStore } from '@/store/authStore'

export function ImpersonationBanner() {
  const navigate = useNavigate()
  const { user, originalUser, stopImpersonating } = useAuthStore()

  if (!user?.originalRole) return null

  function handleStop() {
    stopImpersonating()
    navigate('/surgeons', { replace: true })
  }

  return (
    <div style={styles.banner}>
      <span style={styles.text}>
        Viewing dashboard as <strong>{user.impersonatingSurgeonName}</strong>
        {originalUser && <> &mdash; logged in as {originalUser.name}</>}
      </span>
      <button onClick={handleStop} style={styles.btn}>
        Exit &amp; return to Surgeons
      </button>
    </div>
  )
}

const styles: Record<string, React.CSSProperties> = {
  banner: {
    background: '#fef3c7',
    borderBottom: '1px solid #fcd34d',
    padding: '0.5rem 2rem',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: '1rem',
    flexWrap: 'wrap',
  },
  text: {
    fontSize: '0.875rem',
    color: '#92400e',
  },
  btn: {
    padding: '0.25rem 0.75rem',
    background: '#fff',
    border: '1px solid #fcd34d',
    borderRadius: '0.375rem',
    fontSize: '0.8125rem',
    fontWeight: 600,
    color: '#92400e',
    cursor: 'pointer',
    whiteSpace: 'nowrap',
  },
}
