import Constants from '../common/Constants';
import {httpRequestGet} from '../utils/request';
import ResponseResult from '../viewModel/ResponseResult';

export interface ReaderChapterModel {
  chapterId: string;
  chapterTitle: string;
  content: string;
  nextChapterId?: string; // 可选属性
  prevChapterId?: string; // ?: 可选属性
  sourceId: string;
  sourceName: string;
}

class ReaderRequest {
  ReaderRequestHandler(pathname: string): Promise<ReaderChapterModel> {
    return new Promise((resolve: Function) => {
      let url = `${Constants.SERVER}${pathname}`; // url='https://xxxx.com/book_mall'
      httpRequestGet(url).then((data: ResponseResult) => {
        console.log('测试请求', url)
        console.log(JSON.stringify(data))
        //   判断请求是否成功
        if (data.errcode === Constants.HTTP_ERRCODE) {
          console.log('999999')
          // 请求成功 传递数据
          resolve(data.data)
        }
      })
    })
  }
}

let readerRequest = new ReaderRequest()
export  default readerRequest