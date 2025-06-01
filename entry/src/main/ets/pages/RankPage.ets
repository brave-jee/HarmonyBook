// 跳转页面入口函数
@Builder
export function RankPageBuilder(){
  RankPage()
}

@Entry
@Component
struct RankPage {
  build() {
    NavDestination(){
      Button('这是一个按钮')
    }
  }
}