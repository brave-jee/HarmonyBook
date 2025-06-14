import chaptersRequest, { ChaptersModel, ChaptersListModel } from '../viewModel/Chapters'
import {formatChaptersList, FormateChapterModel} from '../utils/tools'
// 跳转页面入口函数
@Builder
export function ChaptersPageBuilder() {
  ChaptersPage()
}

class ChapterQuery {
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
struct ChaptersPage {
  @State chapterQuery: ChapterQuery = new ChapterQuery('', '')
  @State chaptersData: ChaptersModel = {
    bookTitle: '',
    chapterSize: 0,
    chapters: [],
    page:0,
  }
  @State selectText:string = '' ; // 存储下拉菜单选中内容
  @State selectIndex:number = 0; // 存储下拉菜单选中项的索引值
  @State chapterList:Array<FormateChapterModel> = []; // 存储章节分页

  getChaptersList(page:number = 0) {
    chaptersRequest.ChaptersRequestHandler(`/chapters?sourceName=${this.chapterQuery.sourceName}&sourceId=${this.chapterQuery.sourceId}&page=${page}`)
      .then(res => {
        this.chaptersData = res;
        this.chapterList = formatChaptersList(this.chaptersData.chapterSize)
        // 设置下拉菜单的选中项内容
        this.selectText = this.chapterList[res.page].value
      })
  }

  getChaptersPageList() {
    chaptersRequest.ChaptersRequestHandler(`/chapters?sourceName=${this.chapterQuery.sourceName}&sourceId=${this.chapterQuery.sourceId}&chapterId=${this.chapterQuery.chapterId}}`)
      .then(res => {
        this.chaptersData = res;
        this.chapterList = formatChaptersList(this.chaptersData.chapterSize)
        // 设置下拉菜单的选中项内容
        this.selectText = this.chapterList[res.page].value
      })
  }



  build() {
    NavDestination() {
      Row() {
        Text(`共${this.chaptersData.chapterSize}章`)
        Select(this.chapterList)
          .value(this.selectText)
          .selected(this.selectIndex)
          .onSelect((index:number, value:string) => {
            this.selectIndex = index;
            this.getChaptersList(index)
          })
      }
      .width('100%')
      .height(40)
      .padding({left:15, right:15})
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor('#f9f9f9').zIndex(5)

      Scroll() {
        Column() {
          ForEach(this.chaptersData.chapters, (item: ChaptersListModel) => {
            Text(item.chapterTitle)
              .width('100%')
              .height(47)
              .textAlign(TextAlign.Start)
              .padding({ left: 15 })
              .border({ width: { bottom: 1 }, style: BorderStyle.Solid, color: "#f9f9f9" })
          })
        }
      }

    }.onReady((context: NavDestinationContext) => {
      this.chapterQuery = context.pathInfo.param as ChapterQuery;
      // 发送请求
      if(this.chapterQuery.chapterId){
        this.getChaptersPageList()
      }else{
        this.getChaptersList()
      }
    })
  }
}