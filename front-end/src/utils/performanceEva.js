import { http } from '../config/http'
import {
} from '../config/interface'
import store from '@/store'

// 计算成效评价分数
export function calPerformanceEvaScore (t1Star, t2Star, t3Star, t4Star, t5Star, t6Star) {
  return t1Star * 0.15 + t2Star * 0.2 + t3Star * 0.1 + t4Star * 0.1 + t5Star * 0.3 + t6Star * 0.15
}
