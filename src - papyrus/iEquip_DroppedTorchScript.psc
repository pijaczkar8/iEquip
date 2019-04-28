Scriptname iEquip_DroppedTorchScript extends ObjectReference

event OnLoad()
	RegisterForSingleUpdate(30.0)
endEvent

event OnUpdate()
	activate(self)
endEvent