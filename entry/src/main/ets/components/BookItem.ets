import {BookList} from '../viewModel/Home'
@Component
export default struct BookItem{
  @Prop bookList:BookList = {
    title:'', // 书名
    authorName:'', // 作者
    coverUrl:'', // 封面
    intro:'', // 简介
    allWords:0, // 字数
    categoryName:'', // 分类
    status:0, // 50：完结 ； 30：连载
    sourceId:'', // 资源id
    sourceName:'' // 资源名
  }
  // 封装一个函数， 对字数进行格式化处理
  formatWords(words:number){
      return `${parseInt((words/10000).toString())}万字`
  }

  build() {
    Row(){
      Image(this.bookList.coverUrl).width(75).height(100)
      Blank()
      Column(){
        // 标题
        Text(this.bookList.title)
          .fontSize(14)
          .fontColor('#2e2e2e')
          .fontWeight(900)
          .margin({bottom:10})
          .width('100%')
          .textAlign(TextAlign.Start)
        // 简介
        Text(this.bookList.intro)
          .fontSize(12)
          .fontColor('#2e2e2e')
          .opacity(0.6)
          .textOverflow({overflow:TextOverflow.Clip})
          .maxLines(2)
          .margin({bottom:10})
        // 作者等信息
        Row(){
          Text(this.bookList.authorName)
            .fontSize(12)
            .fontColor('#2e2e2e')
            .opacity(0.6)
          Blank()
          Text(this.formatWords(this.bookList.allWords))
            .fontSize(12)
            .fontColor('#2e2e2e')
            .opacity(0.6)
            .margin({left:10})
          Text(this.bookList.categoryName)
            .fontSize(12)
            .fontColor('#2e2e2e')
            .opacity(0.6)
            .margin({left:10})
          Text(this.bookList.status === 50 ? '完结' : '连载')
            .fontSize(12)
            .fontColor(this.bookList.status === 50 ? '#ff9000' : '#1ba1ff')
            .backgroundColor(this.bookList.status === 50 ? 'rgba(255, 187, 27, 0.2)' : 'rgba(76, 161, 255, 0.2)')
            .padding({left:6, right:6})
            .margin({left:10})

        }.width(255)
      }.width(255).margin({left:10})
    }
      .width('100%')
      .padding(15)
      .border({width:{bottom:1}, style:BorderStyle.Solid, color:'#ededed' })
  }
}