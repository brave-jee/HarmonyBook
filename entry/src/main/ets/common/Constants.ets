export default  class Constants {
  // 定义请求前缀  服务器地址
  static  readonly  SERVER:string = 'https://m.taoyuewenhua.com/ajax'

  static   readonly HTTP_ERRCODE = 0;

  static  readonly  HTTP_ERRMSG = 'success';

  static   readonly HTTP_ERRCODE_200 = 200;
}



export const  enum ContentType{
  JSON = 'application/json',
  FORM = 'multipart/form-data'
}