import Constants from '../common/Constants';
import {httpRequestGet} from '../utils/request';
import ResponseResult from '../viewModel/ResponseResult';

// 限定 bannerList 数据结构
export interface BannerList{
  bannerUrl:string;
  sourceId:string;
  sourceName:string;
}
// 限定书籍数据结构
interface  BookList{
  title:string; // 书名
  authorName:string; // 作者
  coverUrl:string; // 封面
  intro:string; // 简介
  allWords:number; // 字数
  categoryName:string; // 分类
  status:number; // 50：完结 ； 30：连载
  sourceId:string; // 资源id
  sourceName:string; // 资源名
}

// 针对分类数据结构进行限定
interface  ChannerList{
  title:string;
  bookList:Array<BookList>
}


interface HomeModel{
  bannerList:Array<BannerList>; // 数组泛型
  channelList:Array<ChannerList>
}

// 定义一个类
class HomeRequest{
  // 使用promise() 进行二次请求封装
  homeRequestHandler(pathname:string):Promise<HomeModel>{
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
let homeRequest = new HomeRequest()
export default  homeRequest;