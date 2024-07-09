export interface ChatBox {
  id: string
  message: string
  role: number //0表示自己说的,1表示gpt说的
}

export const defaultChatBoxList: ChatBox[] = [
  {
    "id": "aaa",
    "message": "你好",
    "role": 0
  },
  {
    "id": "bbb",
    "message": "我是gpt",
    "role": 1
  }]