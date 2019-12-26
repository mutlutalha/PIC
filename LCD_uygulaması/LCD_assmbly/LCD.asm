
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;/// PIC16f877A ile Assembly dilinde LCD kullanma ////////////////////////////////////////////////////////////////// 
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 LIST P=16f877A 
 INCLUDE "P16F877A.INC" 
 __CONFIG _CP_OFF& _DEBUG_OFF& _WRT_OFF& _CPD_OFF& _LVP_OFF& _BODEN_OFF& _PWRTE_ON& _WDT_OFF& _XT_OSC
 
ORG 0x00 

 BCF STATUS,RP1 ; Bank 1'e geç
 BSF STATUS,RP0 
 CLRF TRISB ; PORTB çıkış (8 bit LCD veri pinleri)
 CLRF TRISD ; PORTD çıkış (RD0-R/S, RD1-E)
 
 MOVLW b'00000111'
 MOVWF OPTION_REG ; Option Kaydedicisi(TMR0 ön derecelendirici = 1:256)
 
 BCF STATUS,RP0 ; Bank 0'a geç
 CLRF PORTB 
 CLRF PORTD 
 
 CALL KOMUT_GONDER
 
DONGU 

 CALL VERI_GONDER
 
 GOTO DONGU
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

KOMUT_GONDER

 BCF PORTD,RD0 ; LCD ye komut göndermek için RS 0 yapıldı
 
 CALL GECIK
 
 MOVLW b'00000001' ; Ekranı temizle
 MOVWF PORTB 
 CALL YAZ
 CALL GECIK
 
 MOVLW b'00111000' ; LCD 2*16 satır ve 5X7 çözünürlüğünde ayarla
 MOVWF PORTB 
 CALL YAZ
 CALL GECIK
 
 
 MOVLW b'00001100'  ; İmleç kapalı
 ;MOVLW b'00001101'  ; İmleç açık
 ;MOVLW b'00001111'  ; İmleç yanıp sönsün
 MOVWF PORTB
 CALL YAZ
 CALL GECIK
 
 MOVLW b'00000110' ; imleci sağa kaydır
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 RETURN

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
VERI_GONDER

 BCF PORTD,RD0 ; LCD ye komut göndermek için RS 0 yapıldı
 
 MOVLW b'00000010' ; İmleci başa getir
 MOVWF PORTB 
 CALL YAZ
 CALL GECIK
 
 BSF PORTD,RD0 ; LCD ye veri göndermek için RS 1 yapıldı
 
 CALL GECIK
 
 MOVLW 0x54    ; "T"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK
 
 MOVLW 0x61    ; "a"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x6C    ; "l"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x68    ; "h"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x61    ; "a"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x00    ; boşluk
 MOVWF PORTB
 CALL YAZ
 CALL GECIK
 
 MOVLW 0x4D    ; "M"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x75    ; "u"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x74    ; "t"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x6C    ; "l"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 MOVLW 0x75    ; "u"
 MOVWF PORTB
 CALL YAZ
 CALL GECIK 
 
 RETURN
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

YAZ 

 BSF PORTD,1 ; E pin aktif (LCD gelen verileri işler)
 NOP         ; Yaklaşık 1 ms kadar bekler (En az 450ns olmalıdır)
 BCF PORTD,1 ; E pin pasif
 RETURN
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;/// 5 ms gecikme (TMR0 kullanarak) ///////////////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
GECIK 

 MOVLW .5 
 MOVWF TMR0
 
A 

 BTFSS INTCON,2
 GOTO A
 BCF INTCON,2
 RETURN
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
END