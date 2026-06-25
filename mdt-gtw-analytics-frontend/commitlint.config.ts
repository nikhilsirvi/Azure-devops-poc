import type { UserConfig } from '@commitlint/types'

const config: UserConfig = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation only
        'style',    // Formatting, no logic change
        'refactor', // Neither fix nor feature
        'test',     // Adding/updating tests
        'chore',    // Build process, tooling, dependencies
        'perf',     // Performance improvement
        'ci',       // CI/CD changes
        'build',    // Build system changes
        'revert',   // Revert a prior commit
      ],
    ],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-max-length': [2, 'always', 100],
    'subject-empty': [2, 'never'],
    'body-max-line-length': [2, 'always', 200],
    'scope-case': [2, 'always', 'lower-case'],
  },
}

export default config
