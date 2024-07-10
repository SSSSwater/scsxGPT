export interface ChatBox {
  id: number
  message: string
  role: number //0表示自己说的,1表示gpt说的
}

export interface ChatStorage {
  id : number,
  msgNum: number,
  lastMsg: string
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
    "id": 0,
    "message": "你好",
    "role": 0
  },
  {
    "id": 0,
    "message": "我是gpt",
    "role": 1
  }]