import Constant from '../Common/Constant'
import router from'@ohos.router'
import http from '@ohos.net.http';
import { promptAction } from '@kit.ArkUI';


interface IParams{
  from:string,
  data:string
}
@Entry
@Component
struct Login{
  @State message: string = 'Please login'
  @State username: string = ''
  @State password: string = ''
  @State usernameColor:number = 0x000000;
  @State passwordColor: number = 0x000000;


  // 表单验证是否成功：
  formIsSuccess() {
    return this.username.trim() !== "" && this.password.trim() !== "";
  }

  loginCheck() {
    //   1、非空验证
    if (this.username.trim() == "") {
      console.log("用户名不能为空")
      this.usernameColor = 0xff0000;
      return;
    }

    if (this.password.trim() == "") {
      console.log("密码不能为空")
      this.passwordColor = 0xff0000;
      return;
    }

  }
  build(){
    Row(){
      Column(){
        Image($r("app.media.ChatGPT"))
          .width("60")
          .height("60")
          .margin(50);
        Text(this.message)
          .fontColor(Constant.LOGIN_COLOR)
          .fontSize(Constant.LOGIN_SIZE)
          .fontWeight(FontWeight.Bold)
        TextInput({ placeholder: 'Username' })
          .margin({ top: 40 })
          .width(Constant.INPUT_WIDTH)
          .height(Constant.INPUT_HEIGHT)
          .onChange((value: string )=>{
            this.username = value
          })
        TextInput({ placeholder: 'Password'}).type(InputType.Password)
          .margin({ top: 40 })
          .width(Constant.INPUT_WIDTH)
          .height(Constant.INPUT_HEIGHT)
          .onChange((value: string )=>{
            this.password = value
          })
        Button('Login in')
          .width(Constant.BUTTON_WIDTH)
          .height(Constant.BUTTON_HEIGHT)
          .margin({ top: 60})
          .backgroundColor(Constant.BUTTON_COLOR)
          .onClick(() => {
            const httpRequest = http.createHttp();
            httpRequest.request(`https://apifoxmock.com/m1/4156288-0-default/login?username=${this.username}&userpass=${this.password}`,(err,data)=>{
              // !err 只是表示请求响应没有问题，不代表是否获取到了数据
              interface MyObject {
                username:string
                userpass:string
              }
              if(!err){
                console.log("data.result",data.result)
                const resultString = data.result as string;
                const arr = JSON.parse(resultString) as MyObject;
                console.log("data.result",JSON.stringify(arr))
                if(this.username==arr.username&&this.password==arr.userpass){
                  console.log("登录成功");
                  console.log("from",(router.getParams() as IParams).from)
                  // 跳转到我的页面。
                  // router.back();
                  router.pushUrl({
                    url:(router.getParams() as IParams).from,
                    params:{
                      data:(router.getParams() as IParams).data
                    }
                  })
                }else{
                  console.log("登录失败，用户名或密码不正确")
                }
              }else{
                console.log("网络出错")
              }
            })


          })

        Row(){
          Text('No account yet?  ')
              }.margin({top:40})
        Button("Register")
          .width(Constant.BUTTON_WIDTH)
          .height(Constant.BUTTON_HEIGHT)
          .margin({ top: 10})
          .backgroundColor(Constant.BUTTON_COLOR)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Register'
            });
          })
        Blank().height(60)
        Row() {
          Text("--第三方账号登录--").fontColor("gray")
        }.margin({
          bottom: 20
        })


        Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
          Image($r("app.media.qq")).width(40).height(40)
          Image($r("app.media.weixin")).width(40).height(40)
          Image($r("app.media.phone")).width(40).height(40)
        }.width("100%")
        .height(50)
      }
      .width('100%')

    }
    .height('100%')

  }

}
