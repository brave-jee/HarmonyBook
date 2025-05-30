//
import { http } from "@kit.NetworkKit"
import Constants, {  ContentType } from '../common/Constants'
import ResponseResult from '../viewModel/ResponseResult'

/**
 *
 * @param url URL for initiating an HTTP request.
 * @returns
 */
export  function httpRequestGet(url:string){
  return httpRequest(url, http.RequestMethod.GET)
}


function httpRequest(url: string, method: http.RequestMethod, params: http.HttpRequestOptions = {}): Promise<ResponseResult> {

  // 创建httpRequest 对象
  let httpRequest = http.createHttp();
  // console.log('url=',url)
  let responseResult = httpRequest.request(url, {
    method: method,
    header: {
      'Content-Type': ContentType.JSON,
      "User-Agent":"Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1 Edg/130.0.0.0"
    },
    extraData: params,
    // expectDataType: http.HttpDataType.OBJECT
  })



  let serverResult = new ResponseResult() //  返回的数据限定

  return responseResult.then((data: http.HttpResponse) => {
    // console.log('封装的请求',JSON.stringify(data.result))
    if (data.responseCode == Constants.HTTP_ERRCODE_200) {
      let result = `${data.result}`; // json 转换
      let resultJson: ResponseResult = JSON.parse(result);
      if (resultJson.errcode === Constants.HTTP_ERRCODE) {
        serverResult.data = resultJson.data // 处理请求回来的数据
      }
      serverResult.errcode = resultJson.errcode;
      serverResult.errmsg = resultJson.errmsg;

    } else {
      serverResult.errmsg = `${$r('app.string.Http_error_message')}&${data.responseCode}`;
    }

    return serverResult
  }).catch(() => {
    serverResult.errmsg = `$r('app.string.Http_error_message')`;
    return serverResult;
  })
}

