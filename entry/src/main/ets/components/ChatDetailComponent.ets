import {ChatBox, ChatParamsObj, defaultChatBoxList,ChatBoxStorage} from '../models/chatBox'
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { postGPT } from '../tool/translateAxios';
import { HashMap } from '@kit.ArkTS';


@Entry
@Component
export struct ChatDetail {
  @Styles
  iconStyle(){
    .width(20)
    .height(20)
  }

  @State chatId: number = 1;
  @State input: string = "";
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @State chatBoxList: ChatBox[]=defaultChatBoxList;
  @State chatBoxStorage: HashMap<number,ChatBox[]>=AppStorage.get("Chat") || new HashMap<number,ChatBox[]>();
  @State chatBoxArray: ChatBoxStorage[] = mapToArray(this.chatBoxStorage)


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

  @Builder
  chatListBuilder(id:string){

  }
  build() {

    SideBarContainer(SideBarContainerType.Overlay) {
      RelativeContainer() { //侧边栏
        Column(){

          Button({type: ButtonType.Normal}){
            Row(){
              Image($rawfile("ic_public_add.svg"))
                .iconStyle()
              Text("创建新聊天")
                .fontSize(20)
                .alignSelf(ItemAlign.Start)
            }.width('50%')
            .onClick(()=>{

            })
          }
          .fontSize(20)
          .backgroundColor(Color.White)
          .fontColor(Color.Black)
          .width('100%')
          .height('12%')

          Button({type: ButtonType.Normal}){
            Column(){
              Text("记录数：1")
                .fontSize(22)
                .height('30%')
              Text("sdsdsdsdsdsdsdssdsds")
                .fontSize(20)
                .fontColor(Color.Gray)
                .fontStyle(FontStyle.Italic)
                .textOverflow({overflow:TextOverflow.Ellipsis})
                .maxLines(1)
                .height('70%')
            }.padding(15)
            .height('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .height('20%')
          .backgroundColor(Color.White)
          .border({width:{top:1,bottom:1},color:Color.Gray,radius:0})
          .fontColor(Color.Black)

          ForEach(this.chatBoxArray, (item:ChatBoxStorage)=>{
            Button({type: ButtonType.Normal}){
              Column(){
                Text("记录数：" +item.chatList.length.toString())
                  .fontSize(22)
                  .height('30%')
                Text(item.chatList[item.chatList.length-1].message)
                  .fontSize(20)
                  .fontColor(Color.Gray)
                  .fontStyle(FontStyle.Italic)
              }.padding(15)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .height('30%')
            .backgroundColor(Color.White)
            .border({width:{top:1,bottom:1},color:Color.Gray,radius:0})
            .fontColor(Color.Black)
          })
        }
        .width("100%")
        .height("60%")
        .margin({top:'50%'})

        // ForEach(AppStorage.keys(), (box:ChatBox) => {      // ForEach语法循环创建子组件
        //   this.chatBoxBuilder(box.role,box.message)
        // })

      }
      .backgroundColor(Color.White)

      RelativeContainer() { //主界面
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
    .showSideBar(false)
    .height('100%')
    .width('100%')
  }

  async submit(message:string){
    console.log(message)
    this.chatBoxList.push({id:"test",message:message,role:0})
    this.chatBoxStorage.set(this.chatId, this.chatBoxList)
    AppStorage.setOrCreate("Chat" ,this.chatBoxStorage)
    const response:ChatBox = await askGPT(message)
    this.chatBoxList.push(response)
    AppStorage.setOrCreate("Chat" ,this.chatBoxStorage)
    // const chat:HashMap<number,ChatBox[]> = AppStorage.get("Chat") || new HashMap()
    // console.log(chat.get(this.chatId)[1].message)
    this.chatBoxStorage.set(this.chatId, this.chatBoxList)
    this.chatBoxArray = mapToArray(this.chatBoxStorage)
    console.log(this.chatBoxStorage.get(1).length.toString())
  }

  aboutToAppear(): void {
    // AppStorage.setOrCreate("Chat" ,this.chatBoxStorage)
    // this.chatBoxStorage = AppStorage.get("Chat") || new HashMap()
    // this.chatBoxList = this.chatBoxStorage.get(this.chatId)
  }

}

function askGPT(message:string):Promise<ChatBox>{

  const  chatParamsObj = createGPTRequest(message)
  const chat:Promise<ChatBox> =postGPT(chatParamsObj,message)
  chat.then((value)=>{
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

function mapToArray(chatBoxStorage:HashMap<number,ChatBox[]>){
  let chatList:ChatBoxStorage[] = []
  chatBoxStorage.forEach((v,k)=>{
    const item:ChatBoxStorage = {"id":k, "chatList":v} as ChatBoxStorage

    console.log(item.id.toString() + item.chatList.length.toString())
    chatList.push({"id":k, "chatList":v} as ChatBoxStorage)
  })
  return chatList
}