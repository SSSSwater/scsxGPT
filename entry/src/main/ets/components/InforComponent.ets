import { router } from '@kit.ArkUI';

interface GenderOption {
  value: string;
}

@Component
export struct inforComponent {
  @State private nickname: string = '111';
  @State private phoneNumber: string = '188****1234';
  @State private  gender : string = '男';

  @State arrowPosition: ArrowPosition = ArrowPosition.END
  @Prop GPTremainder :number;

  private genderOptions: GenderOption[] = [
    { value: '男' },
    { value: '女' },
    { value: '不明' }
  ];
  private getGenderIndex(): number {
    return this.genderOptions.findIndex(option => option.value === this.gender);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($rawfile('back.png'))
          .width(24).height(24)
        Text('个人信息')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .padding({ left: 18, right: 16 })
      .backgroundColor(Color.White)

      // 内容区域
      List() {
        // 头像
        ListItem() {
          Row() {
            Text('头像').fontSize(16).fontColor('#182431')
            Image($rawfile('id.png'))
              .width(40).height(40).borderRadius(20)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }
        .height(80)
        .padding({ left: 16, right: 16 })

        // 个人信息
        ListItem() {
          Row() {
            Text('昵称').fontSize(16).fontColor('#182431')
            Text(this.nickname).fontSize(16).fontColor('#999999')
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }.height(48).padding({ left: 16, right: 16 })

        ListItem() {
          Row() {
            Text('手机号').fontSize(16).fontColor('#182431')
            Text(this.phoneNumber).fontSize(16).fontColor('#999999')
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }.height(48).padding({ left: 16, right: 16 })


        ListItem() {
          Row() {
            Text('性别').fontSize(16).fontColor('#182431')
            Text('男').fontSize(16).fontColor('#999999')
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }.height(48).padding({ left: 16, right: 16 })

            // Select(this.genderOptions)
            //   .accessibilityText("男")
            //   .font({size:16,weight:500})
            //   .fontColor('#182431')
            //   .optionFont({size:16,weight:400})
            //   .selectedOptionFont({size:16,weight:400})
            //   .height(48)
            //   .onSelect((index: number) => {
            //     this.gender = this.genderOptions[index].value;
            //   })// 设置 Select 组件的总高度为 48 像素
            //   .backgroundColor("white")
        //   }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        // }.padding({ left: 16, right: 16 })



          ListItem() {
            Row() {
              Text('生日').fontSize(16).fontColor('#182431')
              Text('2000/1/1').fontSize(16).fontColor('#999999')
            }.justifyContent(FlexAlign.SpaceBetween).width('100%')
          }.height(48).padding({ left: 16, right: 16 })

          ListItem() {
            Row() {
              Text('地区').fontSize(16).fontColor('#182431')
              Text('浙江').fontSize(16).fontColor('#999999')
            }.justifyContent(FlexAlign.SpaceBetween).width('100%')
          }.height(48).padding({ left: 16, right: 16 })
        ListItem() {
          Row() {
            Text('GPT剩余查询次数').fontSize(16).fontColor('#182431')
            Text(""+this.GPTremainder).fontSize(16).fontColor('#999999')
          }.justifyContent(FlexAlign.SpaceBetween).width('100%')
        }.height(48).padding({ left: 16, right: 16 })
        }
        .backgroundColor(Color.White)
        .divider({ strokeWidth: 0.5, color: '#E3E3E3' })


        // 退出登录按钮
        Button('退出登录')
          .width('90%')
          .height(50)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .margin({ top: 24 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login'
            });
          })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
  }


@Component
struct TitleBar {
  private title: string = ''

  build() {
    Row() {

      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }
}