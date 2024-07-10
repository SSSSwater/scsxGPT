
@Entry
@Component
struct Main {
  @Builder
  mainBuilder() {
    Column() {
    }
    // 设置Column的宽高为100%，顶部边框，内容居中对齐
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .border({ width: { top: 1 }, color: '#eee' })
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      // 标题
      Row() {
        Stack({ alignContent: Alignment.Start }) { // 返回键左对齐
          Image($r("app.media.myself_active"))
            .width(40)
            .height(40)
            .objectFit(ImageFit.Contain)
            .padding(5)
            .margin({ left: 10 })
            .onClick(() => {
              // router.pushUrl({url:'pages/Index',params:currentIndex=3})
            })
        }
        .layoutWeight(1)
        .height('100%')

        Text('欢迎使用scsxGPT')
          .fontColor(Color.White)
          .fontSize(20)
          .fontFamily('dx')
          .layoutWeight(3)
          .padding(10)
          .height('100%')
      }
      .width('100%')
      .height(70)
      .backgroundColor($r('sys.color.brand'))

      // 轮播图
      Swiper() {
        Image($r("app.media.ai_chat_bot"))
          .width('100%')
        Image($r("app.media.scsx_gpt"))
          .width('100%')
        Image($r("app.media.new_free"))
          .width('100%')
      }
      .autoPlay(true)
      .indicator( // 设置圆点导航点样式
        new DotIndicator()
          .itemWidth(8)
          .itemHeight(8)
          .selectedItemWidth(8)
          .selectedItemHeight(8)
          .color(Color.White)
          .selectedColor('sys.color.brand')
      )
      .margin(5)

      // // 按钮
      // Row() {
      //   Button() {
      //     Image($r("app.media.myself_active"))
      //   }
      //   .type(ButtonType.Capsule)
      //   .backgroundColor($r('sys.color.comp_background_list_card'))
      //
      //   Button() {
      //     Text('词单')
      //   }
      //   .type(ButtonType.Capsule)
      //   .backgroundColor($r('sys.color.comp_background_list_card'))
      //
      // }.height(50)

      // 资讯栏


    }
    .backgroundColor('#F1F3F5')





  }
}