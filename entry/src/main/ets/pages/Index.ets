import homeRequest,{BannerList} from '../viewModel/Home'

@Entry
@Component
struct Index {
  @State bannerList:Array<BannerList> = []
  aboutToAppear(): void {
    homeRequest.homeRequestHandler('/book_mall?ctype=2&seed=903&page=0').then(res => {
        this.bannerList = res.bannerList
    })
  }

  build() {
    Column(){
      Text('淘小说书城').textAlign(TextAlign.Start).width('100%').padding({left:15})

      // 轮播
      Swiper(){
       ForEach(this.bannerList, (item:BannerList) => {
         Image(item.bannerUrl)
       })
      }.height(100).width('100%').padding({left:15, right:15}).loop(true).autoPlay(true)

      // 分类导航
      Row(){
        Column(){
          // 引用 resource 资源的固定方式： $r('app.media.图片名')
          Image($r('app.media.rank')).width(30).height(30)
          Text('榜单')
        }
        Column(){
          // 引用 resource 资源的固定方式： $r('app.media.图片名')
          Image($r('app.media.book_end')).width(30).height(30)
          Text('完结')
        }
        Column(){
          // 引用 resource 资源的固定方式： $r('app.media.图片名')
          Image($r('app.media.free')).width(30).height(30)
          Text('免费')
        }
        Column(){
          // 引用 resource 资源的固定方式： $r('app.media.图片名')
          Image($r('app.media.new')).width(30).height(30)
          Text('新书')
        }
        Column(){
          // 引用 resource 资源的固定方式： $r('app.media.图片名')
          Image($r('app.media.category')).width(30).height(30)
          Text('分类')
        }
      }.width('100%').justifyContent(FlexAlign.SpaceAround).padding({top:10, bottom:10})
    }
  }
}