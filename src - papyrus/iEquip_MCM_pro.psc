Scriptname iEquip_MCM_pro extends iEquip_MCM_Page

; Script deprecated in 1.2

import iEquip_StringExt

iEquip_ProMode Property PM Auto
iEquip_PotionScript Property PO Auto

Actor Property PlayerRef  Auto
Sound property UILevelUp auto

bool bStillToEnableProMode = true
int iProModeEasterEggCounter = 5

string[] QSPreferredMagicSchool
string[] preselectQuickFunctionOptions

string[] QRPreferredWeaponType
string[] QREquipOptions
string[] QROtherHandOptions
string[] QRSwitchOutOptions

string[] asMagicSchools

int iCurrentQSPreferredMagicSchoolChoice = 2
int iCurrentQRPreferredMagicSchoolChoice = 2
