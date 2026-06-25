# Naming Conventions

Consistent naming reduces cognitive load and makes code searchable. These rules apply to all TypeScript/React code in this project.

---

## Files and Directories

| Type | Convention | Example |
|------|-----------|---------|
| React component file | PascalCase | `UserCard.tsx` |
| Component directory | PascalCase | `UserCard/` |
| Hook file | camelCase, `use` prefix | `useWindowSize.ts` |
| Utility / helper file | camelCase | `formatDate.ts` |
| Service / API file | camelCase, `Service` or `Client` suffix | `userService.ts`, `axiosClient.ts` |
| Store file | camelCase, `Store` suffix | `uiStore.ts` |
| Type declaration file | camelCase | `apiTypes.ts` |
| Test file | mirrors source file + `.test` | `formatDate.test.ts`, `UserCard.test.tsx` |
| i18n namespace file | camelCase JSON | `dashboard.json` |
| Config file | kebab-case | `vite.config.ts`, `eslint.config.js` |

### Directory structure

```
src/
├── assets/                 # Static files (images, fonts, svgs)
├── components/             # Pure, reusable UI components (no business logic)
│   └── Button/
│       ├── Button.tsx
│       ├── Button.test.tsx
│       └── index.ts        # Re-export: export { Button } from './Button'
├── features/               # Self-contained feature modules
│   └── dashboard/
│       ├── components/     # Feature-specific components
│       ├── hooks/          # Feature-specific hooks
│       ├── services/       # Feature-specific API calls
│       └── index.ts        # Public API of the feature
├── hooks/                  # App-wide custom hooks
├── i18n/                   # i18next setup + locale JSON files
├── layouts/                # Page layout shells (Sidebar, Topbar, etc.)
├── lib/                    # Third-party client configurations (axios, react-query)
├── pages/                  # Route-level page components
├── router/                 # Route definitions
├── services/               # App-wide API services
├── store/                  # Zustand stores
├── types/                  # Shared TypeScript types and global declarations
└── utils/                  # Pure utility functions
```

---

## Variables and Functions

| Type | Convention | Example |
|------|-----------|---------|
| Local variable | camelCase | `const userName = 'alice'` |
| Boolean variable | camelCase, `is`/`has`/`can` prefix | `isLoading`, `hasError`, `canEdit` |
| Function | camelCase | `function fetchUser()` |
| React component | PascalCase | `function UserCard()` |
| Custom hook | camelCase, `use` prefix | `function useAuth()` |
| Event handler | camelCase, `handle` prefix | `handleSubmit`, `handleChange` |
| Async function | camelCase, verb-noun | `fetchUsers`, `createOrder`, `deleteRecord` |

```typescript
// Variables
const isLoading = true
const hasPermission = false
const userCount = 42

// Event handlers (not "on" — that's for prop names)
function handleFormSubmit(event: React.FormEvent) { ... }
function handleRowClick(id: string) { ... }

// Async services
async function fetchDashboardMetrics(dateRange: DateRange) { ... }
```

---

## Constants

```typescript
// Module-level constants: UPPER_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3
const DEFAULT_PAGE_SIZE = 25
const API_TIMEOUT_MS = 30_000

// Enum-like objects: UPPER_SNAKE_CASE keys
const CHART_COLORS = {
  PRIMARY: '#6366f1',
  SUCCESS: '#22c55e',
  DANGER: '#ef4444',
} as const

// Enum declarations: PascalCase name, PascalCase members
enum UserRole {
  Admin = 'ADMIN',
  Editor = 'EDITOR',
  Viewer = 'VIEWER',
}
```

---

## TypeScript Types and Interfaces

- Use **PascalCase** for both `type` and `interface`.
- **No `I` prefix** for interfaces (avoid `IUser` — use `User`).
- Prefer `interface` for object shapes that may be extended; use `type` for unions, intersections, and aliases.
- Suffix with the domain concept, not "Interface" or "Type".

```typescript
// Interfaces — object shapes
interface User {
  id: string
  name: string
  role: UserRole
}

// Types — unions, computed shapes
type ChartVariant = 'line' | 'bar' | 'pie' | 'area'
type ApiResponse<T> = { data: T; status: number; message: string }

// Props — suffix with "Props"
interface UserCardProps {
  user: User
  onSelect: (id: string) => void
}

// API payloads — suffix describes direction
interface CreateUserRequest { ... }
interface CreateUserResponse { ... }
```

---

## React Components

```tsx
// Named export (preferred over default for most components)
export function MetricCard({ title, value, trend }: MetricCardProps) {
  return (...)
}

// Default export only for page-level components and App.tsx
export default function DashboardPage() {
  return (...)
}

// Re-export from index.ts for clean imports
// features/dashboard/index.ts
export { RevenueChart } from './components/RevenueChart'
export { useDashboardMetrics } from './hooks/useDashboardMetrics'
```

---

## CSS / Styling

If using CSS Modules:
- File: `ComponentName.module.css`
- Class names: camelCase (`userCard`, `headerTitle`)

If using a utility-first framework (Tailwind):
- No custom naming required; apply classes directly.
- Extract repeated class groups to components, not CSS.

---

## i18n Keys

Use dot-notation namespacing. Keys are lowercase with camelCase nesting.

```json
{
  "dashboard": {
    "title": "Dashboard",
    "metrics": {
      "totalRevenue": "Total Revenue"
    }
  }
}
```

Usage in code:
```tsx
const { t } = useTranslation('dashboard')
t('metrics.totalRevenue')  // ✅
t('Dashboard.Metrics.TotalRevenue')  // ❌ wrong case
```

---

## Git Branches

See [GIT_WORKFLOW.md](./GIT_WORKFLOW.md) for full branching strategy.

| Branch type | Pattern | Example |
|-------------|---------|---------|
| Feature | `feature/<ticket>-short-description` | `feature/DASH-42-revenue-chart` |
| Bug fix | `fix/<ticket>-short-description` | `fix/DASH-99-tooltip-overflow` |
| Hotfix | `hotfix/<ticket>-short-description` | `hotfix/DASH-100-crash-on-load` |
| Release | `release/<version>` | `release/1.4.0` |
| Chore | `chore/<description>` | `chore/upgrade-dependencies` |

---

## Commit Messages

Format: `<type>(<scope>): <subject>`

```
feat(dashboard): add monthly revenue line chart
fix(auth): resolve token refresh race condition
docs(readme): add pnpm install instructions
chore(deps): upgrade react-query to v5
test(format): add edge cases for formatCurrency
```

Rules enforced by commitlint:
- Type must be one of: `feat fix docs style refactor test chore perf ci build revert`
- Subject must be lowercase
- Subject max 100 characters
- No period at end of subject
