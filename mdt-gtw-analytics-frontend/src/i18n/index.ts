import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'
import LanguageDetector from 'i18next-browser-languagedetector'

import enCommon from './locales/en/common.json'
import enDashboard from './locales/en/dashboard.json'
import esCommon from './locales/es/common.json'
import esDashboard from './locales/es/dashboard.json'
import frCommon from './locales/fr/common.json'
import frDashboard from './locales/fr/dashboard.json'

export const defaultNS = 'common'

export const resources = {
  en: { common: enCommon, dashboard: enDashboard },
  es: { common: esCommon, dashboard: esDashboard },
  fr: { common: frCommon, dashboard: frDashboard },
} as const

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources,
    defaultNS,
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false, // React already escapes values
    },
    detection: {
      order: ['querystring', 'localStorage', 'navigator'],
      lookupQuerystring: 'lang',
      lookupLocalStorage: 'i18nextLng',
      caches: ['localStorage'],
    },
  })

export default i18n
