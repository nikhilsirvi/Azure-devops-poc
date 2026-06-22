import { useQuery } from '@tanstack/react-query'
import { surgeonsApi } from '../api/surgeonsApi'

export function useSurgeons() {
  return useQuery({
    queryKey: ['surgeons'],
    queryFn: () => surgeonsApi.getSurgeons(),
  })
}
