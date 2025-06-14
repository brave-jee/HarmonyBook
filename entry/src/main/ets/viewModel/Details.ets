import Constants from '../common/Constants';
import {httpRequestGet} from '../utils/request';
import ResponseResult from '../viewModel/ResponseResult';

// 定义详情页的数据结构
export interface  DetailsModel{
  allWords:number;
  coverUrl:string;
  title:string;
  intro:string;
  authorName:string;
  latestChapter:string;
  categoryName:string;
  sourceId:string;
  sourceName:string;
  status:number;
  createTime:number;

}

export interface  CommentsModel{
  content:string;
  header:string;
  nickname:string;
  createdOn:number;
  upCount:number;
  score:number;
  bookId:string;
}


// 定义一个类
class DetailsRequest{
  // 使用promise() 进行二次请求封装
  detailsRequestHandler(pathname:string):Promise<DetailsModel>{
    return new Promise((resolve:Function) => {
      // 获取完整的请求url地址  pathname='/book_mall'  Constants.SERVER='https://xxxx.com'
      let url = `${Constants.SERVER}${pathname}`; // url='https://xxxx.com/book_mall'
      httpRequestGet(url).then((data:ResponseResult) => {
        //   判断请求是否成功
        if(data.errcode === Constants.HTTP_ERRCODE){
          // 请求成功 传递数据
          resolve(data.data)
        }
      })
    })
  }
  // 请求评论
  commentsRequestHandler(pathname:string):Promise<Array<CommentsModel>>{
    return new Promise((resolve:Function) => {
      // 获取完整的请求url地址  pathname='/book_mall'  Constants.SERVER='https://xxxx.com'
      let url = `${Constants.SERVER}${pathname}`; // url='https://xxxx.com/book_mall'
      httpRequestGet(url).then((data:ResponseResult) => {
        //   判断请求是否成功
        if(data.errcode === Constants.HTTP_ERRCODE){
          // 请求成功 传递数据
          resolve(data.data)
        }
      })
    })
  }
}

// 创建一个实例对象
let detailsRequest = new DetailsRequest()
export default  detailsRequest;