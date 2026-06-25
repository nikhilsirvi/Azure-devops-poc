import { describe, it, expect } from 'vitest'
import { formatNumber, formatCurrency, formatPercent } from './format'

describe('formatNumber', () => {
  it('formats large numbers with commas', () => {
    expect(formatNumber(1_000_000)).toBe('1,000,000')
  })

  it('formats small numbers without separators', () => {
    expect(formatNumber(42)).toBe('42')
  })
})

describe('formatCurrency', () => {
  it('formats USD with $ symbol', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56')
  })

  it('formats zero as $0.00', () => {
    expect(formatCurrency(0)).toBe('$0.00')
  })
})

describe('formatPercent', () => {
  it('formats 50 as 50.0%', () => {
    expect(formatPercent(50)).toBe('50.0%')
  })

  it('respects decimals parameter', () => {
    expect(formatPercent(33.333, 2)).toBe('33.33%')
  })
})
