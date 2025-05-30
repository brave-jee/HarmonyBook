export  default class ResponseResult{
  data: string | object | ArrayBuffer;
  errcode: number;
  errmsg: string;

  constructor() {
    this.data = '';
    this.errcode = 0;
    this.errmsg = '';
  }
}

// export interface ResponseResult<T>{
//   data:T;
//   errcode:number;
//   errmsg:string;
// }