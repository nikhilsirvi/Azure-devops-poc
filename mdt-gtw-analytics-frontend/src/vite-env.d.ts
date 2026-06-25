/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string
  readonly VITE_API_PROXY_TARGET: string
  readonly VITE_AUTH_DOMAIN: string
  readonly VITE_AUTH_CLIENT_ID: string
  readonly VITE_FEATURE_DARK_MODE: string
  readonly VITE_FEATURE_ANALYTICS: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
