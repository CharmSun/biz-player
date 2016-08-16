require('./css/video.css');
var tpl = require('./tpl/video.tpl');

function try_video() {
    var video = document.createElement("video");
    if (video)  return true;
    return false;
}

/**
 * BizPlayer constructor
 *
 * @constructor
 * @param {Object} [options] 参数
 * @param {Object} [options.el] 目标节点
 * @param {Boolean} [options.autoPlay] 是否自动播放
 * @param {Boolean} [options.loop] 是否循环播放
 * @param {Boolean} [options.useFullScreen] 是否使用全屏
 * @param {width} [options.width] 视频播放器宽度
 * @param {height} [options.height] 视频播放器高度
 * @param {String} [options.src] 视频资源URL
 * @param {String} [options.poster] 视频不播放时的封面图片URL
 * @param {String} [options.clickVideoUrl] 点击视频区域的跳转链接
 * @param {Function} [options.clickVideoFunc] 点击视频要执行的Func
 */
var BizPlayerHtml5 = function(options){
    options = options || {};
    for (var o in options) {
        this[o] = options[o];
    }
    if( try_video() ){
        this.init(options);
        this.progressControl();
        this.playControl();
        this.volumeControl();
        if(this.useFullScreen){
            this.fullScreenControl();
        } else {
            this.el.getElementsByClassName("fullscreen")[0].style.display = "none";
        }
        var video_controls = this.el.getElementsByClassName("video_controls")[0];
        var poster = this.el.getElementsByClassName("video_poster")[0];
        var video_range = this.el.getElementsByClassName("video_range")[0].getElementsByClassName("v_range")[0];
        var video_progress = this.el.getElementsByClassName("video_range")[0].getElementsByClassName("v_progress")[0];
        var down_progress = this.el.getElementsByClassName("video_range")[0].getElementsByClassName("down_progress")[0];
        var playBtn = this.el.getElementsByClassName("play")[0];
        var pauseBtn = this.el.getElementsByClassName("play")[1];
        var bigPlaybtn = this.el.getElementsByClassName("v_bigplaybtn")[0];

        var me = this;
        this.video.addEventListener('loadedmetadata',function(){
            poster.style.display = "none";
            var _t1 = me.video.duration;
            var _t2 = Math.floor(_t1/60)+":"+Math.floor(_t1-Math.floor(_t1/60)*60);
            me.el.getElementsByTagName('em')[1].innerHTML = _t2;
            down_progress.setAttribute("max", Math.floor(_t1));
            video_progress.setAttribute("max", Math.floor(_t1));
            video_range.setAttribute("max", Math.floor(_t1));
        });

        this.video.addEventListener('timeupdate',function(){
            var _t1 = me.video.currentTime;
            var _t2 = Math.floor(_t1/60)+":"+Math.floor(_t1-Math.floor(_t1/60)*60);
            me.el.getElementsByTagName('em')[0].innerHTML = _t2;
            video_progress.value = Math.floor(_t1);
            video_range.value =  Math.floor(_t1);
        });

        this.video.addEventListener('progress',function(){
            if(me.video.buffered.length > 0){
                down_progress.value = me.video.buffered.end(0);
            }
        });

        this.video.addEventListener('playing',function(){
            poster.style.display = "none";
        });

        this.video.addEventListener('ended',function(){
            poster.style.display = "block";
            me.video.currentTime = 0;
            playBtn.style.display = "inline";
            pauseBtn.style.display = "none";
            bigPlaybtn.style.display = "block";
        });
        this.video.addEventListener('click',function(e){
            if(!me.video.paused){
                pauseBtn.click();
            }
            if(me.clickVideoUrl){
                window.open(me.clickVideoUrl);
            }
            if(me.clickVideoFunc){
                me.clickVideoFunc();
            }
            e.stopPropagation();
        });

        this.el.addEventListener('mouseover',function(e){
            video_controls.style.display = "block";
            video_range.style.display = "block";
            me.el.getElementsByClassName("video_range")[0].style.bottom = '32px';
        });
        this.el.addEventListener('mouseout',function(e){
            video_controls.style.display = "none";
            video_range.style.display = "none";
            me.el.getElementsByClassName("video_range")[0].style.bottom = '2px';
        });
        
        if(this.autoPlay){
            playBtn.click();
        }
    }
};

BizPlayerHtml5.prototype = {
    autoPlay: true,
    loop: false,
    useFullScreen: true,
    init: function(options) {
        var videoTemplate = tpl(options);
        this.el.innerHTML = videoTemplate;
        var video = this.el.getElementsByTagName('video')[0];
        if(this.loop){
            video.setAttribute("loop", "loop");
        }
        var mainEl = this.el;
        this.video = video;
        this.video_body = mainEl.getElementsByClassName("video_body")[0];
        
        mainEl.style.width = this.width+"px";
        mainEl.style.height = this.height+"px";
        mainEl.getElementsByClassName("video_body")[0].style.width = this.width+"px";
        mainEl.getElementsByClassName("video_body")[0].style.height = this.height+"px";
        mainEl.getElementsByClassName("video_controls_l")[0].style.width = this.width+"px";
    },
    progressControl: function() {
        var me = this;
        var mainEl = this.el;
        var video_range = mainEl.getElementsByClassName("video_range")[0].getElementsByClassName("v_range")[0];
        var video_progress = mainEl.getElementsByClassName("video_range")[0].getElementsByClassName("v_progress")[0];
        video_range.addEventListener("change",function(e) {
            video_progress.value = this.value;
            me.video.currentTime = this.value;
        });
    },
    volumeControl: function() {
        var me = this;
        var mainEl = this.el;
        var volume_range = mainEl.getElementsByClassName("volume_range")[0];
        var volBtn = mainEl.getElementsByClassName("volume")[0];
        var muteBtn = mainEl.getElementsByClassName("volume")[1];

        volume_range.addEventListener("change",function(e) {
            me.video.volume = Number(this.value)/100;
        });

        var old_volume = volume_range.value;
        volBtn.addEventListener("click",function(e){
            volBtn.style.display = "none";
            muteBtn.style.display = "inline";
            old_volume = volume_range.value;
            volume_range.value = 0;
            me.video.volume = 0;
            e.stopPropagation();
        });
        muteBtn.addEventListener("click",function(e){
            muteBtn.style.display = "none";
            volBtn.style.display = "inline";
            volume_range.value = old_volume;
            me.video.volume = Number(old_volume)/100;
            e.stopPropagation();
        });
    },
    playControl: function(){
        var me = this;
        var mainEl = this.el;
        var playBtn = mainEl.getElementsByClassName("play")[0];
        var pauseBtn = mainEl.getElementsByClassName("play")[1];
        var bigPlaybtn = mainEl.getElementsByClassName("v_bigplaybtn")[0];
        playBtn.addEventListener("click",function(e){
            playBtn.style.display = "none";
            pauseBtn.style.display = "inline";
            if(me.video.paused){
                bigPlaybtn.style.display = "none";
                me.video.play();
            }
            e.stopPropagation();
        });
        pauseBtn.addEventListener("click",function(e){
            playBtn.style.display = "inline";
            pauseBtn.style.display = "none";
            if(!me.video.paused){
                bigPlaybtn.style.display = "block";
                me.video.pause();
            }
            e.stopPropagation();
        });

        bigPlaybtn.addEventListener("click",function(e){
            playBtn.style.display = "none";
            pauseBtn.style.display = "inline";
            if(me.video.paused){
                this.style.display = "none";
                me.video.play();
            }
            e.stopPropagation();
        });
    },
    fullScreenControl: function() {
        var me = this;    
        var fsBtn = this.el.getElementsByClassName("fullscreen")[0];
        fsBtn.addEventListener("click", function(e) {
            me.toggleFullScreen();
            e.stopPropagation();
        });
    },
    toggleFullScreen: function(){
        var me = this;        
        if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) { 
            var elm = document.documentElement;
            if (elm.requestFullscreen) elm.requestFullscreen();
            else if (elm.mozRequestFullScreen) elm.mozRequestFullScreen();
            else if (elm.webkitRequestFullScreen) elm.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
            me.video_body.style.width = window.screen.width+"px";
            me.video_body.style.height = window.screen.height+"px";
            me.video_body.style.position = "absolute";
            me.video_body.style.top = "0px";
            me.video_body.style.left = "0px";
            me.video.style.width = window.screen.width+"px";
            me.video.style.height = window.screen.height+"px";
            me.video.style.position = "absolute";
            me.video.style.top = "0px";
            me.video.style.left = "0px";
        }
        else{
            if (document.cancelFullScreen) document.cancelFullScreen();
            else if (document.mozCancelFullScreen) document.mozCancelFullScreen();
            else if (document.webkitCancelFullScreen) document.webkitCancelFullScreen();
            me.video_body.style.width = me.width+"px";
            me.video_body.style.height = me.height+"px";
            me.video_body.style.position = "relative";
            me.video_body.style.top = -me.height + "px";
            me.video_body.style.left = "0px";
            me.video.style.width = me.width+"px";
            me.video.style.height = me.height+"px";
            me.video.style.position = "relative";
            me.video.style.top = "0px";
            me.video.style.left = "0px";
        }
        this.el.getElementsByClassName("video_controls_l")[0].style.width = me.video_body.style.width;
    }
};

module.exports = BizPlayerHtml5;