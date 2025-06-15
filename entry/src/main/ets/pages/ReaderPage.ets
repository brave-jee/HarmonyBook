import readerRequest, { ReaderChapterModel } from '../viewModel/Reader'
import {BookListModel} from './Index'
// 跳转页面入口函数
@Builder
export function ReaderPageBuilder() {
  ReaderPage()
}
// 阅读参数
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
// 章节参数
class ChapterParams {
  sourceName: string = '';
  sourceId: string = '';
  chapterId: string = '';

  constructor(sourceName: string, sourceId: string,chapterId: string) {
    this.sourceName = sourceName;
    this.sourceId = sourceId;
    this.chapterId = chapterId;
  }
}

interface ThemeModel {
  bgColor: string;
  fontColor: string;
  fontSize?:number;
}

@Entry
@Component
struct ReaderPage {
  // 接受路由对象
  @Consume('pageInfos') pageInfos: NavPathStack;
  // 引入本地存储
  @LocalStorageLink('bookList') bookList:Array<BookListModel> = [];
  // 创建滚动对象  控制页面的滚动效果
  scroller: Scroller = new Scroller()
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
  // 默认的主题色
  // @State bgColorDefault: string = '#f0ebe2'; // 默认的主题背景色
  // @State fontColorDefault: string = 'rgb(46, 46, 46)'; // 字体颜色
  @State defaultColor:ThemeModel = {
    bgColor:'#f0ebe2',
    fontColor:'rgb(46, 46, 46)',
    fontSize:19
  }
  // 动态改变设置的主题色
  @State bgColor:string = '#f0ebe2';
  @State fontColor:string = 'rgb(46, 46, 46)';
  @State fontSize:number = 19;


  @State isShow: boolean = false;
  // 定义主题数据列表
  @State themeList: Array<ThemeModel> = [
    {
      bgColor: '#fff',
      fontColor: '#000'
    },
    {
      bgColor: 'rgb(237, 217, 189)',
      fontColor: 'rgb(82, 46, 30)'
    },
    {
      bgColor: 'rgb(252, 222, 222)',
      fontColor: 'rgb(205, 53, 100)'
    },
    {
      bgColor: 'rgb(212, 229, 198)',
      fontColor: 'rgb(88, 105, 89)'
    },
    {
      bgColor: 'rgb(1, 1, 1)',
      fontColor: 'rgb(140, 140, 140)'
    }
  ]

  // 菜单
  @Builder
  NavigationMenus() {
    Row() {
      Text() {
        SymbolSpan($r('sys.symbol.gearshape'))
      }.margin({ right: 15 })
      .fontSize(24)
      .onClick(() => {
        this.isShow = true;
      })
    }
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  getFirstChapter() {
    readerRequest.ReaderRequestHandler(`/chapter_content?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}`)
      .then(res => {
        this.readerData = res;
        // 记录阅读书籍的记录
        this.recordBooklist()
      })
  }
  // 存在章节ID
  getOtherChapter() {
    // 请求新一页的数据时， 返回顶部
    this.scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: { duration: 500, curve: Curve.EaseIn } })
    readerRequest.ReaderRequestHandler(`/chapter_content?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}&chapterId=${this.queryParams.chapterId}`)
      .then(res => {
        this.readerData = res;
        // 记录阅读书籍的记录
        this.recordBooklist()
      })
  }

  recordBooklist(){
    //  判断是否阅读过该书籍  读过  更新书籍， 没有读过， 添加记录
    // some() 方法返回的结果是一个布尔值， true 满组条件， false 不满足
    let isExitBook = this.bookList.some(item => item.sourceId === this.readerData.sourceId)
    //  条件成立  存在
    if(isExitBook){
      // 更新数据
      let index = this.bookList.findIndex(item => item.sourceId === this.readerData.sourceId)
      this.bookList.splice(index, 1, {
        sourceId: this.readerData.sourceId,
        chapterId:this.readerData.chapterId
      })
    }else{
      // 添加新纪录
      this.bookList.push({
        sourceId: this.readerData.sourceId,
        chapterId:this.readerData.chapterId
      })
    }
  }

  build() {
    NavDestination() {
      // 层叠布局 ：  定位布局
      Stack({ alignContent: Alignment.TopStart }) {
        // 控制主题的弹窗
        if (this.isShow) {
          Column() {
            Row() {
              Text('字号')
                .fontSize(13)
                .width(30)
              Row() {
                Text('A-')
                  .fontSize(18)
                  .textAlign(TextAlign.Center)
                  .width(137)
                  .height(34)
                  .border({ width: 1, style: BorderStyle.Solid, color: '#aaa' })
                  .onClick(() => {
                    if(this.fontSize > 10){
                        this.fontSize -= 2;
                    }
                  })

                Text('A+')
                  .fontSize(18)
                  .textAlign(TextAlign.Center)
                  .width(137)
                  .height(34)
                  .border({ width: 1, style: BorderStyle.Solid, color: '#aaa' })
                  .onClick(() => {
                    if(this.fontSize < 62){
                      this.fontSize += 2;
                    }
                  })
              }.width(280)
              .justifyContent(FlexAlign.SpaceBetween)
            }

            Row() {
              Text('背景').fontSize(13).width(30)
              Row() {
                ForEach(this.themeList, (item: ThemeModel) => {
                  Text()
                    .width(51)
                    .height(34)
                    .border({ width: 1, style: BorderStyle.Solid, color: '#ccc' })
                    .backgroundColor(item.bgColor)
                    .onClick(() => {
                        this.bgColor = item.bgColor;
                        this.fontColor = item.fontColor;
                    })
                })

              }
              .width(280)
              .justifyContent(FlexAlign.SpaceBetween)
            }.margin({ top: 15 })

            Row() {
              Text('恢复到默认')
                .fontColor('#ffbb1b')
                .margin({ top: 20 })
                .onClick(() => {
                  this.bgColor = this.defaultColor.bgColor;
                  this.fontColor = this.defaultColor.fontColor;
                  this.fontSize = this.defaultColor.fontSize as number;
                })
            }
          }
          .width('100%')
          .padding({
            top: 20,
            bottom: 20,
            left: 21,
            right: 21
          })
          .backgroundColor('#fff')
          .zIndex(3)
        }
        // 阅读内容
        Scroll(this.scroller) {
          Column() {
            Text(this.readerData.chapterTitle)
              .fontSize(27)
              .fontColor(this.fontColor)
              .margin({ bottom: 30, top:50 })
            Text(this.readerData.content)
              .fontSize(this.fontSize)
              .fontColor(this.fontColor)
              .lineHeight(this.fontSize * 2)
            Row() {
              Text() {
                SymbolSpan($r('sys.symbol.chevron_left'))
                Span('上一章')
              }
              .width(102)
              .height(35)
              .border({ width: 1, style: BorderStyle.Solid, color: "#999" })
              .textAlign(TextAlign.Center)
              .onClick(() => {
                if (this.readerData.prevChapterId) {
                  this.queryParams =
                    new ReaderParams(this.readerData.sourceName, this.readerData.sourceId,
                      this.readerData.prevChapterId)

                  this.getOtherChapter()
                }
              })

              Text() {
                SymbolSpan($r('sys.symbol.list_bullet'))
                Span('目录')
              }.width(102)
              .height(35)
              .textAlign(TextAlign.Center)
              .border({ width: 1, style: BorderStyle.Solid, color: "#999" })
              .onClick(() => {
                this.pageInfos.pushPath({name:"ChaptersPage", param:new ChapterParams(this.readerData.sourceName, this.readerData.sourceId, this.readerData.chapterId)})
              })

              Text() {
                SymbolSpan($r('sys.symbol.chevron_right'))
                Span('下一章')
              }
              .width(102)
              .height(35)
              .textAlign(TextAlign.Center)
              .backgroundColor('#ffbb1b')
              .border({ width: 1, style: BorderStyle.Solid, color: "#999" })
              .onClick(() => {
                if (this.readerData.nextChapterId) {
                  this.queryParams =
                    new ReaderParams(this.readerData.sourceName, this.readerData.sourceId,
                      this.readerData.nextChapterId)

                  this.getOtherChapter()
                }
              })
            }
            .border({ width: { top: 2 }, style: BorderStyle.Solid, color: '#8c8c8c' })
            .padding({ top: 40 })
            .margin({top:20, bottom:30})
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .backgroundColor(this.bgColor)
          .padding({ left: 15, right: 15 })
          .onClick(() => {
            this.isShow = false;
          })
        }.width('100%').margin({ top: 0 })

      }
    }
    .menus(this.NavigationMenus)
    .onReady((context: NavDestinationContext) => {
      this.queryParams = (context?.pathInfo?.param) as ReaderParams;

      if(this.queryParams.chapterId){
        this.getOtherChapter()
      }else{
        // 发送请求
        this.getFirstChapter()
      }
    })
  }
}