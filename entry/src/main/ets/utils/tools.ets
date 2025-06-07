import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';
import 'dayjs/locale/zh-cn' // 使用本地语言
// 导入文本计算模块
import { MeasureText } from '@kit.ArkUI'

// 封装一个函数， 对字数进行格式化处理
export function formatWords(words:number){
  return `${parseInt((words/10000).toString())}万字`
}
// 格式化更新时间
export function formatUpdateTime(time:number):string{
  dayjs.locale('zh-cn')  // 设置语言
  dayjs.extend(relativeTime) // 扩展插件
  return  '更新于' + dayjs(time).fromNow();
}

// 格式化评论时间
export function formatCommentsTime(time:number):string{
  return dayjs(time).format('YYYY-MM-DD HH:MM')
}

// 五星好评  评分格式化   score:  100 5星    60 四星      20 二星
export function formatRatingScore(score:number):number{
  let degree = 0;
  // 0-20  一星
  // 20-40 二星
  // 40-60 三星
  // 60-80 四星
  // 80 -100 五星
  if(score >= 80){
    degree = 5;
  }else if(score >= 60){
    degree = 4;
  }else if(score >= 40){
    degree = 3;
  }else if(score >= 20){
    degree = 2;
  }else {
    degree = 1;
  }
  return degree;
}

// 文本展开函数封装
// 格式化文本中的换行和空格
export function formatBookIntro(text:string):string{
    return text.replace(/\s*/g, '')
}

/**
 * 文本展开折叠效果  返回结果对象
 */
export class TextResult {
  clipTitle:string = '';  // 默认展示的内容
  isMore:boolean = true;  // 判断是否存在更多的内容  true 存在；  false 不存在

  constructor(clipTitle:string, isMore:boolean) {
    this.isMore = isMore;
    this.clipTitle = clipTitle;
  }
}
// 折叠方法  文本展开效果  isCollapse  是否进行文本高度的计算
export const textCollapse = (text: string, isCollapse?: boolean) => {
  // 对文本中的空白符进行处理
  text = formatBookIntro(text);
  // 如果用户点击展开按钮  则直接返回 不需要计算
  if(isCollapse){
    return new TextResult(text, false)
  }

  // 内容简介  默认形况下， 是需要进行文本高度计算   即获取整体内容的高度
  let textCollapseSize: SizeOptions = MeasureText.measureTextSize({
    textContent: text,
    constraintWidth: 345,
    fontSize: 16
  })
  // 多行  即默认指定显示的行数的高度， 比如8行以内显示， 超过8行则折叠
  let textEightCollapseSize: SizeOptions = MeasureText.measureTextSize({
    textContent: text,
    constraintWidth: 345,
    fontSize: 16,
    maxLines: 8
  })

  let clipTitle = text; // 处理的截断文本
  // 判断是否需要折叠
  if (Number(textCollapseSize.height) > Number(textEightCollapseSize.height)) {
    // 需要展开效果
    while (Number(textCollapseSize.height) > Number(textEightCollapseSize.height)) {
      clipTitle = clipTitle.substring(0, clipTitle.length - 1); //每减少一个字符都要进行计算
      textCollapseSize = MeasureText.measureTextSize({
        textContent: clipTitle + '...' + '展开更多', // 按钮文字进行计算
        constraintWidth: 345,
        fontSize: 16
      })
    }
    return new TextResult(clipTitle, true)  // 返回处理的结果， true 意味着折叠， 需要展开
  } else {
    // 完全显示
    return new TextResult(clipTitle, false) // 后续不需要点击展开操作
  }
}



