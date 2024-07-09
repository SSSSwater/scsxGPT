export interface TransBox {
  origin: string
  translation: string
  mode: number
}
export interface MessageModel {
  role: string,
  content: string
}
export interface TransParamsObj {
  source: string,
  "trans_type": string,
  "request_id": string,
  "detect": boolean
}
export interface ParamsObj {
  model: string,
  messages: MessageModel[]
}
export const defaultTransBoxList: TransBox[] = [
  {
    "origin": "hello",
    "translation": "你好",
    mode: 0
  }]