export interface ChatBox {
  id: string
  message: string
  role: number //0表示自己说的,1表示gpt说的
}
export interface ChatBoxStorage {
  id: number
  chatList: ChatBox[]
}


export interface MessageModel {
  role: string,
  content: string
}
export interface ChatParamsObj {
  model: string,
  messages: MessageModel[]
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