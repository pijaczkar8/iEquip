Scriptname iEquip_BeastMode extends Quest

import UI
import UICallback
import Utility
import iEquip_StringExt

iEquip_WidgetCore property WC auto
iEquip_ProMode property PM auto
iEquip_AmmoMode property AM auto
iEquip_KeyHandler property KH auto
iEquip_PlayerEventHandler property EH auto

actor property PlayerRef auto

; Werewolf reference - Vanilla - populated in CK
race property WerewolfBeastRace auto

race[] property arBeastRaces auto hidden

event OnInit()
	arBeastRaces = new race[3]
	arBeastRaces[0] = WerewolfBeastRace
endEvent

function initialise()

endFunction

function onPlayerTransform(race newRace)

endFunction

