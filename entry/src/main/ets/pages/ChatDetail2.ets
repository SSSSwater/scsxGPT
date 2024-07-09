import {ChatBox,defaultBoxList} from '../models/chatBox'
import { Chat, ChatRole, ChatMessage } from '@changwei/chatui'

@Entry
@Component
struct ChatDetail2 {
  @State message: string = "";
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  private scrollDistance: number = 0;
  @State chatBoxList: ChatBox[] = defaultBoxList;
  private items: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    RelativeContainer() {
      Row() {
        Column() {
          Chat({
            title: '聊天',
            welcomeMessage: '你好，有什么问题可以问我喵',
            needBackButton: true,
            userMessageBackgroundColor: "#365dfb",
            userMessageTextColor:Color.White,
            messageFontSize: 16,
            onSendMessage: (ctl, message) => {
              //发送用户消息
              ctl.postMessage(message)
              //显示回复等待动画
              ctl.setTyping(true)
              //3秒后发送chatbot响应消息
              setTimeout(() => {
                ctl.postMessage(new ChatMessage({
                  role: ChatRole.Assistant,
                  content: '这是一条测试回复'
                }))
                // 图片消息
                ctl.postMessage(new ChatMessage({
                  role: ChatRole.Assistant,
                  picurl: "https://foruda.gitee.com/avatar/1709712450038093632/8548349_changweizhang_1709712449.png"
                }));
              }, 3000)
            }
          })
        }
      }
      .height('100%')
    }
  }
}