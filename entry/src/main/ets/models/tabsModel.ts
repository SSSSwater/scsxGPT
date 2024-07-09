export interface TabsModel {
  title: string
  icon: string
  activeIcon: string
}

export const tabsModel: TabsModel[] = [
  {
    title: '聊天',
    icon: 'chat.png',
    activeIcon: 'chat-active.png'
  },
  {
    title: '翻译',
    icon: 'translate.png',
    activeIcon: 'translate-active.png'
  },
  {
    title: '我的',
    icon: 'myself.png',
    activeIcon: 'myself-active.png'
  }
]