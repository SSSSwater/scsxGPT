import router from '@ohos.router';

@Component export struct TitleBar {

  @Prop titleBarAttribute: TitleBarAttribute; // 定义标题栏属性

  build() {
    Row() {
      Stack({alignContent: Alignment.Start}) {  // 返回键左对齐
        if (this.titleBarAttribute && this.titleBarAttribute.backShow){
          Image($r("app.media.ic_public_back"))
            .width(35)
            .height(35)
            .objectFit(ImageFit.Contain)
            .padding(5)
            .margin({left: 10})
            .onClick(() => {
              this.titleBarAttribute.backCallback() // 返回键点击事件回调
              // router.pushUrl({
              //   url: 'pages/Main'
              // });
            })
        }
      }
      .layoutWeight(1)
      .height('100%')

      Stack({alignContent: Alignment.Start}) {

        if (this.titleBarAttribute && this.titleBarAttribute.title) {

          Text(this.titleBarAttribute.title)
            .fontSize(20)
            .fontFamily('dx')
        }
      }
      .layoutWeight(6)
    }
    .width('100%')
    .height(70)
    .backgroundColor(Color.White)

  }
}

export  class TitleBarAttribute {
  // 返回键属性设置
  public backShow: boolean = false; // 是否显示返回键
  public backCallback: () => void  = ()=>{}// 点击返回键的事件回调

  // 标题属性设置
  public title: string = "";        // 设置标题文本

  // constructor(title:string,backShow:boolean,backCallback: () => void) {
  //   this.title = title
  //   this.backShow = backShow
  //   this.backCallback = backCallback
  // }
}