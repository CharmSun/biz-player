package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	
	import controls.ControlBar;
	import controls.ProgressBar;
	
	import org.osmf.elements.ImageElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutMetadata;
	import org.osmf.layout.ScaleMode;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;

	
	
	[SWF(backgroundColor="0x000000", frameRate="25")]
	public class BizPlayer extends Sprite
	{
		private var mps:MediaPlayerSprite = new MediaPlayerSprite();
		private var mp:MediaPlayer = mps.mediaPlayer ;
		
		private var controlBar:ControlBar;
		private var progressBar:ProgressBar;
		
		private var flashVars:Object;
		
		public function BizPlayer()
		{
			Security.allowDomain("*");
			getFlashVars();
			init();
			loadPlayer();
			creatControls();
			if(flashVars.autoHideBar){
				addEventListener(MouseEvent.MOUSE_OVER, showControlBar);
				addEventListener(MouseEvent.MOUSE_OUT, hideControlBar);
			}
		}
		
		private function getFlashVars():void
		{
			flashVars = root.loaderInfo.parameters;
			if(flashVars.autoPlay == null || flashVars.autoPlay == "undefined"){
				flashVars.autoPlay = true;
			}else {
				flashVars.autoPlay = (flashVars.autoPlay == "true");
			}
			
			if(flashVars.loop == null || flashVars.loop == "undefined"){
				flashVars.loop = false;
			}else {
				flashVars.loop = (flashVars.loop == "true");
			}
			
			if(flashVars.autoRewind == null || flashVars.autoRewind == "undefined"){
				flashVars.autoRewind = true;
			}else {
				flashVars.autoRewind = (flashVars.autoRewind == "true");
			}
			
			if(flashVars.useFullScreen == null || flashVars.useFullScreen == "undefined"){
				flashVars.useFullScreen = true;
			}else {
				flashVars.useFullScreen = (flashVars.useFullScreen == "true");
			}
			
			if(flashVars.autoHideBar == null || flashVars.autoHideBar == "undefined"){
				flashVars.autoHideBar = true;
			}else {
				flashVars.autoHideBar = (flashVars.autoHideBar == "true");
			}
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			mps.mediaContainer.layoutMetadata.width = stage.stageWidth;
			mps.mediaContainer.layoutMetadata.height = stage.stageHeight;
			mps.mediaContainer.layoutMetadata.scaleMode = ScaleMode.NONE;
			mps.buttonMode = true;
			addChild( mps );
		}
		
		private function loadPlayer():void
		{	
			mp.autoPlay = flashVars.autoPlay;
			mp.autoRewind = flashVars.autoRewind;
			mp.loop = flashVars.loop;
			
			var videoElement:VideoElement = new VideoElement( new URLResource(flashVars.src) );
			var videoLayout:LayoutMetadata = new LayoutMetadata();
			videoLayout.scaleMode = ScaleMode.ZOOM;
			videoLayout.verticalAlign = VerticalAlign.MIDDLE;
			videoLayout.horizontalAlign = HorizontalAlign.CENTER;
			videoLayout.percentWidth = 100;
			videoLayout.percentHeight = 100;
			videoElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, videoLayout);
			
			if(flashVars.poster != null && flashVars.poster.length > 0) {
				var posterElement:ImageElement = new ImageElement( new URLResource(flashVars.poster) );
				var posterLayout:LayoutMetadata = new LayoutMetadata();
				posterLayout.scaleMode = ScaleMode.ZOOM;
				posterLayout.verticalAlign = VerticalAlign.MIDDLE;
				posterLayout.horizontalAlign = HorizontalAlign.CENTER;
				posterLayout.percentWidth = 100;
				posterLayout.percentHeight = 100;
				posterElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, posterLayout);
				var posterLoadTrait:LoadTrait = posterElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
				posterLoadTrait.load();
				
				mps.mediaContainer.addMediaElement(posterElement);
			}
			mp.media = videoElement;
			
			mps.mediaContainer.addEventListener(MouseEvent.CLICK, onMediaClick);
			
			mp.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			mp.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onPlayTimeChange);
			mp.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, onLoadedChange);
		}
		
		//------------添加视频控制条，进度条，中间播放按钮-----------
		private function creatControls():void
		{
			controlBar = new ControlBar(mp);
			controlBar.y = stage.stageHeight - controlBar.height;
			addChild(controlBar);
			if(mp.autoPlay){
				controlBar.setBtnPlaying(false);
			}else {
				controlBar.setBtnPlaying(true);
			}
			controlBar.useFullScreenBtn(flashVars.useFullScreen);
			
			progressBar = new ProgressBar(mp);
			progressBar.y = controlBar.y - 2;
			addChild(progressBar);
		}
		
		private function onStageResize(event:Event):void
		{
			mps.mediaContainer.layoutMetadata.width = stage.stageWidth;
			mps.mediaContainer.layoutMetadata.height = stage.stageHeight;
			
			controlBar.y = stage.stageHeight - controlBar.height;
			progressBar.y = controlBar.y - 2;
		}
		
		
		private function onPlayerStateChange(event:MediaPlayerStateChangeEvent):void
		{
			if(event.state == MediaPlayerState.PLAYING || event.state == MediaPlayerState.PLAYBACK_ERROR){
				mps.mediaContainer.alpha = 0;
			}
			if(event.state == MediaPlayerState.READY){
				mps.mediaContainer.alpha = 1;
				controlBar.setBtnPlaying(true);
			}
		}
		
		private function onPlayTimeChange(event:TimeEvent):void
		{
			controlBar.setTimeText(mp.currentTime, mp.duration);
			progressBar.setProgress(mp.currentTime, mp.duration);
		}
		
		private function onLoadedChange(event:LoadEvent):void
		{
			progressBar.setLoadedBar(mp.bytesLoaded, mp.bytesTotal);
		}
		
		private function onMediaClick(event:MouseEvent):void
		{
			if ( mp.playing ){				
				if(mp.canPause) mp.pause();
				controlBar.setBtnPlaying(true);
			}
			if(flashVars.clickVideoUrl != null && flashVars.clickVideoUrl.length > 0){
				navigateToURL(new URLRequest(flashVars.clickVideoUrl), "_blank");
			}
			if(flashVars.clickVideoFunc != null && flashVars.clickVideoFunc.length > 0){
				if(ExternalInterface.available){
					var callbackFunction:String = 
						"function(objectID) {" +
						"  if (typeof " + flashVars.clickVideoFunc + " == 'function') { " +
						"    " + flashVars.clickVideoFunc + "(objectID); " +
						"  } " +
						"} ";
					ExternalInterface.call(callbackFunction, ExternalInterface.objectID);
				}
			}
		}
		
		public function hideControlBar(event:MouseEvent = null):void
		{
			
			if(controlBar.visible){
				controlBar.visible = false;
				progressBar.hideDragBtn();
				progressBar.y = stage.stageHeight - 2;
			}
		}
		
		public function showControlBar(event:MouseEvent = null):void
		{
			if(!controlBar.visible){
				controlBar.visible = true;
				progressBar.showDragBtn();
				controlBar.y = stage.stageHeight - controlBar.height;
				progressBar.y = controlBar.y - 2;
			}
		}
		
	}
}