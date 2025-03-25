import { TransBox, defaultTransBoxList, TransParamsObj} from '../models/transBox'
import { postTranslate } from '../tool/translateAxios';
import { promptAction, router } from '@kit.ArkUI';
import { TitleBar } from './TitleBar';
import { it } from '@ohos/hypium';

@Extend(Span) function textCommon(grayAndItalic:boolean,size:number){
  .fontSize(size)
  .fontColor(grayAndItalic?Color.Gray:Color.Black)
  .fontStyle(grayAndItalic?FontStyle.Italic:FontStyle.Normal)
}

@Component
export struct TransComponent {
  @Link GPTCost:number;
  @State input: string = "";
  @State transModeLeft: number = 1; //0中 1英 2日
  @State transModeRight: number = 0;
  private scroller: Scroller = new Scroller(); // 创建一个滚动控制器
  @State transBoxList: TransBox[] = defaultTransBoxList;

  @Builder
  modeSelector(){
    Row({space:5}){
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
    .margin({left:15})
    .height('100%')
    .width('50%')

  }

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
    Column(){
      TitleBar({
        titleBarAttribute: {
          title: "翻译",
          backShow: true, // 显示菜单
          backCallback: () => { // 设置点击回调
            //返回主页
            router.back();
          }
        }
      })
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
        .height('75%')
        .padding({
          top: 10,
          bottom: 10,
          left: 10,
          right: 10
        })
        .backgroundColor('#F1F3F5')
        .align(Alignment.Top)

        RelativeContainer(){
          RelativeContainer(){

            this.modeSelector()
            Column(){
              Text("消耗额度:1")
              Text("可用额度:" + this.GPTCost)
            }
            .alignRules({
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceAround)
            .width('30%')
            .height('100%')
          }
          .height('40%')

          Stack({alignContent:Alignment.End}) {
            Row(){
              TextArea({ placeholder: "请输入想要翻译的内容：", text: this.input })
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
              Image($r('app.media.ic_public_translate_c2e'))
                .width(30)
                .height(30)
            }
            .backgroundColor(Color.White)
            .width("20%")
            .height('70%')
            .margin('7%')
            .border({radius:15})
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
                if (this.input == '') {
                  promptAction.showToast({
                    message: '输入不能为空!',
                    duration: 1600,
                    bottom: 150
                  })
                }else{
                  if(this.GPTCost< 1){
                    promptAction.showToast({
                      message:'免费版额度已用完!请支持专业版',
                      duration:1600,
                      bottom:150})
                  } else{
                    this.submit(this.input,this.transModeLeft,this.transModeRight)
                  }
                  }
              }
            })

          }
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
          })
          .width("100%")
          .height("60%")
          .id("sendButton")
        }
        .width("100%")
        .height("25%")
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
        //
        // TextArea({ placeholder: "请输入想要翻译的内容：" })
        //   .width("100%")
        //   .height("20%")
        //   .fontSize(22)
        //   .fontColor(Color.Black)
        //   .fontStyle(FontStyle.Italic)
        //   .placeholderColor(Color.Gray)
        //   .placeholderFont({
        //     size: 18,
        //     style: FontStyle.Italic
        //   })
        //   .onChange((msg) => {
        //     this.input = msg;
        //   })
        //   .alignRules({
        //     bottom: { anchor: 'sendButton', align: VerticalAlign.Top },
        //   })
        //   .id('transInput')
        //
        // Row() {
        //   Row(){
        //     Select([{value:'中'},{value:'英'},{value:'日'}])
        //       .selected(1)
        //       .value('英')
        //       .onSelect((index: number) => {
        //         this.transModeLeft = index
        //       })
        //     Text("译")
        //     Select([{value:'中'},{value:'英'},{value:'日'}])
        //       .selected(0)
        //       .value('中')
        //       .onSelect((index: number) => {
        //         this.transModeRight = index
        //       })
        //   }
        //   Button('Translation')
        //     .backgroundColor('#007DFF')
        //     .width("50%")
        //     .onClick(() => {
        //       if (this.transModeLeft == this.transModeRight){
        //         promptAction.showToast({
        //           message:'不能选同种语言',
        //           duration:1600,
        //           bottom:150}
        //         )
        //       } else if (this.transModeLeft * this.transModeRight !=0){
        //         promptAction.showToast({
        //           message:'暂不支持英日互译',
        //           duration:1600,
        //           bottom:150}
        //         )
        //       }else{
        //         this.submit(this.input,this.transModeLeft,this.transModeRight)
        //       }
        //     })
        // }
        // .justifyContent(FlexAlign.SpaceAround)
        // .alignItems(VerticalAlign.Center)
        // .width("100%")
        // .height("10%")
        // .alignRules({
        //   bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        // })
        // .id("sendButton")

      }
      .height('90%')
      .width('100%')
    }

    .backgroundColor('#F1F3F5')
    .height('100%')
    .width('100%')
  }

  async submit(message: string, modeLeft:number, modeRight:number) {

    this.GPTCost -= 1;
    this.input = ""
    this.scroller.scrollEdge(Edge.Bottom)
    const modeEnum:string[] = ['zh','en','ja']
    const mode = modeEnum[modeLeft] + '2' + modeEnum[modeRight]
    console.log(mode)
    const resp:TransBox =await translate(message,mode)
    console.log("submit:" + JSON.stringify(resp))
    this.transBoxList.push(resp)
    AppStorage.setOrCreate("Translation" ,this.transBoxList)
    this.scroller.scrollEdge(Edge.Bottom)
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
