;NSIS Modern User Interface version 1.63
!define MUI_PRODUCT "Max - Trivia bot v1.1"
!define MUI_VERSION "1.1"

!include "MUI.nsh"

OutFile "StartMenu.exe"

InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"
  
InstallDirRegKey HKCU "Software\${MUI_PRODUCT}" ""
  
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${MUI_PRODUCT}" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

!define TEMP $R0
  
!define MUI_LICENSEPAGE
!define MUI_DIRECTORYPAGE
!define MUI_STARTMENUPAGE
  
!define MUI_ABORTWARNING
  
!define MUI_UNINSTALLER
!define MUI_UNCONFIRMPAGE
  
!insertmacro MUI_LANGUAGE "aa"
  
LangString DESC_SecCopyUI ${LANG_ESTONIAN} "Põhifailid."
  
LicenseData /LANG=${LANG_ESTONIAN} "D:\Projektid\Max_renew\litsents.txt"

Section "Max.exe" SecCopyUI

  SetOutPath "$INSTDIR"
  File "D:\Projektid\Max_renew\Max.exe"
  File "D:\Projektid\Max_renew\punktid2html.exe"
  File "D:\Projektid\Max_renew\mirc.ini"
  File "D:\Projektid\Max_renew\popups.ini"
  File "D:\Projektid\Max_renew\punktid.ini"
  File "D:\Projektid\Max_renew\remote.ini"
  File "D:\Projektid\Max_renew\script1.mrc"
  File "D:\Projektid\Max_renew\kyssad.txt"
  File "D:\Projektid\Max_renew\litsents.txt"
  
  WriteRegStr HKCU "Software\${MUI_PRODUCT}" "" $INSTDIR
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN
    
    CreateDirectory "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}"
    CreateShortCut "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\Max.lnk" "$INSTDIR\max.exe"
    CreateShortCut "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_END
  
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

!insertmacro MUI_SECTIONS_FINISHHEADER

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecCopyUI} $(DESC_SecCopyUI)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END

Section "Uninstall"

  Delete "$INSTDIR\max.exe"
  Delete "$INSTDIR\punktid2html.exe"
  Delete "$INSTDIR\mirc.ini"
  Delete "$INSTDIR\popups.ini"
  Delete "$INSTDIR\remote.ini"
  Delete "$INSTDIR\script1.mrc"
  Delete "$INSTDIR\litsents.txt"
  Delete "$INSTDIR\Uninstall.exe"
  
  ReadRegStr ${TEMP} "${MUI_STARTMENUPAGE_REGISTRY_ROOT}" "${MUI_STARTMENUPAGE_REGISTRY_KEY}" "${MUI_STARTMENUPAGE_REGISTRY_VALUENAME}"
  
  StrCmp ${TEMP} "" noshortcuts
  
    Delete "$SMPROGRAMS\${TEMP}\Modern UI.lnk"
    Delete "$SMPROGRAMS\${TEMP}\Uninstall.lnk"
    RMDir "$SMPROGRAMS\${TEMP}" ;Only if empty, so it won't delete other shortcuts
    
  noshortcuts:

  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\${MUI_PRODUCT}"

  !insertmacro MUI_UNFINISHHEADER

SectionEnd