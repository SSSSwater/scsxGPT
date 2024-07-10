import { ChatBox, ChatParamsObj, defaultChatBoxList, ChatStorage } from '../models/chatBox'
import { postGPT } from '../tool/translateAxios';
import { TitleBar } from './TitleBar';


@Extend(Button) function contactButton(){
  .align(Alignment.Start)
  .padding({ left: 20 })
  .fontSize(20)
  .backgroundColor(Color.White)
  .fontColor(Color.Black)
  .width('90%')
  .height('12%')
  .backgroundColor(Color.White)
  .border({radius:10})
  .fontColor(Color.Black)
  .margin({top:10})
}

@Component
export struct ChatDetail {
  @Styles
  iconStyle(){
    .width(20)
    .height(20)
  }

  @Styles
  test(){
    .border({ width: 1 })
    .backgroundColor(Color.Gray)
  }
  @State isShowSideBar: boolean = false;
  @State chatId: number = 0;
  @State input: string = "";
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @State chatIdList: number[] = [];
  @State chatBoxList: ChatBox[] = defaultChatBoxList;
  // 聊天本地数据存储
  @State chatStorage: ChatStorage[] = [];

  @Builder
  chatBoxBuilder(role: number, content: string) {
    Text(content)
      .fontSize(18)
      .width('60%')
      .borderRadius(20)
      .backgroundColor(Color.White)
      .margin({ top: 10 })
      .alignSelf(role == 0 ? ItemAlign.End : ItemAlign.Start)
      .backgroundColor(role == 0 ? "#3177e2" : Color.White)
      .fontColor(role == 0 ? Color.White : Color.Black)
      .padding({
        left: 10,
        right: 10,
        top: 15,
        bottom: 15
      })
  }

  //侧边栏聊天页切换列表
  @Builder
  chatListBuilder(msg: string, num: number, id: number) {
    Button({ type: ButtonType.Normal }) {
      Column() {
        Text(msg)
          .fontSize(22)
          .height('30%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text("记录数：" + num)
          .fontSize(20)
          .fontColor(Color.Gray)
          .fontStyle(FontStyle.Italic)
          .height('70%')
          .margin({top:10})
      }
      .padding(15)
      .height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .onClick(() => {
        this.chatId = id
        this.chatBoxList = this.dataLoad(id)
        this.isShowSideBar = false
      })
    }
    .width('90%')
    .height('20%')
    .backgroundColor(Color.White)
    .border({ width: 2, color: Color.Pink,radius:10})
    .fontColor(Color.Black)
    .margin({top:10})

  }

  build() {

    SideBarContainer(SideBarContainerType.Overlay) {
      //侧边栏
      RelativeContainer() {
        Column() {

          TitleBar({
            titleBarAttribute: {
              title: "聊天列表",
              backShow: false, // 显示菜单
              backCallback: () => { // 设置点击回调
                console.log("shoudao!")
                //返回主页
              }
            }
          })

          Button({ type: ButtonType.Normal }) {
            Row() {
              Image($r("app.media.ic_public_search"))
                .iconStyle()
              Text("搜索")
                .fontSize(20)
                .alignSelf(ItemAlign.Start)
            }
          }
          .onClick(() => {
            //搜索
          })
          .contactButton()

          ForEach(this.chatStorage, (item: ChatStorage) => {

            this.chatListBuilder(item.lastMsg, item.msgNum, item.id)
          })

          Button({ type: ButtonType.Normal }) {
            Row() {
              Image($r("app.media.ic_public_add"))
                .iconStyle()
              Text("创建新聊天")
                .fontSize(20)
                .alignSelf(ItemAlign.Start)
            }
          }
          .onClick(() => {
            this.createChat()
          })
          .contactButton()
        }
        .width("100%")
        .height("60%")

      }
      .backgroundColor('#f0f0ed')

      //主界面
      Column() {

        TitleBar({
          titleBarAttribute: {
            title: "GPT聊天",
            backShow: true, // 显示菜单
            backCallback: () => { // 设置点击回调
              console.log("shoudao!")
              //返回主页
            }
          }
        })
        RelativeContainer() {
          Scroll(this.scroller) { // 绑定滚动控制器
            Column() {
              ForEach(this.chatBoxList, (box: ChatBox) => { // ForEach语法循环创建子组件
                this.chatBoxBuilder(box.role, box.message)
              })
            }
            .width("100%")
          }
          .scrollable(ScrollDirection.Vertical) // 设置竖直方向滚动
          .scrollBarColor(Color.Gray) // 设置滚动条颜色
          .scrollBarWidth(10) // 设置滚动条宽度
          .scrollBar(BarState.On) // 设置滚动条永久显示
          .width('100%')
          .height('85%')
          .padding({
            top: 10,
            bottom: 10,
            left: 10,
            right: 10
          })
          .backgroundColor('#e8e8e4')
          .align(Alignment.Top)


          Stack({alignContent:Alignment.End}) {
            Row(){
              TextArea({ placeholder: "请输入你想说的：", text: this.input })
                .fontSize(22)
                .height('100%')
                .width('80%')
                .fontColor(Color.Black)
                .fontStyle(FontStyle.Italic)
                .backgroundColor(Color.White)
                .placeholderColor(Color.Gray)
                .placeholderFont({
                  size: 18,
                  style: FontStyle.Italic
                })
                .onChange((msg) => {
                  this.input = msg;
                })
                .id('chatInput')

            }
            .backgroundColor(Color.White)
            .border({radius:20})
            .width("90%")
            .height('80%')
            .margin('5%')

              Button({ type: ButtonType.Normal }){
              Image($r('app.media.ic_public_email_send'))
                .width(30)
                .height(30)
              }
                .backgroundColor(Color.White)
                .width("20%")
                .height('70%')
                .margin('7%')
                .border({radius:15})
                .onClick(() => {
                  this.submit(this.input, this.chatId)
                })

          }
          .width("100%")
          .height("15%")
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          })
          // .justifyContent(FlexAlign.SpaceAround)
          // .alignItems(VerticalAlign.Center)
          .id("sendButton")
        }
        .height('90%')
        .width('100%')
      }

    }
    .controlButton({
      top: 20,
      icons: {
        shown:  $r("app.media.ic_public_history"),
        hidden: $r("app.media.ic_public_history"),
        switching: $r("app.media.ic_public_history")
      }
    })
    .sideBarPosition(SideBarPosition.End)
    .showSideBar(this.isShowSideBar)
    .height('100%')
    .width('100%')
    .onChange((value) => {this.isShowSideBar = value})
    .backgroundColor('#e8e8e4')
  }

  async submit(message: string, chatId: number) {

    let tempChatBox = this.dataLoad(chatId)
    //放入发送消息

    tempChatBox.push({ id: "test", message: message, role: 0 })
    this.dataSave(chatId, tempChatBox)
    this.chatBoxList = this.dataLoad(this.chatId)
    this.input = ""

    //放入接接收消息
    const response: ChatBox = await askGPT(message)
    tempChatBox.push(response)
    this.dataSave(chatId, tempChatBox)
    this.chatBoxList = this.dataLoad(this.chatId)

  }

  aboutToAppear(): void {
    this.dataSave(0, defaultChatBoxList)
    this.chatIdList.push(0)
    this.chatBoxList = this.dataLoad(this.chatId)
  }

  //创建一个聊天页
  createChat() {
    const newId: number = getMaxId(this.chatIdList) + 1
    this.chatIdList.push(newId)
    this.dataSave(newId, [{ id: "test", message: '你好请问有什么可以帮助您', role: 1 }] as ChatBox[])
  }

  //chatBox上传到对应AppStorage中
  dataSave(chatId: number, chatBoxList: ChatBox[]) {
    AppStorage.setOrCreate("Chat" + chatId, chatBoxList)
    this.chatStorage[chatId] =
      { msgNum: chatBoxList.length, lastMsg: this.getLatestMsgFromData(chatBoxList), id: chatId }
  }

  //返回AppStorage中的chatBox
  dataLoad(chatId: number): ChatBox[] {
    const res: ChatBox[] = AppStorage.get("Chat" + chatId) || []
    return res
  }

  //从chatBox中获得最新消息
  getLatestMsgFromData(chatBoxList: ChatBox[]) {
    return chatBoxList[chatBoxList.length-1].message
  }
}

//请求GPT
function askGPT(message: string): Promise<ChatBox> {

  const chatParamsObj = createGPTRequest(message)
  const chat: Promise<ChatBox> = postGPT(chatParamsObj, message)
  chat.then((value) => {
    return value
  })
  return chat
}

//包装GPT请求
function createGPTRequest(message: string) {
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

//获取聊天页最高id
function getMaxId(idList: number[]) {
  let maxId: number = -1
  idList.forEach((item: number) => {
    maxId = item > maxId ? item : maxId
  })
  return maxId
}
