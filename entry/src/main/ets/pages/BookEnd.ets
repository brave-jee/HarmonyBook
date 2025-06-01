// 跳转页面入口函数
@Builder
export function BookEndBuilder(){
  BookEnd()
}

@Component
export default struct BookEnd{
  build() {
    NavDestination(){
      // 这里写页面的布局
      Text('这是完结页面')
    }
  }
}