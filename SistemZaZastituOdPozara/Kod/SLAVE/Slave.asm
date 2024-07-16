
_transmitByte:

;Slave.c,62 :: 		void transmitByte(unsigned char bajt)
;Slave.c,64 :: 		TXREG = bajt;
	MOVF       FARG_transmitByte_bajt+0, 0
	MOVWF      TXREG+0
;Slave.c,65 :: 		while (!TXSTA.TRMT)
L_transmitByte0:
	BTFSC      TXSTA+0, 1
	GOTO       L_transmitByte1
;Slave.c,66 :: 		;
	GOTO       L_transmitByte0
L_transmitByte1:
;Slave.c,67 :: 		}
	RETURN
; end of _transmitByte

_ad_convert:

;Slave.c,69 :: 		unsigned char ad_convert()
;Slave.c,71 :: 		unsigned int temp = 0x0000;
	CLRF       ad_convert_temp_L0+0
	CLRF       ad_convert_temp_L0+1
;Slave.c,72 :: 		int i = 0;
	CLRF       ad_convert_i_L0+0
	CLRF       ad_convert_i_L0+1
;Slave.c,74 :: 		for (i = 1; i < 30; i++)
	MOVLW      1
	MOVWF      ad_convert_i_L0+0
	MOVLW      0
	MOVWF      ad_convert_i_L0+1
L_ad_convert2:
	MOVLW      128
	XORWF      ad_convert_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ad_convert101
	MOVLW      30
	SUBWF      ad_convert_i_L0+0, 0
L__ad_convert101:
	BTFSC      STATUS+0, 0
	GOTO       L_ad_convert3
	INCF       ad_convert_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       ad_convert_i_L0+1, 1
;Slave.c,75 :: 		;
	GOTO       L_ad_convert2
L_ad_convert3:
;Slave.c,76 :: 		ADCON0.GO_DONE = 1;
	BSF        ADCON0+0, 2
;Slave.c,77 :: 		while (ADCON0.GO_DONE)
L_ad_convert5:
	BTFSS      ADCON0+0, 2
	GOTO       L_ad_convert6
;Slave.c,78 :: 		;
	GOTO       L_ad_convert5
L_ad_convert6:
;Slave.c,79 :: 		temp = (ADRESH << 8) + ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	ADDWF      R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      ad_convert_temp_L0+0
	MOVF       R3+1, 0
	MOVWF      ad_convert_temp_L0+1
;Slave.c,80 :: 		temp = temp >> 3;
	MOVF       R3+0, 0
	MOVWF      R1+0
	MOVF       R3+1, 0
	MOVWF      R1+1
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	RRF        R1+1, 1
	RRF        R1+0, 1
	BCF        R1+1, 7
	MOVF       R1+0, 0
	MOVWF      ad_convert_temp_L0+0
	MOVF       R1+1, 0
	MOVWF      ad_convert_temp_L0+1
;Slave.c,82 :: 		if (temp > 99)
	MOVF       R1+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__ad_convert102
	MOVF       R1+0, 0
	SUBLW      99
L__ad_convert102:
	BTFSC      STATUS+0, 0
	GOTO       L_ad_convert7
;Slave.c,83 :: 		temp = 99;
	MOVLW      99
	MOVWF      ad_convert_temp_L0+0
	MOVLW      0
	MOVWF      ad_convert_temp_L0+1
L_ad_convert7:
;Slave.c,84 :: 		return ((unsigned char)temp);
	MOVF       ad_convert_temp_L0+0, 0
	MOVWF      R0+0
;Slave.c,85 :: 		}
	RETURN
; end of _ad_convert

_convert:

;Slave.c,87 :: 		void convert(unsigned char number)
;Slave.c,89 :: 		X1 = number;
	MOVF       FARG_convert_number+0, 0
	MOVWF      _X1+0
;Slave.c,90 :: 		X10 = 0;
	CLRF       _X10+0
;Slave.c,91 :: 		while (X1 > 9)
L_convert8:
	MOVF       _X1+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_convert9
;Slave.c,93 :: 		X1 = X1 - 10;
	MOVLW      10
	SUBWF      _X1+0, 1
;Slave.c,94 :: 		X10++;
	INCF       _X10+0, 1
;Slave.c,95 :: 		}
	GOTO       L_convert8
L_convert9:
;Slave.c,96 :: 		}
	RETURN
; end of _convert

_updateLCD:

;Slave.c,98 :: 		void updateLCD()
;Slave.c,100 :: 		if (displej == 0)
	MOVF       _displej+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_updateLCD10
;Slave.c,102 :: 		LCD_Out(1, 1, "PI SM 02  DR TE ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,103 :: 		LCD_Out(2, 1, " X  X  X   X XX ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,104 :: 		LCD_Chr(2, 2, m_bPir + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bPir+0, BitPos(_m_bPir+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,105 :: 		LCD_Chr(2, 5, m_bSmoke + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bSmoke+0, BitPos(_m_bSmoke+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,106 :: 		LCD_Chr(2, 8, m_bO2 + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bO2+0, BitPos(_m_bO2+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,107 :: 		LCD_Chr(2, 12, m_bDrill + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bDrill+0, BitPos(_m_bDrill+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,108 :: 		convert(Temperature);
	MOVF       _Temperature+0, 0
	MOVWF      FARG_convert_number+0
	CALL       _convert+0
;Slave.c,109 :: 		LCD_Chr(2, 14, X10 + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,110 :: 		LCD_Chr(2, 15, X1 + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,111 :: 		}
	GOTO       L_updateLCD11
L_updateLCD10:
;Slave.c,114 :: 		LCD_Out(1, 1, "GA VE DO  Z S TA");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,115 :: 		LCD_Out(2, 1, " X  X  X  X X XX");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,116 :: 		LCD_Chr(2, 2, m_bGas + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bGas+0, BitPos(_m_bGas+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,117 :: 		LCD_Chr(2, 5, m_bVent + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bVent+0, BitPos(_m_bVent+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,118 :: 		LCD_Chr(2, 8, m_bDoorOpen + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,119 :: 		LCD_Chr(2, 11, m_bSound + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      0
	BTFSC      _m_bSound+0, BitPos(_m_bSound+0)
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      48
	ADDWF      FARG_Lcd_Chr_out_char+0, 1
	CALL       _Lcd_Chr+0
;Slave.c,120 :: 		LCD_Chr(2, 13, State + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _State+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,121 :: 		convert(Tajmer);
	MOVF       _Tajmer+0, 0
	MOVWF      FARG_convert_number+0
	CALL       _convert+0
;Slave.c,122 :: 		LCD_Chr(2, 15, X10 + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,123 :: 		LCD_Chr(2, 16, X1 + 0x30);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,124 :: 		}
L_updateLCD11:
;Slave.c,125 :: 		}
	RETURN
; end of _updateLCD

_processInputs:

;Slave.c,127 :: 		void processInputs()
;Slave.c,129 :: 		Temperature = ad_convert();
	CALL       _ad_convert+0
	MOVF       R0+0, 0
	MOVWF      _Temperature+0
;Slave.c,131 :: 		m_bSmoke = SMOKE;
	BTFSC      PORTD+0, 1
	GOTO       L__processInputs103
	BCF        _m_bSmoke+0, BitPos(_m_bSmoke+0)
	GOTO       L__processInputs104
L__processInputs103:
	BSF        _m_bSmoke+0, BitPos(_m_bSmoke+0)
L__processInputs104:
;Slave.c,132 :: 		m_bDrill = DRILL;
	BTFSC      PORTD+0, 3
	GOTO       L__processInputs105
	BCF        _m_bDrill+0, BitPos(_m_bDrill+0)
	GOTO       L__processInputs106
L__processInputs105:
	BSF        _m_bDrill+0, BitPos(_m_bDrill+0)
L__processInputs106:
;Slave.c,133 :: 		m_bO2 = O2;
	BTFSC      PORTD+0, 2
	GOTO       L__processInputs107
	BCF        _m_bO2+0, BitPos(_m_bO2+0)
	GOTO       L__processInputs108
L__processInputs107:
	BSF        _m_bO2+0, BitPos(_m_bO2+0)
L__processInputs108:
;Slave.c,134 :: 		m_bPir = PIR;
	BTFSC      PORTD+0, 0
	GOTO       L__processInputs109
	BCF        _m_bPir+0, BitPos(_m_bPir+0)
	GOTO       L__processInputs110
L__processInputs109:
	BSF        _m_bPir+0, BitPos(_m_bPir+0)
L__processInputs110:
;Slave.c,136 :: 		m_bVent = 0;
	BCF        _m_bVent+0, BitPos(_m_bVent+0)
;Slave.c,137 :: 		m_bDoorOpen = 0;
	BCF        _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
;Slave.c,138 :: 		m_bSound = 0;
	BCF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,139 :: 		m_bGas = 0;
	BCF        _m_bGas+0, BitPos(_m_bGas+0)
;Slave.c,141 :: 		if (Tajmer > 0)
	MOVF       _Tajmer+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_processInputs12
;Slave.c,142 :: 		Tajmer--;
	DECF       _Tajmer+0, 1
L_processInputs12:
;Slave.c,143 :: 		switch (State)
	GOTO       L_processInputs13
;Slave.c,145 :: 		case 0:
L_processInputs15:
;Slave.c,146 :: 		m_bVent = 1;
	BSF        _m_bVent+0, BitPos(_m_bVent+0)
;Slave.c,147 :: 		m_bDoorOpen = 1;
	BSF        _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
;Slave.c,148 :: 		if ((m_bSmoke == 1) || (Temperature > 50))
	BTFSC      _m_bSmoke+0, BitPos(_m_bSmoke+0)
	GOTO       L__processInputs96
	MOVF       _Temperature+0, 0
	SUBLW      50
	BTFSS      STATUS+0, 0
	GOTO       L__processInputs96
	GOTO       L_processInputs18
L__processInputs96:
;Slave.c,150 :: 		State = 1;
	MOVLW      1
	MOVWF      _State+0
;Slave.c,151 :: 		Tajmer = 10;
	MOVLW      10
	MOVWF      _Tajmer+0
;Slave.c,152 :: 		}
	GOTO       L_processInputs19
L_processInputs18:
;Slave.c,154 :: 		State = 0;
	CLRF       _State+0
L_processInputs19:
;Slave.c,155 :: 		break;
	GOTO       L_processInputs14
;Slave.c,156 :: 		case 1:
L_processInputs20:
;Slave.c,157 :: 		m_bSound = 1;
	BSF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,158 :: 		m_bDoorOpen = 1;
	BSF        _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
;Slave.c,159 :: 		m_bVent = 1;
	BSF        _m_bVent+0, BitPos(_m_bVent+0)
;Slave.c,161 :: 		if ((Tajmer > 0) || ((Tajmer == 0) && (m_bPir == 1)))
	MOVF       _Tajmer+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__processInputs94
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__processInputs95
	BTFSS      _m_bPir+0, BitPos(_m_bPir+0)
	GOTO       L__processInputs95
	GOTO       L__processInputs94
L__processInputs95:
	GOTO       L_processInputs25
L__processInputs94:
;Slave.c,163 :: 		State = 1;
	MOVLW      1
	MOVWF      _State+0
;Slave.c,165 :: 		}
	GOTO       L_processInputs26
L_processInputs25:
;Slave.c,168 :: 		State = 2;
	MOVLW      2
	MOVWF      _State+0
;Slave.c,169 :: 		Tajmer = 10;
	MOVLW      10
	MOVWF      _Tajmer+0
;Slave.c,170 :: 		}
L_processInputs26:
;Slave.c,171 :: 		break;
	GOTO       L_processInputs14
;Slave.c,172 :: 		case 2:
L_processInputs27:
;Slave.c,173 :: 		m_bSound = 1;
	BSF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,174 :: 		if ((Tajmer == 0) && (m_bPir == 0))
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_processInputs30
	BTFSC      _m_bPir+0, BitPos(_m_bPir+0)
	GOTO       L_processInputs30
L__processInputs93:
;Slave.c,175 :: 		State = 3;
	MOVLW      3
	MOVWF      _State+0
	GOTO       L_processInputs31
L_processInputs30:
;Slave.c,176 :: 		else if ((Tajmer > 0) || ((Tajmer == 0) && (m_bPir == 1)))
	MOVF       _Tajmer+0, 0
	SUBLW      0
	BTFSS      STATUS+0, 0
	GOTO       L__processInputs91
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__processInputs92
	BTFSS      _m_bPir+0, BitPos(_m_bPir+0)
	GOTO       L__processInputs92
	GOTO       L__processInputs91
L__processInputs92:
	GOTO       L_processInputs36
L__processInputs91:
;Slave.c,177 :: 		State = 2;
	MOVLW      2
	MOVWF      _State+0
L_processInputs36:
L_processInputs31:
;Slave.c,178 :: 		break;
	GOTO       L_processInputs14
;Slave.c,179 :: 		case 3:
L_processInputs37:
;Slave.c,180 :: 		m_bSound = 1;
	BSF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,181 :: 		m_bGas = 1;
	BSF        _m_bGas+0, BitPos(_m_bGas+0)
;Slave.c,182 :: 		if (m_bO2 == 1)
	BTFSS      _m_bO2+0, BitPos(_m_bO2+0)
	GOTO       L_processInputs38
;Slave.c,183 :: 		State = 3;
	MOVLW      3
	MOVWF      _State+0
	GOTO       L_processInputs39
L_processInputs38:
;Slave.c,186 :: 		State = 4;
	MOVLW      4
	MOVWF      _State+0
;Slave.c,187 :: 		Tajmer = 10;
	MOVLW      10
	MOVWF      _Tajmer+0
;Slave.c,188 :: 		}
L_processInputs39:
;Slave.c,189 :: 		break;
	GOTO       L_processInputs14
;Slave.c,190 :: 		case 4:
L_processInputs40:
;Slave.c,191 :: 		m_bSound = 1;
	BSF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,192 :: 		if ((m_bO2 == 0) && (Tajmer == 0))
	BTFSC      _m_bO2+0, BitPos(_m_bO2+0)
	GOTO       L_processInputs43
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_processInputs43
L__processInputs90:
;Slave.c,194 :: 		State = 5;
	MOVLW      5
	MOVWF      _State+0
;Slave.c,195 :: 		Tajmer = 10;
	MOVLW      10
	MOVWF      _Tajmer+0
;Slave.c,196 :: 		}
	GOTO       L_processInputs44
L_processInputs43:
;Slave.c,197 :: 		else if (Tajmer == 0)
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_processInputs45
;Slave.c,198 :: 		State = 3;
	MOVLW      3
	MOVWF      _State+0
	GOTO       L_processInputs46
L_processInputs45:
;Slave.c,200 :: 		State = 4;
	MOVLW      4
	MOVWF      _State+0
L_processInputs46:
L_processInputs44:
;Slave.c,201 :: 		break;
	GOTO       L_processInputs14
;Slave.c,202 :: 		case 5:
L_processInputs47:
;Slave.c,203 :: 		m_bSound = 1;
	BSF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,204 :: 		m_bVent = 1;
	BSF        _m_bVent+0, BitPos(_m_bVent+0)
;Slave.c,205 :: 		if (m_bO2 == 0)
	BTFSC      _m_bO2+0, BitPos(_m_bO2+0)
	GOTO       L_processInputs48
;Slave.c,206 :: 		State = 5;
	MOVLW      5
	MOVWF      _State+0
	GOTO       L_processInputs49
L_processInputs48:
;Slave.c,208 :: 		else if (Tajmer == 0)
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_processInputs50
;Slave.c,210 :: 		State = 6;
	MOVLW      6
	MOVWF      _State+0
;Slave.c,211 :: 		Tajmer = 10;
	MOVLW      10
	MOVWF      _Tajmer+0
;Slave.c,212 :: 		}
	GOTO       L_processInputs51
L_processInputs50:
;Slave.c,214 :: 		State = 5;
	MOVLW      5
	MOVWF      _State+0
L_processInputs51:
L_processInputs49:
;Slave.c,215 :: 		break;
	GOTO       L_processInputs14
;Slave.c,216 :: 		case 6:
L_processInputs52:
;Slave.c,218 :: 		m_bVent = 1;
	BSF        _m_bVent+0, BitPos(_m_bVent+0)
;Slave.c,219 :: 		m_bSound = 1;
	BSF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,220 :: 		if (Tajmer == 0)
	MOVF       _Tajmer+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_processInputs53
;Slave.c,221 :: 		if ((m_bSmoke == 1) || (Temperature > 50))
	BTFSC      _m_bSmoke+0, BitPos(_m_bSmoke+0)
	GOTO       L__processInputs89
	MOVF       _Temperature+0, 0
	SUBLW      50
	BTFSS      STATUS+0, 0
	GOTO       L__processInputs89
	GOTO       L_processInputs56
L__processInputs89:
;Slave.c,223 :: 		State = 1;
	MOVLW      1
	MOVWF      _State+0
;Slave.c,224 :: 		Tajmer = 10;
	MOVLW      10
	MOVWF      _Tajmer+0
;Slave.c,225 :: 		}
	GOTO       L_processInputs57
L_processInputs56:
;Slave.c,226 :: 		else if (Tajmer > 0)
	MOVF       _Tajmer+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_processInputs58
;Slave.c,227 :: 		State = 6;
	MOVLW      6
	MOVWF      _State+0
	GOTO       L_processInputs59
L_processInputs58:
;Slave.c,229 :: 		State = 0;
	CLRF       _State+0
L_processInputs59:
L_processInputs57:
L_processInputs53:
;Slave.c,230 :: 		break;
	GOTO       L_processInputs14
;Slave.c,231 :: 		}
L_processInputs13:
	MOVF       _State+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs15
	MOVF       _State+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs20
	MOVF       _State+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs27
	MOVF       _State+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs37
	MOVF       _State+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs40
	MOVF       _State+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs47
	MOVF       _State+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_processInputs52
L_processInputs14:
;Slave.c,233 :: 		GAS = m_bGAS;
	BTFSC      _m_bGas+0, BitPos(_m_bGas+0)
	GOTO       L__processInputs111
	BCF        PORTA+0, 2
	GOTO       L__processInputs112
L__processInputs111:
	BSF        PORTA+0, 2
L__processInputs112:
;Slave.c,234 :: 		SOUND = m_bSound;
	BTFSC      _m_bSound+0, BitPos(_m_bSound+0)
	GOTO       L__processInputs113
	BCF        PORTA+0, 3
	GOTO       L__processInputs114
L__processInputs113:
	BSF        PORTA+0, 3
L__processInputs114:
;Slave.c,235 :: 		DOOR_OPEN = m_bDoorOpen;
	BTFSC      _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
	GOTO       L__processInputs115
	BCF        PORTA+0, 4
	GOTO       L__processInputs116
L__processInputs115:
	BSF        PORTA+0, 4
L__processInputs116:
;Slave.c,236 :: 		}
	RETURN
; end of _processInputs

_init:

;Slave.c,238 :: 		void init()
;Slave.c,241 :: 		TRISA = 0x03; // ulazi za potenciometre, PORTA.F0 i PORTA.F1
	MOVLW      3
	MOVWF      TRISA+0
;Slave.c,242 :: 		TRISB = 0x3F; // pinovi na portu B od 0 do 5 su digitalni
	MOVLW      63
	MOVWF      TRISB+0
;Slave.c,243 :: 		TRISC = 0xC0; // pinovi 6 i 7 su vezani za RS485
	MOVLW      192
	MOVWF      TRISC+0
;Slave.c,246 :: 		TRISD = 0x0F;
	MOVLW      15
	MOVWF      TRISD+0
;Slave.c,249 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;Slave.c,250 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;Slave.c,251 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Slave.c,252 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;Slave.c,254 :: 		ADCON0 = 0x81;                 // ukljucujem A/D konverziju, kanal 0
	MOVLW      129
	MOVWF      ADCON0+0
;Slave.c,255 :: 		ADCON1 = 0b10001110; // imam samo analogni ulaz pod A0
	MOVLW      142
	MOVWF      ADCON1+0
;Slave.c,256 :: 		INTCON = 0b11000000; // default podesavanja
	MOVLW      192
	MOVWF      INTCON+0
;Slave.c,257 :: 		PIE1 = 0b00000000;
	CLRF       PIE1+0
;Slave.c,258 :: 		T1CON = 0b00110000; // konfiguracija preskalera
	MOVLW      48
	MOVWF      T1CON+0
;Slave.c,259 :: 		TMR1H = 0x0B;                // startne vrednosti za tajmer 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,260 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,261 :: 		T1CON.TMR1ON = 1;
	BSF        T1CON+0, 0
;Slave.c,263 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,264 :: 		PIE1.TMR1IE = 1;
	BSF        PIE1+0, 0
;Slave.c,266 :: 		Uart1_Init(19200); // biblioteka
	MOVLW      64
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave.c,268 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;Slave.c,269 :: 		RCSTA.SPEN = 1;
	BSF        RCSTA+0, 7
;Slave.c,270 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;Slave.c,272 :: 		PIE1.RCIE = 1;        // dozvola za serijski prijem
	BSF        PIE1+0, 5
;Slave.c,273 :: 		INTCON.GIE = 1; // globalna dozvola prekida
	BSF        INTCON+0, 7
;Slave.c,275 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Slave.c,276 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,277 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,278 :: 		}
	RETURN
; end of _init

_init_variables:

;Slave.c,280 :: 		void init_variables()
;Slave.c,282 :: 		byteX = 0;
	CLRF       _byteX+0
;Slave.c,283 :: 		Temperature = 0;
	CLRF       _Temperature+0
;Slave.c,284 :: 		m_bSmoke = 0;
	BCF        _m_bSmoke+0, BitPos(_m_bSmoke+0)
;Slave.c,285 :: 		m_bDrill = 0;
	BCF        _m_bDrill+0, BitPos(_m_bDrill+0)
;Slave.c,286 :: 		m_bO2 = 0;
	BCF        _m_bO2+0, BitPos(_m_bO2+0)
;Slave.c,287 :: 		m_bPir = 0;
	BCF        _m_bPir+0, BitPos(_m_bPir+0)
;Slave.c,288 :: 		m_bVent = 0;
	BCF        _m_bVent+0, BitPos(_m_bVent+0)
;Slave.c,289 :: 		m_bDoorOpen = 0;
	BCF        _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
;Slave.c,290 :: 		m_bSound = 0;
	BCF        _m_bSound+0, BitPos(_m_bSound+0)
;Slave.c,291 :: 		m_bGas = 0;
	BCF        _m_bGas+0, BitPos(_m_bGas+0)
;Slave.c,293 :: 		State = 0;
	CLRF       _State+0
;Slave.c,294 :: 		Tajmer = 0;
	CLRF       _Tajmer+0
;Slave.c,295 :: 		displej = 0;
	CLRF       _displej+0
;Slave.c,296 :: 		X1 = 0;
	CLRF       _X1+0
;Slave.c,297 :: 		X10 = 0;
	CLRF       _X10+0
;Slave.c,298 :: 		Flag1 = 0;
	BCF        _Flag1+0, BitPos(_Flag1+0)
;Slave.c,299 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,300 :: 		}
	RETURN
; end of _init_variables

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave.c,302 :: 		void interrupt() // prekidi serijske komunikacije i tajmer1
;Slave.c,304 :: 		if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
	BTFSS      PIE1+0, 0
	GOTO       L_interrupt62
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt62
L__interrupt100:
;Slave.c,307 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,308 :: 		if (br == 0x09)
	MOVF       _br+0, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt63
;Slave.c,310 :: 		br = 0x00;
	CLRF       _br+0
;Slave.c,311 :: 		Flag1 = 0x01; // podigo se flag koji govori da je doslo vreme da se prozove slave(prostorija)
	BSF        _Flag1+0, BitPos(_Flag1+0)
;Slave.c,312 :: 		}
	GOTO       L_interrupt64
L_interrupt63:
;Slave.c,314 :: 		br++;
	INCF       _br+0, 1
L_interrupt64:
;Slave.c,316 :: 		if (tt > 0) // treperenje tastera
	MOVF       _tt+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt65
;Slave.c,317 :: 		tt--;
	DECF       _tt+0, 1
L_interrupt65:
;Slave.c,318 :: 		if (DISPLAY && (!tt)) // menjanje displeja
	BTFSS      PORTB+0, 3
	GOTO       L_interrupt68
	MOVF       _tt+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt68
L__interrupt99:
;Slave.c,320 :: 		if (displej < 1)
	MOVLW      1
	SUBWF      _displej+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt69
;Slave.c,321 :: 		displej++;
	INCF       _displej+0, 1
	GOTO       L_interrupt70
L_interrupt69:
;Slave.c,323 :: 		displej = 0;
	CLRF       _displej+0
L_interrupt70:
;Slave.c,324 :: 		tt = 4;
	MOVLW      4
	MOVWF      _tt+0
;Slave.c,325 :: 		}
L_interrupt68:
;Slave.c,326 :: 		TMR1H = 0x0B; // startne vrednosti za tajmer1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,327 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,328 :: 		}
L_interrupt62:
;Slave.c,330 :: 		if ((PIE1.RCIE) && (PIR1.RCIF)) // prekid zbog serijske komunikacije
	BTFSS      PIE1+0, 5
	GOTO       L_interrupt73
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt73
L__interrupt98:
;Slave.c,332 :: 		ch = RCREG; // citanje primljenog bajta
	MOVF       RCREG+0, 0
	MOVWF      _ch+0
;Slave.c,333 :: 		PIR1.RCIF = 0;
	BCF        PIR1+0, 5
;Slave.c,334 :: 		if (((ch & 0x1F) == RAMP_ID) && ((ch & 0xE0) == 0xA0))
	MOVLW      31
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORWF      _RAMP_ID+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt76
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt76
L__interrupt97:
;Slave.c,336 :: 		Command = ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
	CLRF       _Command+1
;Slave.c,337 :: 		CallFlag = 1;
	BSF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,338 :: 		}
L_interrupt76:
;Slave.c,339 :: 		}
L_interrupt73:
;Slave.c,340 :: 		}
L__interrupt117:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave.c,342 :: 		void main()
;Slave.c,344 :: 		init();
	CALL       _init+0
;Slave.c,345 :: 		init_variables();
	CALL       _init_variables+0
;Slave.c,346 :: 		processInputs();
	CALL       _processInputs+0
;Slave.c,347 :: 		updateLCD();
	CALL       _updateLCD+0
;Slave.c,348 :: 		while (1)
L_main77:
;Slave.c,350 :: 		if (Flag1 == 1)
	BTFSS      _Flag1+0, BitPos(_Flag1+0)
	GOTO       L_main79
;Slave.c,352 :: 		Flag1 = 0; // prosla jedna sec
	BCF        _Flag1+0, BitPos(_Flag1+0)
;Slave.c,353 :: 		processInputs();
	CALL       _processInputs+0
;Slave.c,354 :: 		updateLCD();
	CALL       _updateLCD+0
;Slave.c,355 :: 		}
L_main79:
;Slave.c,356 :: 		if (CallFlag == 1)
	BTFSS      _CallFlag+0, BitPos(_CallFlag+0)
	GOTO       L_main80
;Slave.c,359 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,360 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,361 :: 		transmitByte(Command);
	MOVF       _Command+0, 0
	MOVWF      FARG_transmitByte_bajt+0
	CALL       _transmitByte+0
;Slave.c,362 :: 		byteX = 0x00;
	CLRF       _byteX+0
;Slave.c,363 :: 		if (m_bPir == 1)
	BTFSS      _m_bPir+0, BitPos(_m_bPir+0)
	GOTO       L_main81
;Slave.c,364 :: 		byteX = byteX + 8;
	MOVLW      8
	ADDWF      _byteX+0, 1
L_main81:
;Slave.c,365 :: 		if (m_bSmoke == 1)
	BTFSS      _m_bSmoke+0, BitPos(_m_bSmoke+0)
	GOTO       L_main82
;Slave.c,366 :: 		byteX = byteX + 4;
	MOVLW      4
	ADDWF      _byteX+0, 1
L_main82:
;Slave.c,367 :: 		if (m_bO2 == 1)
	BTFSS      _m_bO2+0, BitPos(_m_bO2+0)
	GOTO       L_main83
;Slave.c,368 :: 		byteX = byteX + 2;
	MOVLW      2
	ADDWF      _byteX+0, 1
L_main83:
;Slave.c,369 :: 		if (m_bDrill == 1)
	BTFSS      _m_bDrill+0, BitPos(_m_bDrill+0)
	GOTO       L_main84
;Slave.c,370 :: 		byteX = byteX + 1;
	INCF       _byteX+0, 1
L_main84:
;Slave.c,371 :: 		if (m_bSound == 1)
	BTFSS      _m_bSound+0, BitPos(_m_bSound+0)
	GOTO       L_main85
;Slave.c,372 :: 		byteX = byteX + 16;
	MOVLW      16
	ADDWF      _byteX+0, 1
L_main85:
;Slave.c,373 :: 		if (m_bDoorOpen == 1)
	BTFSS      _m_bDoorOpen+0, BitPos(_m_bDoorOpen+0)
	GOTO       L_main86
;Slave.c,374 :: 		byteX = byteX + 32;
	MOVLW      32
	ADDWF      _byteX+0, 1
L_main86:
;Slave.c,375 :: 		if (m_bVent == 1)
	BTFSS      _m_bVent+0, BitPos(_m_bVent+0)
	GOTO       L_main87
;Slave.c,376 :: 		byteX = byteX + 64;
	MOVLW      64
	ADDWF      _byteX+0, 1
L_main87:
;Slave.c,377 :: 		if (m_bGas == 1)
	BTFSS      _m_bGas+0, BitPos(_m_bGas+0)
	GOTO       L_main88
;Slave.c,378 :: 		byteX = byteX + 128;
	MOVLW      128
	ADDWF      _byteX+0, 1
L_main88:
;Slave.c,379 :: 		transmitByte(byteX);
	MOVF       _byteX+0, 0
	MOVWF      FARG_transmitByte_bajt+0
	CALL       _transmitByte+0
;Slave.c,380 :: 		transmitByte(Temperature);
	MOVF       _Temperature+0, 0
	MOVWF      FARG_transmitByte_bajt+0
	CALL       _transmitByte+0
;Slave.c,381 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,382 :: 		}
L_main80:
;Slave.c,383 :: 		}
	GOTO       L_main77
;Slave.c,384 :: 		}
	GOTO       $+0
; end of _main
