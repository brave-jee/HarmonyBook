import Constants from '../common/Constants';
import {httpRequestGet} from '../utils/request';
import ResponseResult from '../viewModel/ResponseResult';
export interface ChaptersListModel{
  chapterId:string;
  chapterTitle:string;
  nextChapterId:string;
}

export interface ChaptersModel{
  bookTitle:string;
  chapterSize:number;
  chapters:Array<ChaptersListModel>,
  page:number;
}


class ChaptersRequest {
  ChaptersRequestHandler(pathname: string): Promise<ChaptersModel> {
    return new Promise((resolve: Function) => {
      let url = `${Constants.SERVER}${pathname}`; // url='https://xxxx.com/book_mall'
      httpRequestGet(url).then((data: ResponseResult) => {
        console.log(JSON.stringify(data))
        //   判断请求是否成功
        if (data.errcode === Constants.HTTP_ERRCODE) {
          // 请求成功 传递数据
          resolve(data.data)
        }
      })
    })
  }
}

let chaptersRequest = new ChaptersRequest()
export  default chaptersRequest