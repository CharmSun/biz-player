<video src="{{src}}" width="{{width}}" poster="{{poster}}" height="{{height}}">
	<source src="{{src}}" type="video/ogg" />
	<source src="{{src}}" type="video/mp4" />
	您的浏览器不支持html5，无法使用该插件！
</video>
<div class="video_body">
	<img class="video_poster" src="{{poster}}">
	<div class="video_controls">
		<ul class="video_controls_l">
			<li class="v_play">
				<i class="play_icon play" title="播放"></i>
				<i class="pause_icon play" title="暂停" style="display: none;"></i>
				<label><em>0:00</em> / <em>0:00</em></label>
			</li>
			<li class="v_items">
				<i class="volume_icon volume" title="音量调节"></i>
				<i class="mute_icon volume" title="音量调节" style="display: none;"></i>
				<p class="v_volume">
					<input type="range" class="volume_range" value="100" min="0" max="100">
				</p>
				<i class="fullscreen" title="全屏"></i>
			</li>
		</ul>
	</div>
	<div class="video_range">
		<progress  max="0" value="0" class="down_progress"></progress>
		<progress  max="0" value="0" class="v_progress"></progress>
		<input type="range" class="v_range" value="0" min="0" max="0">
	</div>
	<div class="v_bigplaybtn"></div>
</div>