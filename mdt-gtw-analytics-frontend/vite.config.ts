import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
import { readFileSync } from 'fs'

const pkg = JSON.parse(readFileSync('./package.json', 'utf-8'))

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const apiProxyTarget = env.VITE_API_PROXY_TARGET || 'http://localhost:8080'

  return {
    plugins: [react()],
    server: {
      port: 3000,
      proxy: {
        // All /api requests are forwarded to the backend — avoids CORS in local dev
        '/api': {
          target: apiProxyTarget,
          changeOrigin: true,
          secure: false,
          configure: (proxy) => {
            proxy.on('proxyReq', (proxyReq, req) => {
              console.log(`[proxy] ${req.method} ${req.url} → ${apiProxyTarget}${proxyReq.path}`)
            })
            proxy.on('proxyRes', (proxyRes, req) => {
              console.log(`[proxy] ${proxyRes.statusCode} ← ${req.method} ${req.url}`)
            })
            proxy.on('error', (err, req) => {
              console.error(`[proxy] error on ${req.method} ${req.url}:`, err.message)
            })
          },
        },
      },
    },
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
    define: {
      __APP_VERSION__: JSON.stringify(pkg.version),
      __BUILD_TIME__: JSON.stringify(new Date().toISOString()),
    },
    build: {
      rollupOptions: {
        output: {
          manualChunks: (id) => {
            if (!id.includes('node_modules')) return

            if (id.includes('react') || id.includes('react-dom')) return 'vendor-react'
            if (id.includes('recharts') || id.includes('d3-')) return 'vendor-charts'
            if (id.includes('@tanstack')) return 'vendor-query'
            if (id.includes('i18next') || id.includes('react-i18next')) return 'vendor-i18n'
            if (id.includes('react-router')) return 'vendor-router'
            return 'vendor'
          },
        },
      },
      chunkSizeWarningLimit: 1000,
    },
  }
})
