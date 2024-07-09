export interface TransRequest {
  origin: string
  mode: number
}

export const defaultTransBoxList: TransRequest[] = [
  {
    "origin": "hello",
    "mode": 0
  }]