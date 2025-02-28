extends Control

func ShowControlsText():
	$CanvasLayer/Control/ControlsLabel.text = "WASD - Move\nSpace - Jump\nShift - Dash\nLMB - Shoot\nR - Reload" 

func ShowDefaultText():
	$CanvasLayer/Control/ControlsLabel.text = "TAB - Controls" 
