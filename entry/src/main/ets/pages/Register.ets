import Constant from '../Common/Constant'
import http from '@ohos.net.http';
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Register {
  @State message: string = 'Please Register'
  @State username: string = ''
  @State password: string = ''
  @State password2: string = ''
  @State usernameColor: number = 0x000000;
  @State passwordColor: number = 0x000000;
  @State password2Color: number = 0x000000;

  formIsSuccess() {
    return this.username.trim() !== "" && this.password.trim() !== "" && this.password2.trim() !== "" &&
      this.password === this.password2
  }

  regSave() {
    //   1、非空验证
    if (this.username.trim() == "") {
      console.log("用户名不能为空")
      return;
    }

    if (this.password.trim() == "") {
      console.log("密码不能为空")
      return;
    }
    if (this.password2.trim() == "") {
      console.log("确认密码不能为空")
      return;
    }
    //   2、密码是否一致

    //   3、发送请求，进行注册
    const httpRequest = http.createHttp();
    httpRequest.request("http://localhost:3000/vips", {
      method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
      // 开发者根据自身业务需要添加header字段
      header: {
        'Content-Type': 'application/json'
      },
      // 当使用POST请求时此字段用于传递内容
      extraData: {
        username: this.username,
        userpass: this.password
      },
      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    }, (err, data) => {
      if (!err) {
        console.log("data.result", data.result)
        console.log("data.responseCode", data.responseCode)
        if (data.responseCode == 201) {
          console.log("注册成功")
        }
      }
    })
  }

  build() {
    Row() {
      Column() {
        Button("Back").onClick(()=>{
          console.log("in");
          router.back({
            url: 'pages/Login'
          });
        }).width("100").backgroundColor(Constant.LOGIN_COLOR).margin(20).height(30)

        Text(this.message)
          .fontColor(Constant.LOGIN_COLOR)
          .fontSize(Constant.LOGIN_SIZE)
          .fontWeight(FontWeight.Bold)
        TextInput({ placeholder: 'Username' })
          .margin({ top: 50 })
          .width(Constant.INPUT_WIDTH)
          .height(Constant.INPUT_HEIGHT)
          .onChange((value: string) => {
            this.username = value
          })
        TextInput({ placeholder: 'Password' })
          .type(InputType.Password)
          .margin({ top: 30 })
          .width(Constant.INPUT_WIDTH)
          .height(Constant.INPUT_HEIGHT)
          .onChange((value: string) => {
            this.password = value
          })
        TextInput({ placeholder: 'Confirm Password' })
          .type(InputType.Password)
          .margin({ top: 30 })
          .width(Constant.INPUT_WIDTH)
          .height(Constant.INPUT_HEIGHT)
          .onChange((value: string) => {
            this.password2 = value
          })
        if (this.password !== this.password2) {
          Text("Two password do not match!").fontSize(20).fontColor(Color.Red);
        }
        Button('Register')
          .width(Constant.BUTTON_WIDTH)
          .height(Constant.BUTTON_HEIGHT)
          .margin({ top: 30 })
          .backgroundColor(Constant.BUTTON_COLOR)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login',
              params: {
                username: this.username,
                password: this.password,
                password2: this.password2
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}