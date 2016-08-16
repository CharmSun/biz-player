# biz-player - A web video player supported with flash and Html5

## 特性
* CommonJS的模块规范
* 支持Html5, Flash视频播放技术, 根据需要选择HTML5或Flash
* 支持PC各平台，可支持多种浏览器兼容，如IE6/7/8/9/10, Chrome, Firefox等

## 目录文件说明
	\as                      Flash播放器源代码
	\dist                    构建的输出目录
	\dist\BizPlayer.swf      Flash播放主文件 
	\examples                使用示例
	\src                     源代码目录
	\src\BizPlayerHtml5.js   Html5播放器代码模块
	\webpack.config.js       webpack配置文件

## 使用方式
在你的HTML页面中引入css和js文件：

    <link rel="stylesheet" type="text/css" href="biz-player.css" />
    <script type="text/javascript" src="biz-player.js"></script>

或者在CommonJS模块中这样引用：

    var BizPlayer = require('biz-player');

实例化：

	var player = new BizPlayer('biz-player');

使用Flash播放器：

	player.createFlashVideo({
		autoPlay: false,
		useFullScreen: false,
		width:514,
	    height:314,
	    swfUrl: "../dist/BizPlayer.swf",
		src: "http://biz.sogoucdn.com/pz/test.mp4",
		poster: "http://biz.sogoucdn.com/pz/bg514x314.jpg",
		clickVideoUrl: "http://www.sogou.com",
		clickVideoFunc: "jsFunc"
	});
*需要注意这里的clickVideoFunc传入的是要调用的方法名，是字符串。*

使用Html5播放器：

	player.createH5Video({
		autoPlay: false,
		useFullScreen: false,
		width:514,
	    height:314,
		src: "http://biz.sogoucdn.com/pz/test.mp4",
		poster: "http://biz.sogoucdn.com/pz/bg514x314.jpg",
		clickVideoUrl: "http://www.sogou.com",
		clickVideoFunc: function() {
			alert("Hello，I'm BizPlayer!");
		}
	});

## TODO
1. Html5播放器的样式在Chrome，FireFox，IE下不完全一致
2. 未在移动平台下使用过，有必要可做兼容

## License
Licensed under the [MIT license](http://opensource.org/licenses/MIT).

