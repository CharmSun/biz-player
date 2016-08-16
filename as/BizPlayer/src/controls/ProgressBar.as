/**************************************
 * Developed for Sogou Biz.
 * Written by suncan, 2016.
 * 
 */
package controls
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.osmf.media.MediaPlayer;
	
	public class ProgressBar extends Sprite
	{
		private var dragBtn:Sprite;
		private var track:Sprite;
		private var trackBar:Shape;
		private var loadedBar:Shape;
		private var scrubBar:Shape;
		
		private var _dragging:Boolean = false;
		private var _currentTime:Number = 0;
		private var _totalTime:Number = 0;
		private var _loadedBytes:Number = 0;
		private var _totalBytes:Number = 0;
		
		private var _mediaPlayer:MediaPlayer;
		
		public function ProgressBar(mediaPlayer:MediaPlayer)
		{
			super();
			_mediaPlayer = mediaPlayer;
			createControls();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function createControls():void
		{	
			track = new Sprite();
			trackBar = new Shape();
			trackBar.graphics.beginFill(0x999999, 0.5);
			trackBar.graphics.drawRect(0, 0, 5, 2);
			trackBar.graphics.endFill();
			track.addChild(trackBar);
			
			loadedBar = new Shape();
			loadedBar.graphics.beginFill(0xffffff, 0.5);
			loadedBar.graphics.drawRect(0, 0, 5, 2);
			loadedBar.graphics.endFill();
			track.addChild( loadedBar );
			
			scrubBar = new Shape();
			scrubBar.graphics.beginFill(0xf63e14, 1);
			scrubBar.graphics.drawRect(0, 0, 5, 2);
			scrubBar.graphics.endFill();
			track.addChild( scrubBar );
			
			track.buttonMode = true;
			addChild(track);
			
			dragBtn = new Sprite();
			dragBtn.graphics.beginFill(0xf63e14, 1);
			dragBtn.graphics.drawCircle(0, 0, 5);
			dragBtn.graphics.endFill();
			dragBtn.x = 5;
			dragBtn.y = 1;
			dragBtn.buttonMode = true;
			addChild(dragBtn);
		}
		
		// Events:
		protected function onAddedToStage( event:Event ):void
		{
			onStageResize();
			
			// Listen for mouse events
			track.addEventListener(MouseEvent.CLICK, onTrackClick);
			dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragStop);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		protected function onStageResize(event:Event = null):void
		{
			trackBar.width = stage.stageWidth;
			
			scrubBar.width = 5 + (trackBar.width - 10) * _currentTime / _totalTime;
			dragBtn.x = scrubBar.width;
			loadedBar.width = trackBar.width * _loadedBytes / _totalBytes;
		}
		
		protected function onDragStart( event:MouseEvent ):void
		{
			var rec:Rectangle = new Rectangle(5, 1, track.width - 10, 0);
			_dragging = true;
			dragBtn.startDrag(false, rec);
			// Update progress during drag...
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onDragStop( event:MouseEvent ):void
		{
			if( _dragging ) {
				_dragging = false;
				dragBtn.stopDrag();
				
				var seekTime:Number = _mediaPlayer.duration * ((dragBtn.x - 5) / (track.width - 10));
				if ( _mediaPlayer.canSeekTo(seekTime) ){
					_mediaPlayer.seek( seekTime );
					scrubBar.width = dragBtn.x;
				}
				
				// Clean up...
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			// Update scrubBar width
			scrubBar.width = dragBtn.x;
		}
		
		protected function onTrackClick( event:MouseEvent ):void
		{
			var seekTime:Number = _mediaPlayer.duration * ((mouseX - 5) / (track.width - 10));
			if ( _mediaPlayer.canSeekTo(seekTime) ){
				_mediaPlayer.seek( seekTime );
				dragBtn.x = mouseX;
				
				// Update scrubBar width
				scrubBar.width = dragBtn.x;
			}
		}
		
		/**
		 * Updates the progress.
		 * 
		 * @param	currentTime	Number representing the current time.
		 * @param	totalTime	Number representing the total time.
		 */
		public function setProgress(currentTime:Number, totalTime:Number):void
		{
			if(!_dragging )
			{
				_currentTime = currentTime;
				_totalTime = totalTime;
				scrubBar.width = 5 + (track.width - 10) * currentTime / totalTime;
				dragBtn.x = scrubBar.width;
			}
		}
		
		/**
		 * Updates the loaded bar.
		 */
		public function setLoadedBar(loadedBytes:Number, totalBytes:Number):void
		{
			_loadedBytes = loadedBytes;
			_totalBytes = totalBytes;
			loadedBar.width = track.width * loadedBytes / totalBytes;
		}
		
		public function hideDragBtn():void
		{
			dragBtn.visible = false;
		}
		
		public function showDragBtn():void
		{
			dragBtn.visible = true;
		}
	}
}