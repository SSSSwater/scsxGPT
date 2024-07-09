import { TransBox, defaultTransBoxList, TransParamsObj} from '../models/transBox'
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { postTranslate } from '../tool/tanslateaxios';

@Entry
@Component
struct Translator {
  @State input: string = "";
  @State transMode: number = 0; // 0表示英译中，1表示中译英
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @State transBoxList: TransBox[] = defaultTransBoxList;

  @Builder
  transBoxBuilder(role:number,origin:string,translation:string){
    Text(){
      Span("原文:\n")
        .fontSize(20)
        .fontColor(Color.Gray)
        .fontStyle(FontStyle.Italic)
      Span(origin)
        .fontSize(18)
        .fontColor(Color.Gray)
        .fontStyle(FontStyle.Italic)
      Span("\n释义:\n")
        .fontSize(20)
        .fontColor(Color.Black)
        .fontStyle(FontStyle.Italic)
      Span(translation)
        .fontSize(18)
        .fontColor(Color.Black)
        .fontStyle(FontStyle.Italic)
    }
      .fontSize(18)
      .width('95%')
      .borderRadius(20)
      .backgroundColor(Color.White)
      .margin({ top: 10 })
      .alignSelf(ItemAlign.Center)
      .backgroundColor(Color.White)
      .fontColor(Color.Black)
      .padding({
        left: 10,
        right: 10,
        top: 15,
        bottom: 15
      })
  }
  build() {
    RelativeContainer() {

      Scroll(this.scroller) { // 绑定滚动控制器
        Column() {
          ForEach(this.transBoxList, (box: TransBox) => { // ForEach语法循环创建子组件
            this.transBoxBuilder(1,box.origin,box.translation)
          })
        }
        .width("100%")
      }
      .scrollable(ScrollDirection.Vertical) // 设置竖直方向滚动
      .scrollBarColor(Color.Gray) // 设置滚动条颜色
      .scrollBarWidth(10) // 设置滚动条宽度
      .scrollBar(BarState.On) // 设置滚动条永久显示
      .width('100%')
      .height('70%')
      .padding({
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
      })
      .backgroundColor('#e8e8e4')
      .align(Alignment.Top)

      TextArea({ placeholder: "请输入想要翻译的内容：" })
        .width("100%")
        .height("20%")
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
        .id('transInput')

      Row() {
        Row(){
          Select([{value:'英'},{value:'中'}])
            .selected(0)
            .value('英')
            .onSelect((index: number) => {
              this.transMode = index
            })
          Text("译")
          Select([{value:'英'},{value:'中'}])
            .selected(1)
            .value('中')
            .onSelect((index: number) => {
              this.transMode = index
            })
        }
        Button('Translation')
          .backgroundColor(Color.Pink)
          .width("50%")
          .onClick(() => {
            this.submit(this.input,this.transMode)
          })
      }.justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .width("100%")
      .height("10%")
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
      .id("sendButton")

    }
    .height('100%')
    .width('100%')
  }

  async submit(message: string, mode:number) {

    const resp:TransBox =await translate(message,mode)
    console.log("submit:" + JSON.stringify(resp))
    this.transBoxList.push(resp)
    AppStorage.setOrCreate("Translation" ,this.transBoxList)
  }

  aboutToAppear(): void {
    this.transBoxList = AppStorage.get("Translation") || []
  }
}
async function translate(message:string,mode:number): Promise<TransBox>{

  const  token = "lj1jbtel8gbhubdmg9dj"
  const  transParamsObj = createTransRequest(mode==0?"en2zh":"zh2en",message)
  const trans:Promise<TransBox> = postTranslate(transParamsObj,token,message,mode)
  trans.then((value)=>{
    return value
  })
  return trans
}
function createTransRequest(precond:string,message:string){
  const transParamsObj: TransParamsObj = {
    "source": message,
    "trans_type": precond,
    "request_id": "demo",
    "detect": true,
  }
  return transParamsObj

}
