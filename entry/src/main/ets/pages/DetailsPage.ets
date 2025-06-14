import detailsRequest, { DetailsModel, CommentsModel } from '../viewModel/Details'
import {
  formatWords,
  formatUpdateTime,
  formatCommentsTime,
  formatRatingScore,
  textCollapse,
  TextResult
} from '../utils/tools'

// 跳转页面入口函数
@Builder
export function DetailsPageBuilder() {
  DetailsPage()
}

// 跳转详情页的路由参数
class DetailsParams {
  sourceName: string = '';
  sourceId: string = '';

  constructor(sourceName: string, sourceId: string) {
    this.sourceName = sourceName;
    this.sourceId = sourceId;
  }
}

// 跳转章节目录页面的路由参数
class ChapterParams {
  sourceName: string = '';
  sourceId: string = '';
  chapterId?: string = '';

  constructor(sourceName: string, sourceId: string,chapterId?: string) {
    this.sourceName = sourceName;
    this.sourceId = sourceId;
    this.chapterId = chapterId;
  }
}

@Component
export default struct DetailsPage {
  // 接受路由对象
  @Consume('pageInfos') pageInfos: NavPathStack;
  // 接受路由传递的数据
  @State queryParams: DetailsParams = new DetailsParams('', '');
  @State detailsInfos: DetailsModel = {
    allWords: 0,
    coverUrl: '',
    title: '',
    intro: '',
    authorName: '',
    latestChapter: '',
    categoryName: '',
    sourceId: '',
    sourceName: '',
    status: 0,
    createTime: 0
  }
  @State commentsList: Array<CommentsModel> = [];
  @State intro: TextResult = new TextResult('', false)

  // 请求函数
  getDetailsData() {
    // 请求书籍的详细信息
    detailsRequest.detailsRequestHandler(`/book?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}`)
      .then((res: DetailsModel) => {
        this.detailsInfos = res;
        // 单独存储内容简介数据 ， 便于实现文本展开效果进行计算
        this.intro = textCollapse(this.detailsInfos.intro, false);
      })

    //  请求评论  /top_comments?sourceName=tf&sourceId=yq_10077
    detailsRequest.commentsRequestHandler(`/top_comments?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}`)
      .then(res => {
        this.commentsList = res;
      })
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Column() {
            Row() {
              Image(this.detailsInfos.coverUrl).width(87).width(125).margin({ right: 10 })
              Column() {
                Text(this.detailsInfos.title)
                  .fontWeight(900)
                  .fontSize(16)
                  .fontColor('#2e2e2e')
                  .margin({ bottom: 10 })
                  .textAlign(TextAlign.Start)
                  .width('100%')

                Text(this.detailsInfos.authorName)
                  .fontSize(13)
                  .fontColor('#2e2e2e')
                  .opacity(0.6)
                  .margin({ bottom: 15 })
                  .textAlign(TextAlign.Start)
                  .width('100%')

                Text(`${this.detailsInfos.categoryName}/暂无`)
                  .fontSize(13)
                  .fontColor('#2e2e2e')
                  .opacity(0.6)
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')

                Text(`最新:${this.detailsInfos.latestChapter}`)
                  .fontSize(13)
                  .fontColor('#2e2e2e')
                  .opacity(0.6)
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')

                Text(formatWords(this.detailsInfos.allWords))
                  .fontSize(13)
                  .fontColor('#2e2e2e')
                  .opacity(0.6)
                  .margin({ bottom: 8 })
                  .textAlign(TextAlign.Start)
                  .width('100%')
              }
              .justifyContent(FlexAlign.Start)
              .width(250)
            }

            Text('立即阅读')
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Center)
              .backgroundColor('#ffbb1b')
              .margin({ top: 10 })
              .onClick(() => {
                this.pageInfos.pushPath({
                  name: "ReaderPage",
                  param: new DetailsParams(this.detailsInfos.sourceName, this.detailsInfos.sourceId)
                })
              })
          }
          .width('100%')
          .padding({
            left: 15,
            right: 15,
            top: 13,
            bottom: 13
          })
          .border({ width: { bottom: 1 }, color: '#f9f9f9', style: BorderStyle.Solid })

          // 查看目录
          Row() {
            Row() {
            }.width(3).height(15).backgroundColor('#ffbb1b').margin({ left: 5, right: 10 })

            Text('查看目录').fontSize(16).fontColor('#000')
            // 完结或更新？
            Text(this.detailsInfos.status === 50 ? '已完结' : formatUpdateTime(this.detailsInfos.createTime))
              .margin({ left: 10 })
            Blank()
            Text() {
              // 字体图标   $r('sys.symbol.图标名')
              SymbolSpan($r('sys.symbol.chevron_right'))
            }.margin({ right: 15, left: 8 }).fontSize(14).fontColor('#2e2e2e').opacity(0.6)
          }
          .width('100%')
          .height(60)
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'ChaptersPage', param: new ChapterParams(this.detailsInfos.sourceName, this.detailsInfos.sourceId) })
          })

          // 内容简介
          Column() {
            Row() {
              Row() {
              }.width(3).height(15).backgroundColor('#ffbb1b').margin({ left: 5, right: 10 })

              Text('内容简介').fontSize(16).fontColor('#000')
            }
            .width('100%')

            Text() {
              Span(this.intro.clipTitle) // 默认展示的文本
              if (this.intro.isMore) {
                Span('...')
                Span('展开更多')
                  .fontColor('#1ba1ff')
                  .onClick(() => {
                    this.intro = textCollapse(this.detailsInfos.intro, true)
                  })
              }
            }
            .textAlign(TextAlign.Start)
            .padding({ left: 10, right: 10 })
            .margin({ top: 10 })
          }.margin({ bottom: 10 })

          // 书评  是否显示书评
          if (this.commentsList.length) {
            Column() {
              Row() {
                Row() {
                }.width(3).height(15).backgroundColor('#ffbb1b').margin({ left: 5, right: 10 })

                Text('热门书评').fontSize(16).fontColor('#000')
              }
              .width('100%')
              .margin({ top: 10 })

              // 评论列表
              Column() {
                ForEach(this.commentsList, (item: CommentsModel) => {
                  Column() {
                    Row() {
                      Image(item.header).width(20).height(20)
                        .borderRadius(10)
                      Text(item.nickname).fontColor('#a16400').fontSize(12).margin({ left: 5, right: 5 })
                      Text('读过').fontColor('#a16400').fontSize(12)
                      // 五行好评   score:100 5星    60 四星     20 二星
                      Rating({ rating: formatRatingScore(item.score), indicator: false })
                        .stars(5)
                        .stepSize(0.5)
                        .size({ width: 80 })
                    }.width('100%')

                    Text(item.content)
                      .fontSize(12)
                      .opacity(0.6)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({ top: 10, bottom: 10 })
                    Row() {
                      // 评论时间格式化
                      Text(formatCommentsTime(item.createdOn)).fontSize(12)
                      Blank()
                      Text() {
                        SymbolSpan($r('sys.symbol.hand_thumbsup_fill'))
                        Span(item.upCount.toString())
                      }.fontSize(12)
                    }.width('100%')
                  }
                  .width('100%')
                  .padding({ top: 10, bottom: 10 })
                  .border({ width: { bottom: 1 }, color: '#fdfdfd', style: BorderStyle.Solid })

                }, (item: CommentsModel) => item.bookId)

              }.padding({ left: 10, right: 10 })

            }
          }
        }
      }
    }
    .title('书籍详情')
    .onReady((context: NavDestinationContext) => {
      this.queryParams = (context?.pathInfo?.param) as DetailsParams;

      // 发送请求
      this.getDetailsData()
    })
  }
}