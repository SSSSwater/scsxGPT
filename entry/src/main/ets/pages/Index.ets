import { ChatDetail } from '../components/ChatDetailComponent'
import { TransComponent } from '../components/TransComponent'
import { tabsModel } from '../models/tabsModel'
import {inforComponent} from  '../components/InforComponent'
@Entry
@Component
struct Index {
  // 使用@State装饰器定义一个响应式状态变量，用于记录当前选中的Tab索引
  @State
  currentIndex: number = 0
  @State
  hotCateIndex: number = 0
  @State
  currentTitle: string = '欢迎使用ChatGPT'
  @State
  message: string = '欢迎使用ChatGPT'
  @State
  GPT: number = 50//GPT次数

  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg).width(24)
      // 显示Tab的标题，根据当前索引是否等于传入的index，改变文字颜色
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? Color.White : Color.Black)
        .fontSize(12)
        .margin({ top: 4 })
    }
    // 设置Column的宽高为100%，顶部边框，内容居中对齐
    .width('100%')
    .height('100%')

    .backgroundColor((this.currentIndex == targetIndex ? '#007DFF' : Color.White))
    .border({ width: { top: 1 }, color: '#eee' })
    .justifyContent(FlexAlign.Center)
  }

  private controller: TabsController = new TabsController()

  build() {
    Column() {
      // 侧边栏

      // Tabs组件，用于展示多个Tab内容
      Tabs({
        barPosition: BarPosition.End,
        index: this.currentIndex,
        controller: this.controller
      }) {
        TabContent() {
          ChatDetail({GPTCost:this.GPT})
        }
        .tabBar(this.tabBuilder('聊天', 0, $r('app.media.chat_active'), $r('app.media.chat')))
        TabContent() {
          TransComponent({GPTCost:this.GPT})
        }.tabBar(this.tabBuilder('翻译', 1, $r('app.media.translate_active'), $r('app.media.translate')))

        TabContent() {
          inforComponent({GPTremainder:this.GPT})
        }.tabBar(this.tabBuilder('我的', 2, $r('app.media.myself_active'), $r('app.media.myself')))

      }
      // 设置Tabs组件占据剩余空间，并监听Tab切换事件以更新currentIndex状态
      .layoutWeight(1)
      .backgroundColor('#f5f5f5')
      .onChange((index) => {
        this.currentIndex = index
        this.currentTitle = tabsModel[index]['title']

      })
    }
    .height('100%')
    .width('100%')
  }
}
