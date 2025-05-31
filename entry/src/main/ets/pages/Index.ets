import homeRequest, { BannerList, ChannelList, BookList } from '../viewModel/Home'
import BookItem from '../components/BookItem'

@Entry
@Component
struct Index {
  @State bannerList: Array<BannerList> = [];
  @State channelList: Array<ChannelList> = [];

  aboutToAppear(): void {
    homeRequest.homeRequestHandler('/book_mall?ctype=2&seed=903&page=0').then(res => {
      this.bannerList = res.bannerList;
      this.channelList = res.channelList;
    })
  }

  build() {
    Scroll() {
      Column() {
        Text('淘小说书城').textAlign(TextAlign.Start).width('100%').padding({ left: 15 })

        // 轮播
        Swiper() {
          ForEach(this.bannerList, (item: BannerList) => {
            Image(item.bannerUrl)
          })
        }
        .height(100)
        .width('100%')
        .padding({ left: 15, right: 15 })
        .loop(true)
        .autoPlay(true)

        // 分类导航
        Row() {
          Column() {
            // 引用 resource 资源的固定方式： $r('app.media.图片名')
            Image($r('app.media.rank')).width(30).height(30)
            Text('榜单')
          }

          Column() {
            // 引用 resource 资源的固定方式： $r('app.media.图片名')
            Image($r('app.media.book_end')).width(30).height(30)
            Text('完结')
          }

          Column() {
            // 引用 resource 资源的固定方式： $r('app.media.图片名')
            Image($r('app.media.free')).width(30).height(30)
            Text('免费')
          }

          Column() {
            // 引用 resource 资源的固定方式： $r('app.media.图片名')
            Image($r('app.media.new')).width(30).height(30)
            Text('新书')
          }

          Column() {
            // 引用 resource 资源的固定方式： $r('app.media.图片名')
            Image($r('app.media.category')).width(30).height(30)
            Text('分类')
          }
        }.width('100%').justifyContent(FlexAlign.SpaceAround).padding({ top: 10, bottom: 10 })

        // 分类推荐
        Column() {
          // ArkTs的列表渲染
          ForEach(this.channelList, (item: ChannelList, index: number) => {
            // 分类标题
            Row() {
              Row() {
              }.width(3).height(15).backgroundColor('#ffbb1b').margin({ left: 5, right: 10 })

              Text(item.title).fontWeight(900).fontSize(16).fontColor('#000')
              Blank()
              Text('查看更多').fontSize(14).fontColor('#2e2e2e').opacity(0.6)
              Text() {
                // 字体图标   $r('sys.symbol.图标名')
                SymbolSpan($r('sys.symbol.chevron_right'))
              }.margin({ right: 15, left: 8 }).fontSize(14).fontColor('#2e2e2e').opacity(0.6)
            }
            .width('100%')
            .height(60)

            // 分类内容
            if (index === 0) {
              List({ space: 10 }) {
                ForEach(item.bookList, (book: BookList) => {
                  ListItem() {
                    Column() {
                      Image(book.coverUrl).width(75).height(100)
                      Text(book.title)
                        .fontSize(14)
                        .fontColor('#2e2e2e')
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .maxLines(1)
                        .margin({ top: 15, bottom: 6 })

                      Text(book.authorName)
                        .fontSize(12)
                        .fontColor('#2e2e2e')
                        .opacity(0.6)
                    }.width(75)
                  }
                }, (book: BookList) => book.sourceId)
              }.listDirection(Axis.Horizontal).width('100%').padding({ left: 10, right: 10 }).height(150)
            } else {
              ForEach(item.bookList, (book: BookList) => {
                // 组件通信
                BookItem({ bookList: book })
              }, (book: BookList) => book.sourceId)

            }

          }, (item: ChannelList) => item.title)


        }

      }
    }
  }
}