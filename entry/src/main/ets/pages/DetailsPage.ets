import detailsRequest, {DetailsModel} from '../viewModel/Details'
// 跳转页面入口函数
@Builder
export function DetailsPageBuilder(){
  DetailsPage()
}


class DetailsParams{
  sourceName:string = '';
  sourceId:string = '';

  constructor(sourceName:string, sourceId:string) {
    this.sourceName = sourceName;
    this.sourceId = sourceId;
  }
}

@Component
export default struct DetailsPage{
  // 接受路由传递的数据
  @State queryParams:DetailsParams = new DetailsParams('', '');
  @State detailsInfos:DetailsModel = {
    allWords:0,
    coverUrl:'',
    title:'',
    intro:''
  }


  // 请求函数
  getDetailsData(){
    // 请求书籍的详细信息
    detailsRequest.detailsRequestHandler(`/book?sourceName=${this.queryParams.sourceName}&sourceId=${this.queryParams.sourceId}`).then((res:DetailsModel) => {
        this.detailsInfos = res
    })

    //  请求评论  /top_comments?sourceName=tf&sourceId=yq_10077
  }

  build() {
    NavDestination(){
      Row(){
        Image(this.detailsInfos.coverUrl).width(75).width(100)
        Column(){
          Text(this.detailsInfos.title)
        }
      }

      Text(this.detailsInfos.intro)
    }.onReady((context:NavDestinationContext) => {
      this.queryParams = (context?.pathInfo?.param) as DetailsParams;

       // 发送请求
      this.getDetailsData()
    })
  }
}