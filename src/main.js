require('./dep/swfobject');
var BizPlayerHtml5 = require('./BizPlayerHtml5');


/**
 * BizPlayer constructor
 *
 * @constructor
 * @param {String} [divId] 目标div的Id
 */
var BizPlayer = function(divId){
    this.divId = divId || '';
    this.el = document.getElementById( this.divId );
    if( !this.el ){
    	return;
    }
};

BizPlayer.prototype = {

	try_h5: function() {
		var video = document.createElement("video");
	    if (video)  return true;
	    return false;
	},


	/**
	 * @param {Object} [options] 参数
	 * @param {Boolean} [options.autoPlay] 是否自动播放
	 * @param {Boolean} [options.loop] 是否循环播放
	 * @param {Boolean} [options.useFullScreen] 是否使用全屏
	 * @param {Boolean} [options.autoRewind] 播放完是否自动回退
	 * @param {Boolean} [options.autoHideBar] 是否自动隐藏控制条
	 * @param {width} [options.width] 视频播放器宽度
	 * @param {height} [options.height] 视频播放器高度
	 * @param {String} [options.src] 视频资源URL
	 * @param {String} [options.poster] 视频不播放时的封面图片URL
	 * @param {String} [options.clickVideoUrl] 点击视频区域的跳转链接
	 * @param {String} [options.clickVideoFunc] 点击flash视频要执行的Func的方法名
	 */
	createFlashVideo: function(options) {
		var flashvars = {
			autoPlay: options.autoPlay,
			loop: options.loop,
			autoRewind: options.autoRewind,
			autoHideBar: options.autoHideBar,
			useFullScreen: options.useFullScreen,
			src: options.src || '',
			poster: options.poster || '',
			clickVideoUrl: options.clickVideoUrl || '',
			clickVideoFunc: options.clickVideoFunc || '' 
		};
        var params = {};
        params.quality = "high";
        params.wmode = "opaque";
        params.allowscriptaccess = "always";
        params.allowfullscreen = "" + flashvars.useFullScreen;
        var attributes = {
            id: this.divId + "-obj",
            name: this.divId + "-obj"
        };
        
        this.el.innerHTML = '<div id="' + attributes.id + '"></div>';
         
        swfobject.embedSWF(
            "BizPlayer.swf", 
            attributes.id,
            options.width, 
            options.height,
            "11.4.0", 
            "playerProductInstall.swf",
            flashvars,
            params, 
            attributes
        );
        return document.getElementById(attributes.id);
	},

	/**
	 * @param {Object} [options] 参数
	 * @param {Boolean} [options.autoPlay] 是否自动播放
	 * @param {Boolean} [options.loop] 是否循环播放
	 * @param {Boolean} [options.useFullScreen] 是否使用全屏
	 * @param {Boolean} [options.autoHideBar] 是否自动隐藏控制条
	 * @param {width} [options.width] 视频播放器宽度
	 * @param {height} [options.height] 视频播放器高度
	 * @param {String} [options.src] 视频资源URL
	 * @param {String} [options.poster] 视频不播放时的封面图片URL
	 * @param {String} [options.clickVideoUrl] 点击视频区域的跳转链接
	 * @param {Function} [options.clickVideoFunc] 点击flash视频要执行的Func的方法名
	 */
	createH5Video: function(options) {
		var h5Video = new BizPlayerHtml5({
            el: this.el,
            autoPlay: options.autoPlay,
			loop: options.loop,
			useFullScreen: options.useFullScreen,
			width: options.width,
			height: options.height,
            src: options.src || '',
            poster: options.poster || '',
            clickVideoUrl: options.clickVideoUrl || '',
            clickVideoFunc: options.clickVideoFunc
        });
        return h5Video;
	}

};

window.BizPlayer = BizPlayer;

module.exports = BizPlayer;
