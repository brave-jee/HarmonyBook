import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';
import 'dayjs/locale/zh-cn' // 使用本地语言

// 封装一个函数， 对字数进行格式化处理
export function formatWords(words:number){
  return `${parseInt((words/10000).toString())}万字`
}

export function formatUpdateTime(time:number):string{
  dayjs.locale('zh-cn')  // 设置语言
  dayjs.extend(relativeTime) // 扩展插件
  return  '更新于' + dayjs(time).fromNow();
}

