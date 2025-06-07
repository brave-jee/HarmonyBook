import readerRequest, { ReaderChapterModel } from '../viewModel/Reader'

// 跳转页面入口函数
@Builder
export function ReaderPageBuilder() {
  ReaderPage()
}

class ReaderParams {
  sourceName: string = '';
  sourceId: string = '';
  chapterId?: string = '';

  constructor(sourceName: string, sourceId: string, chapterId?: string) {
    this.sourceName = sourceName;
    this.sourceId = sourceId;
    this.chapterId = chapterId;
  }
}

@Entry
@Component
struct ReaderPage {
  @State queryParams: ReaderParams = new ReaderParams('', '', '')
  @State readerData: ReaderChapterModel = {
    chapterId: '',
    chapterTitle: '',
    content: '',
    sourceId: '',
    sourceName: '',
    nextChapterId: '',
    prevChapterId: ""
  }

  getFirstChapter() {
    readerRequest.ReaderRequestHandler(`/chapter_content?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}`)
      .then(res => {
        this.readerData = res;
      })
  }

  getOtherChapter() {
    readerRequest.ReaderRequestHandler(`/chapter_content?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}&chapterId=${this.queryParams.chapterId}`)
      .then(res => {
        console.log('数据请求回来', JSON.stringify(res))
        this.readerData = res;
      })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Text(this.readerData.chapterTitle)
          Text(this.readerData.content)

          Row() {
            Text('上一章')
              .onClick(() => {
                if (this.readerData.prevChapterId) {
                  this.queryParams =
                    new ReaderParams(this.readerData.sourceName, this.readerData.sourceId, this.readerData.prevChapterId)

                  this.getOtherChapter()
                }
              })
            Text('目录')
            Text('下一章').onClick(() => {
              if (this.readerData.nextChapterId) {
                this.queryParams =
                  new ReaderParams(this.readerData.sourceName, this.readerData.sourceId, this.readerData.nextChapterId)

                this.getOtherChapter()
              }
            })
          }
        }
      }
    }.onReady((context: NavDestinationContext) => {
      this.queryParams = (context?.pathInfo?.param) as ReaderParams;

      // 发送请求
      this.getFirstChapter()
    })
  }
}