export interface TransBox {
  origin: string
  translation: string
  mode: string
}
export interface TransParamsObj {
  source: string,
  trans_type: string,
  request_id: string,
  detect: boolean
}
export const defaultTransBoxList: TransBox[] = [
  {
    "origin": "hello",
    "translation": "你好",
    mode: "en2zh"
  }]