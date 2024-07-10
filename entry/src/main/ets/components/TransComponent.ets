import { TransBox, defaultTransBoxList, TransParamsObj} from '../models/transBox'
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { postTranslate } from '../tool/translateAxios';
import { promptAction } from '@kit.ArkUI';

@Extend(Span) function textCommon(grayAndItalic:boolean,size:number){
  .fontSize(size)
  .fontColor(grayAndItalic?Color.Gray:Color.Black)
  .fontStyle(grayAndItalic?FontStyle.Italic:FontStyle.Normal)
}

@Entry
@Component
export struct TransComponent {
  @State input: string = "";
  @State transModeLeft: number = 1; //0中 1英 2日
  @State transModeRight: number = 0;
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @State transBoxList: TransBox[] = defaultTransBoxList;

  @Builder
  transBoxBuilder(role:number,origin:string,translation:string){
    Text(){
      Span("原文:\n")
        .textCommon(true,20)
      Span(origin)
        .textCommon(true,18)
      Span("\n释义:\n")
        .textCommon(false,20)
      Span(translation)
        .textCommon(false,18)
    }
    .width('95%')
    .borderRadius(20)
    .backgroundColor(Color.White)
    .margin({ top: 10 })
    .alignSelf(ItemAlign.Center)
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
          Select([{value:'中'},{value:'英'},{value:'日'}])
            .selected(1)
            .value('英')
            .onSelect((index: number) => {
              this.transModeLeft = index
            })
          Text("译")
          Select([{value:'中'},{value:'英'},{value:'日'}])
            .selected(0)
            .value('中')
            .onSelect((index: number) => {
              this.transModeRight = index
            })
        }
        Button('Translation')
          .backgroundColor(Color.Pink)
          .width("50%")
          .onClick(() => {
            if (this.transModeLeft == this.transModeRight){
              promptAction.showToast({
                message:'不能选同种语言',
                duration:1600,
                bottom:150}
              )
            } else if (this.transModeLeft * this.transModeRight !=0){
              promptAction.showToast({
                message:'暂不支持英日互译',
                duration:1600,
                bottom:150}
              )
            }else{
              this.submit(this.input,this.transModeLeft,this.transModeRight)
            }
          })
      }.justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .width("100%")
      .height("10%")
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .id("sendButton")

    }
    .height('100%')
    .width('100%')
  }

  async submit(message: string, modeLeft:number, modeRight:number) {
    this.input = ""
    const modeEnum:string[] = ['zh','en','ja']
    const mode = modeEnum[modeLeft] + '2' + modeEnum[modeRight]
    console.log(mode)
    const resp:TransBox =await translate(message,mode)
    console.log("submit:" + JSON.stringify(resp))
    this.transBoxList.push(resp)
    AppStorage.setOrCreate("Translation" ,this.transBoxList)
  }

  aboutToAppear(): void {
    this.transBoxList = AppStorage.get("Translation") || []
  }
}

async function translate(message:string,mode:string): Promise<TransBox>{

  const  token = "lj1jbtel8gbhubdmg9dj"
  const  transParamsObj = createTransRequest(mode,message)
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
