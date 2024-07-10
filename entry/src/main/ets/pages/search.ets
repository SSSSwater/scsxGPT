import { router } from '@kit.ArkUI'
import { it } from '@ohos/hypium';
import { ChatBox, ChatStorage } from '../models/chatBox'
import { map } from '@kit.MapKit';

@Entry
export struct search {
  @State chatIdList: number[] = []
  @State chatStorage: ChatStorage[] = [];
  @State lenth: number = 0
  @State chatBoxAll: ChatBox[] = [];
  @State idlenth: number[] = []
  @State massage: string[] = []
  controller: SearchController = new SearchController()
  private scroller: Scroller = new Scroller()

  @Builder
  chatListBuilder(msg: string, id: number, role:number) {
    Button({ type: ButtonType.Normal }) {
      RelativeContainer() {
        Image(role==0?$r('app.media.ic_public_contacts'):$r('app.media.ic_public_gpt'))
          .size({width:30,height:30})
          .alignRules({left:{anchor:'__container__',align:HorizontalAlign.Start},top:{anchor:'__container__',align:VerticalAlign.Top}})
          .id('avatar')
        Text(msg)
          .width("80%")
          .fontSize(15)
          .fontStyle(FontStyle.Italic)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .alignRules({left:{anchor:'avatar',align:HorizontalAlign.End},center:{anchor:'__container__',align:VerticalAlign.Center}})
        Text("来自于第"+id.toString()+"页")
          .fontSize(10)//500字日记 今天是一个
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .alignRules({right:{anchor:'__container__',align:HorizontalAlign.End}
                      ,bottom:{anchor:'__container__',align:VerticalAlign.Bottom}})
          .fontColor(Color.Gray)
      }
      .width('90%')
      .height(60)

    }
    .width('100%')
    .backgroundColor(Color.White)
    .border({ width:{bottom:2}, color:"#f0f0ed"})
    .fontColor(Color.Black)
    .margin({ top: 10 })
    .onClick(()=>{
      router.back()
    })

  }

  build() {
    // Scroll(){
    RelativeContainer(){
        Row() {
          Column() {
            Image($rawfile('back.png')).width(30)
          }
          .width(44).height(44).justifyContent(FlexAlign.Center)
          .onClick(() => {
            router.back()
          })

          Search({ placeholder: '请输入想搜索的记录', controller: this.controller })
            .searchButton('搜索', { fontColor: Color.Black })
            .height(40)
            .layoutWeight(1)//.backgroundColor('#F5F5F5')
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: 14, weight: 400 })
            .textFont({ size: 14, weight: 400 })
            .onSubmit((value: string) => {
              const chatIdList: number[] = AppStorage.get("ChatList") || []
              console.log(chatIdList.toString())
              this.lenth = chatIdList.length
              chatIdList.forEach((item) => {
                const chatBoxTemp = this.dataLoad(item)
                  chatBoxTemp.forEach(
                    (chatBox:ChatBox)=>{if (chatBox.message.search(value) != -1)
                    this.chatBoxAll.push(chatBox)
                  })

              })
            })
        }
        .width('100%')
        .padding({ right: 10 })

      Scroll(this.scroller){
        Column() {
          ForEach(this.chatBoxAll, (item: ChatBox) => {
            this.chatListBuilder(item.message,item.id,item.role)
          })
        }


      }
      .scrollable(ScrollDirection.Vertical) // 设置竖直方向滚动
      .scrollBarColor(Color.Gray) // 设置滚动条颜色
      .scrollBarWidth(10) // 设置滚动条宽度
      .scrollBar(BarState.On) // 设置滚动条永久显示
      .align(Alignment.Top)
      .height('94%')
      .alignRules({bottom:{anchor:'__container__',align:VerticalAlign.Bottom}})
    }

    // .backgroundColor('#ee7700')
  }

  // }
  dataLoad(chatId: number): ChatBox[] {
    const res: ChatBox[] = AppStorage.get("Chat" + chatId) || []
    return res
  }
}