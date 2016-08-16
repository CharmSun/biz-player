/**************************************
 * Developed for Sogou Biz.
 * Written by suncan, 2016.
 * 
 */
package controls
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import bizPlayer.PlayIcon;
	
	public class OverlayPlay extends Sprite
	{
		private var playIcon:PlayIcon = new PlayIcon();
		
		public function OverlayPlay()
		{
			super();
			addChild( new Bitmap(new PlayIcon()) );
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		// Events:
		protected function onAddedToStage( event:Event ):void
		{
			this.buttonMode = true;
		}
		
		protected function onMouseOver( event:MouseEvent ):void
		{
			this.alpha = 0.8;
		}
		
		protected function onMouseOut( event:MouseEvent ):void
		{
			this.alpha = 1;
		}
	}
}