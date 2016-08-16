/**************************************
 * Developed for Sogou Biz.
 * Written by suncan, 2016.
 * 
 */
package controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import bizPlayer.Volume;
	
	/**********************************
	 * The VolumeSlider class creates a slider
	 * control for setting the media volume.
	 * 
	 */
	public class VolumeSlider extends Sprite
	{
		//the slider width
		private const _trackWidth:Number = 50;
		private var _volume:Number = 1;
		private var _oldDragBtnX:Number = 0;
		private var _dragging:Boolean = false;
		
		
		//mute button
		private var volBtn:Volume;
		private var slider:Sprite;
		private var dragBtn:Sprite;
		private var track:Sprite;
		
		public function VolumeSlider()
		{
			super();
			createVolBtn();
			createSlider();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function createVolBtn():void
		{
			volBtn = new Volume();
			volBtn.gotoAndStop(1);
			volBtn.buttonMode = true;
			addChild(volBtn);
		}
		
		private function createSlider():void
		{
			slider = new Sprite();
			
			dragBtn = new Sprite();
			dragBtn.graphics.beginFill(0xffffff, 1);
			dragBtn.graphics.drawCircle(0, 0, 4);
			dragBtn.graphics.endFill();
			dragBtn.buttonMode = true;
			slider.addChild(dragBtn);

			track = new Sprite();
			track.graphics.beginFill(0xffffff, 1);
			track.graphics.drawRect(0, -1, _trackWidth, 2);
			track.graphics.endFill();
			track.buttonMode = true;
			slider.addChild(track);
			
			slider.x = volBtn.width + 10;
			slider.y = height / 2;
			addChild(slider);
		}
		
		// Events:
		protected function onAddedToStage( event:Event ):void
		{
			dragBtn.x = _trackWidth;
			_oldDragBtnX = dragBtn.x;
			
			// Listen for mouse events
			volBtn.addEventListener(MouseEvent.CLICK, onVolClick);
			volBtn.addEventListener(MouseEvent.MOUSE_OVER, onVolBtnOver);
			volBtn.addEventListener(MouseEvent.MOUSE_OUT, onVolBtnOut);
			
			track.addEventListener(MouseEvent.CLICK, onTrackClick);
			dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragStop);
		}
		
		protected function onVolClick( event:MouseEvent ):void
		{
			if(_volume == 0)
			{
				dragBtn.x = _oldDragBtnX;
				_volume = dragBtn.x / _trackWidth;
				volBtn.gotoAndStop(1);
			}
			else
			{
				_oldDragBtnX = dragBtn.x;
				dragBtn.x = 0;
				_volume = 0;
				volBtn.gotoAndStop(2);
			}
			
			// Relay event
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onVolBtnOver( event:MouseEvent ):void
		{
			volBtn.alpha = 0.8;
		}
		
		protected function onVolBtnOut( event:MouseEvent ):void
		{
			volBtn.alpha = 1;
		}
		
		protected function onDragStart( event:MouseEvent ):void
		{
			var rec:Rectangle = new Rectangle(0, 0, _trackWidth, 0);
			_dragging = true;
			dragBtn.startDrag(true, rec);
			// Update volume during drag...
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onDragStop( event:MouseEvent ):void
		{
			if( _dragging ) {
				_dragging = false;
				dragBtn.stopDrag();
				onEnterFrame();
				
				// Clean up...
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		protected function onEnterFrame( event:Event=null ):void
		{
			// Update volume
			_volume = dragBtn.x / _trackWidth;
			
			// Relay event
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onTrackClick( event:MouseEvent ):void
		{
			dragBtn.x = mouseX - slider.x;
			
			// Update volume
			_volume = dragBtn.x / _trackWidth;;
			
			// Relay event
			dispatchEvent(new Event(Event.CHANGE));
		}


		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			_volume = value;
		}

	}
}