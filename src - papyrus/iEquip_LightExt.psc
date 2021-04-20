ScriptName iEquip_LightExt


; @brief Returns the light duration of the given light.
; @param a_light The light to retrieve the light duration of.
; @return Returns -1 on error, else returns the light duration.
Int Function GetLightDuration(Light a_light) Global Native

; @brief Sets the light duration of the given light.
; @param a_light The light to set the light duration of.
; @param a_duration The duration of the light in seconds.
Function SetLightDuration(Light a_light, Int a_duration) Global Native

; @brief Returns the light radius of the given light.
; @param a_light The light to retrieve the light radius of.
; @return Returns -1 on error, else returns the light radius.
Int Function GetLightRadius(Light a_light) Global Native


; @brief Sets the light radius of the given light.
; @param a_light The light to set the light radius of.
Function SetLightRadius(Light a_light, Int a_radius) Global Native
