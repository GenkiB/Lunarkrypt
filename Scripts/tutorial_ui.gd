extends CanvasLayer

func SetTextDashTip():
	$TutorialUI/Control/TipLabel.text = "Press Shift to Dash when moving towards an Enemy."

func SetTextReloadTip():
	$TutorialUI/Control/TipLabel.text = "Press R to Reload."

func SetTextBossWarning():
	$TutorialUI/Control/TipLabel.text = "Tough fight ahead! Use Dash to overcome your foe.\nTry shooting the poison to defend yourself."

func SetTextDoubleJump():
	$TutorialUI/Control/TipLabel.text = "You have obtained the Double Jump Skill!\nPress Spacebar in quick succession to reach new heights."

func SetTextSpikesWarning():
	$TutorialUI/Control/TipLabel.text = "Beware of Spikes!\nUse Dash or Double Jump to avoid them."
