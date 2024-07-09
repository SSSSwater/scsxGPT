import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { TransBox, defaultTransBoxList, TransParamsObj} from '../models/transBox'
import {ChatBox, ChatParamsObj, defaultChatBoxList} from '../models/chatBox'

//创建axios的实例
const instance = axios.create({
  // baseURL: "http://47.95.4.181", //基路径，要看API帮助文档的特征来确定基路径
  baseURL: 'http://localhost:9527/',
  timeout: 5000, //请求超时的时间
})
//获取翻译
export async function postTranslate (transParamsObj:TransParamsObj,token:string,message:string,mode:number): Promise<TransBox>{
  return new Promise((resolve) => {
    axios({
      method:'post',
      url:'http://api.interpreter.caiyunai.com/v1/translator',
      headers : {"content-type" : "application/json",
        "x-authorization": "token " + token},
      data: transParamsObj
    }).then((res: AxiosResponse) => {
      let resp = {'origin': message,
        'translation': res.data.target,
        'mode': mode} as TransBox
      resolve(resp);
    }).catch((error: AxiosError) => {
      console.error(JSON.stringify(error));
      resolve({} as TransBox);
    })
  })
}
//获取gpt的回复

export async function postGPT (chatParamsObj:ChatParamsObj,message:string): Promise<ChatBox>{
  return new Promise((resolve) => {
    axios({
      method:'post',
      url:'https://api.chatanywhere.com.cn/v1/chat/completions',
      headers : {"Content-Type" : "application/json",
        "Authorization": "Bearer sk-vUdoqlqdODGulzVxiJPBShCdHHxRKWI4gjq0zG1TANm3hR70"},
      data: chatParamsObj
    }).then((res: AxiosResponse) => {
      let resp = {'id': "1",
        'message': res.data.choices[0].message.content,
        'role': 1} as ChatBox
      resolve(resp)
    }).catch((error: AxiosError) => {
      console.error(JSON.stringify(error));
      resolve({} as ChatBox)
    })
  })
}
//响应拦截器，通过响应拦截器进一步对返回的数据做处理
instance.interceptors.response.use((response) => {
  //只返回接口有数据的结果
  if (200 === response.status) {
    return response.data; //接口返回的数据
  }
  return Promise.reject(response); //表示请求有错，交给catch来处理结构
}, err => {
  return Promise.reject(err)
})

export default instance