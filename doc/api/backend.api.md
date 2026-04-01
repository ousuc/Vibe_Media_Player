# 简要介绍  Introduction
本文档定义 C++ 后端暴露给 QML 前端的接口   
假设你是打算创建类 PlayerController 暴露给ui使用  

或者说，这个其实就是按照这种模式》？
## 模式

## PlayerController对应的属性
| 属性名 | 类型 | 可读 | 可写 | 说明 | 更新信号 |
|-----------------|---------|---|---|-------------------|----------------|
| isPlaying       | boolean | t | f | 是否在播放          | playingChanged | 
| duration        | int     | t | f | 总持续时间长度（ms）  |  undefined     |
| durationString  | QString | t | f | 总持续时长（mm：ss）  |  undefined    |         
| currentFileName | QString | t | f | 当前文件名          | mediaLoaded    |
| isMediaLoaded   | bool    | t | f | 是否已加载文件       | mediaLoaded    |
| position        | int     | t | f | 当前位置（毫秒）     | positionChanged |
| positionString  | QString | t | f | 当前位置（mm:ss）   | positionChanged |
| positionPercent | int     | t | f | 进度百分比 0-100    | positionChanged |
| volume          | int     | t | t | 音量 0-100         | volumeChanged   |
> 注意： 其中的 mm:ss 是一个单位，你需要通过duration进行转换
> 就是将duration的ms 转换为这种  分：秒 的形式

## PlayerController需要的方法
|方法名	      |参数	 | 返回值	 | 说明	 |例子|
|-----------------------|-------|-----|-------------|-----------------------------------|
|loadFile(url)          |QUrl	  |void |加载音频文件	  |player.loadFile(fileDialog.fileUrl)|
|play()	                |无	    |void	|播放	        |player.play()                      |
|pause()	              |无	    |void |暂停	        |player.pause()                     |
|stop()	                |无	    |void	|停止	        |player.stop()                      |
|playPause()            |无	    |void	|播放/暂停切换	|player.playPause()                 |
|setPosition(ms)	      |qint64	|void	|跳转到指定毫秒	|player.setPosition(30000)          |
|setPositionPercent(pct)|int	  |void	|按百分比跳转	  |player.setPositionPercent(50)      |
|setVolume(vol)	        |int	  |void	|设置音量	    |player.setVolume(80)               |
可以根据具体情况进行修改

## 需要使用的宏
1. QML_ELEMENT, 直接自动注册C++后端代码给这个前端看(位置上和这个Q_OBJECT相邻)
2. Q_INVOKABLE, 将函数注册，让QML前端可以调用(位置在函数返回值前)

## 调用服务顺序（QML前端查看）
1. loadFile()  → 加载文件
2. play()      → 开始播放
3. pause()     → 暂停
4. play()      → 继续播放
5. stop()      → 停止

