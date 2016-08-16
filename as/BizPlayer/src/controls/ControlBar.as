/**************************************
 * Developed for Sogou Biz.
 * Written by suncan, 2016.
 * 
 */
package controls
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import bizPlayer.FullScreenBtn;
	import bizPlayer.PlayPauseBtn;
	
	import org.osmf.media.MediaPlayer;
	
	public class ControlBar extends Sprite
	{
		private const _barHeight:Number = 30;
		private var _barWidth:Number = 500;
		
		private var barBg:Shape;
		private var playPauseBtn:PlayPauseBtn;
		private var timeText:TextField;
		private var volSlider:VolumeSlider;
		private var fsBtn:Sprite;
		private var overlayPlay:OverlayPlay;
		
		private var _mediaPlayer:MediaPlayer;
		
		public function ControlBar(mediaPlayer:MediaPlayer)
		{
			super();
			_mediaPlayer = mediaPlayer;
			createControls();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function createControls():void
		{
			createBarBg();
			createPlayPauseBtn();
			createTimeText();
			createFullScreenBtn();
			createVolSlider();
		}
		
		private function createBarBg():void
		{
			barBg = new Shape();
			barBg.graphics.beginFill(0x000000, 0.5);
			barBg.graphics.drawRect(0,0,_barWidth,_barHeight);
			barBg.graphics.endFill();
			addChild( barBg );
		}
		
		private function createPlayPauseBtn():void
		{
			playPauseBtn = new PlayPauseBtn();
			playPauseBtn.gotoAndStop(1);
			playPauseBtn.x = 10 ;
			playPauseBtn.y = (_barHeight - playPauseBtn.height)/2;
			playPauseBtn.buttonMode = true;
			addChild( playPauseBtn );
		}
		
		private function createTimeText():void
		{
			timeText = new TextField();
			timeText.textColor = 0xffffff;
			timeText.autoSize = "left";
			setTimeText(0, 0);
			timeText.x = 20 + playPauseBtn.width;
			timeText.y = (_barHeight - timeText.height) / 2;
			addChild( timeText );
		}
		
		private function createVolSlider():void
		{
			volSlider = new VolumeSlider();
			volSlider.x = _barWidth - volSlider.width - fsBtn.width - 30;
			volSlider.y = (_barHeight - volSlider.height)/2;
			addChild( volSlider );
		}
		
		private function createFullScreenBtn():void
		{
			fsBtn = new Sprite() ;
			fsBtn.addChild( new Bitmap(new FullScreenBtn()) );
			fsBtn.x = _barWidth - fsBtn.width - 10;
			fsBtn.y = (_barHeight - fsBtn.height)/2;
			fsBtn.buttonMode = true;
			addChild( fsBtn );
		}
		
		private function getTime( sec:Number ):String 
		{
			var h:Number = Math.floor(sec/3600);
			h = isNaN(h) ? 0 : h;
			
			var m:Number = Math.floor((sec%3600)/60);
			m = isNaN(m) ? 0 : m;
			
			var s:Number = Math.floor((sec%3600)%60);
			s = isNaN(s) ? 0 : s;
			
			var timeText:String = m.toString() + ":" + (s<10 ? "0"+s.toString() : s.toString());
			if(h > 0){
				timeText = h.toString() + ":" + timeText;
			}
			
			return timeText;
		}
		
		// Events:
		protected function onAddedToStage( event:Event ):void
		{
			overlayPlay = new OverlayPlay();
			stage.addChild( overlayPlay );
			onStageResize();
			
			// Listen for mouse events
			overlayPlay.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			
			playPauseBtn.addEventListener(MouseEvent.CLICK, onPlayPauseClick);
			playPauseBtn.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			playPauseBtn.addEventListener(MouseEvent.MOUSE_OUT, onBtnOut);
			
			fsBtn.addEventListener(MouseEvent.CLICK, onFullScreenClick);
			fsBtn.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			fsBtn.addEventListener(MouseEvent.MOUSE_OUT, onBtnOut);
			
			volSlider.addEventListener(Event.CHANGE, onVolumeChange);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		protected function onStageResize(event:Event = null):void
		{
			_barWidth = stage.stageWidth;
			barBg.width = _barWidth;
			fsBtn.x = _barWidth - fsBtn.width - 10;
			volSlider.x = _barWidth - volSlider.width - fsBtn.width - 50;
			
			overlayPlay.x = (stage.stageWidth - overlayPlay.width)/2;
			overlayPlay.y = (stage.stageHeight - overlayPlay.height)/2;
		}
		
		protected function onPlayPauseClick(event:MouseEvent):void
		{
			if ( _mediaPlayer.playing ){				
				if(_mediaPlayer.canPause) _mediaPlayer.pause();
				setBtnPlaying(true);
			}else{
				if(_mediaPlayer.canPlay) _mediaPlayer.play();
				setBtnPlaying(false);
			}
		}
		
		protected function onFullScreenClick(event:MouseEvent):void
		{
			switch(stage.displayState) 
			{
				case StageDisplayState.NORMAL:
					stage.displayState = StageDisplayState.FULL_SCREEN;
					break;
				case StageDisplayState.FULL_SCREEN:
				default:
					stage.displayState = StageDisplayState.NORMAL;
					break;
			}
		}
		
		protected function onBtnOver(event:MouseEvent):void
		{
			var target:DisplayObject =  event.target as DisplayObject;
			target.alpha = 0.8;
		}
		
		protected function onBtnOut(event:MouseEvent):void
		{
			var target:DisplayObject =  event.target as DisplayObject;
			target.alpha = 1;
		}
		
		protected function onVolumeChange(event:Event):void
		{
			_mediaPlayer.volume = volSlider.volume;
		}
		
		public function setTimeText(currentTime:Number, totalTime:Number):void
		{
			timeText.text = getTime(currentTime) + " / " + getTime(totalTime);
		}
		
		public function setBtnPlaying(value:Boolean):void
		{
			if(value) {
				playPauseBtn.gotoAndStop(1);
				overlayPlay.visible = true;
			} else {
				playPauseBtn.gotoAndStop(2);
				overlayPlay.visible = false;
			}
		}
		
		public function useFullScreenBtn(value:Boolean):void
		{
			fsBtn.visible = value;
		}
	}
}