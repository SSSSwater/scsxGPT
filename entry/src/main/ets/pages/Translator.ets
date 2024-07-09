import { TransBox, defaultTransBoxList,MessageModel,ParamsObj, TransParamsObj} from '../models/transBox'
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'

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
        .height("22%")
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
        Column(){
          Toggle({ type: ToggleType.Switch })
            .selectedColor(Color.Pink)
            .onChange((isOn)=>{
              this.transMode = isOn?1:0
            })
          Text(this.transMode?"中译英":"英译中")
        }.alignItems(HorizontalAlign.Center)
        Button('Translation')
          .backgroundColor(Color.Pink)
          .width("70%")
          .onClick(() => {
            this.submit(this.input,this.transMode)
          })
      }.justifyContent(FlexAlign.SpaceAround)
      .width("100%")
      .height("5%")
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
      .margin({bottom:"5%"})
      .id("sendButton")

    }
    .height('100%')
    .width('100%')
  }

  submit(message: string, mode:number) {

    const resp:TransBox = translate(message,mode)
    console.log("submit:" + JSON.stringify(resp))
    this.transBoxList.push(resp)
    AppStorage.setOrCreate("Translation" ,this.transBoxList)
  }

  aboutToAppear(): void {
    this.transBoxList = AppStorage.get("Translation") || []
  }
}
function translate(message:string,mode:number):TransBox{

  const  token = "3975l6lr5pcbvidl6jl2"
  const  transParamsObj = createTransRequest(mode==0?"en2zh":"zh2en",message)
  console.log(JSON.stringify(transParamsObj))
  axios({
    method:'post',
    url:'http://api.interpreter.caiyunai.com/v1/translator',
    headers : {"content-type" : "application/json",
      "x-authorization": "token " + token},
    data: transParamsObj
  }).then((res: AxiosResponse) => {
    console.log("111")
    let trans:TransBox = {'origin': message,
      'translation': res.data.target,
      'mode': mode} as TransBox
    console.log(JSON.stringify(trans))
    console.log("112")
    console.log('result:' + JSON.stringify(trans));
    return trans
  }).catch((error: AxiosError) => {
    console.log("113")
    console.error(JSON.stringify(error));
    return {} as TransBox
  })
  console.log("114")
  return {} as TransBox

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

function createGPTRequest(precond:string,message:string){
  const paramsObj: ParamsObj = {
    "model": "gpt-3.5-turbo-1106",
    "messages": [
      {
        "role": "system",
        "content": precond
      },
      {
        "role": "user",
        "content": message
      }
    ]
  }
  return paramsObj

}