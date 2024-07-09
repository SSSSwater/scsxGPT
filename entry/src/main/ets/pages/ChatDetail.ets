import {ChatBox, ChatParamsObj, defaultChatBoxList} from '../models/chatBox'
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
@Entry
@Component
struct ChatDetail {

  @State input: string = "";
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @State chatBoxList: ChatBox[]=defaultChatBoxList;

  @Builder
  chatBoxBuilder(role:number,content:string){
    Text(content)
      .fontSize(18)
      .width('60%')
      .borderRadius(20)
      .backgroundColor(Color.White)
      .margin({top: 10})
      .alignSelf(role==0?ItemAlign.End:ItemAlign.Start)
      .backgroundColor(role==0?"#3177e2":Color.White)
      .fontColor(role==0?Color.White:Color.Black)
      .padding({left:10,right:10,top:15,bottom:15})
  }
  build() {
    RelativeContainer() {

        Scroll(this.scroller) {                  // 绑定滚动控制器
          Column() {
            ForEach(this.chatBoxList, (box:ChatBox) => {      // ForEach语法循环创建子组件
              this.chatBoxBuilder(box.role,box.message)
            })
          }
          .width("100%")
        }
        .scrollable(ScrollDirection.Vertical)    // 设置竖直方向滚动
        .scrollBarColor(Color.Gray)             // 设置滚动条颜色
        .scrollBarWidth(10)                      // 设置滚动条宽度
        .scrollBar(BarState.On)                  // 设置滚动条永久显示
        .width('100%')
        .height('75%')
        .padding({top: 10, bottom: 10, left: 10, right:10})
        .backgroundColor('#e8e8e4')
        .align(Alignment.Top)

      TextArea({ placeholder: "请输入你想说的："})
        .width("100%")
        .height("15%")
        .fontSize(22)
        .fontColor(Color.Black)
        .fontStyle(FontStyle.Italic)
        .placeholderColor(Color.Gray)
        .placeholderFont({
          size: 18,
          style: FontStyle.Italic
        })
        .onChange((msg) => {
          this.input = msg;
        })
        .alignRules({
          bottom: { anchor: 'sendButton', align: VerticalAlign.Top },
        })
        .id('chatInput')


      Row(){
        Button('Send')
          .backgroundColor(Color.Pink)
          .width("90%")
          .onClick(()=>{
            this.submit(this.input)
          })
      }
      .width("100%")
      .height("10%")
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .id("sendButton")
    }
    .height('100%')
    .width('100%')
  }

  async  submit(message:string){
    this.chatBoxList.push({id:"test",message:this.input,role:0})
    const response:ChatBox = await askGPT(message)
    console.log("submit:" + JSON.stringify(response))
    this.chatBoxList.push(response)
    AppStorage.setOrCreate("Chat" + "1" ,this.chatBoxList)
  }

  aboutToAppear(): void {
    this.chatBoxList = AppStorage.get("Chat" + "1") || []
    }

  }

function askGPT(message:string):Promise<ChatBox>{

  const  chatParamsObj = createGPTRequest(message)
  console.log(JSON.stringify(chatParamsObj))
  const chat:Promise<ChatBox> = new Promise((resolve) => {
    axios({
      method:'post',
      url:'https://api.chatanywhere.com.cn/v1/chat/completions',
      headers : {"Content-Type" : "application/json",
        "Authorization": "Bearer sk-vUdoqlqdODGulzVxiJPBShCdHHxRKWI4gjq0zG1TANm3hR70"},
      data: chatParamsObj
    }).then((res: AxiosResponse) => {
      console.log("111")
      let resp = {'id': "1",
        'message': res.data.choices[0].message.content,
        'role': 1} as ChatBox
      resolve(resp)
    }).catch((error: AxiosError) => {
      console.error(JSON.stringify(error));
      resolve({} as ChatBox)
    })
  })
  chat.then((value)=>{
    console.log(JSON.stringify(value))
    return value
  })
  return chat
}

function createGPTRequest(message:string){
  const chatParamsObj: ChatParamsObj = {
    "model": "gpt-3.5-turbo-1106",
    "messages": [
      {
        "role": "user",
        "content": message
      }
    ]
  }
  return chatParamsObj

}
