import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'

export function NotFoundPage() {
  const { t } = useTranslation('common')

  return (
    <main style={{ padding: '2rem', textAlign: 'center' }}>
      <h1>{t('errors.notFound')}</h1>
      <p>{t('errors.notFoundMessage')}</p>
      <Link to="/">{t('actions.goHome')}</Link>
    </main>
  )
}
