
_convert:

;SZZP_m.c,88 :: 		void convert(unsigned char number)
;SZZP_m.c,90 :: 		X1 = number;
	MOVF        FARG_convert_number+0, 0 
	MOVWF       _X1+0 
;SZZP_m.c,91 :: 		X10 = 0;
	CLRF        _X10+0 
;SZZP_m.c,92 :: 		while (X1 > 9)
L_convert0:
	MOVF        _X1+0, 0 
	SUBLW       9
	BTFSC       STATUS+0, 0 
	GOTO        L_convert1
;SZZP_m.c,94 :: 		X1 = X1 - 10;
	MOVLW       10
	SUBWF       _X1+0, 1 
;SZZP_m.c,95 :: 		X10++;
	INCF        _X10+0, 1 
;SZZP_m.c,96 :: 		}
	GOTO        L_convert0
L_convert1:
;SZZP_m.c,97 :: 		}
	RETURN      0
; end of _convert

_SPI_Ethernet_UserTCP:

;SZZP_m.c,99 :: 		unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, char *canClose)
;SZZP_m.c,101 :: 		int len = 0; // duzina odgovora
	CLRF        SPI_Ethernet_UserTCP_len_L0+0 
	CLRF        SPI_Ethernet_UserTCP_len_L0+1 
;SZZP_m.c,102 :: 		int i = 0;
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
;SZZP_m.c,103 :: 		if (localPort != 80)
	MOVLW       0
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP178
	MOVLW       80
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+0, 0 
L__SPI_Ethernet_UserTCP178:
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP2
;SZZP_m.c,104 :: 		return (0); // obradjuje se samo web zahtev na portu 80
	CLRF        R0 
	CLRF        R1 
	RETURN      0
L_SPI_Ethernet_UserTCP2:
;SZZP_m.c,106 :: 		for (i = 0; i < 10; i++)  // B.J. OVDE JE BILO 5!!!
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP3:
	MOVLW       128
	XORWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP179
	MOVLW       10
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP179:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP4
;SZZP_m.c,108 :: 		getRequest[i] = SPI_Ethernet_getByte();
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+1 
	CALL        _SPI_Ethernet_getByte+0, 0
	MOVFF       FLOC__SPI_Ethernet_UserTCP+0, FSR1L
	MOVFF       FLOC__SPI_Ethernet_UserTCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SZZP_m.c,106 :: 		for (i = 0; i < 10; i++)  // B.J. OVDE JE BILO 5!!!
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;SZZP_m.c,109 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP3
L_SPI_Ethernet_UserTCP4:
;SZZP_m.c,110 :: 		getRequest[i] = 0;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;SZZP_m.c,112 :: 		if (memcmp(getRequest, httpMethod, 5))
	MOVLW       _getRequest+0
	MOVWF       FARG_memcmp_s1+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_memcmp_s1+1 
	MOVLW       _httpMethod+0
	MOVWF       FARG_memcmp_s2+0 
	MOVLW       hi_addr(_httpMethod+0)
	MOVWF       FARG_memcmp_s2+1 
	MOVLW       5
	MOVWF       FARG_memcmp_n+0 
	MOVLW       0
	MOVWF       FARG_memcmp_n+1 
	CALL        _memcmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP6
;SZZP_m.c,113 :: 		return (0);
	CLRF        R0 
	CLRF        R1 
	RETURN      0
L_SPI_Ethernet_UserTCP6:
;SZZP_m.c,115 :: 		if (getRequest[5] != 's')
	MOVF        _getRequest+5, 0 
	XORLW       115
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP7
;SZZP_m.c,117 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	RETURN      0
;SZZP_m.c,118 :: 		}
L_SPI_Ethernet_UserTCP7:
;SZZP_m.c,119 :: 		if (len == 0)
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP180
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
L__SPI_Ethernet_UserTCP180:
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP8
;SZZP_m.c,121 :: 		PORTA.F3=1;
	BSF         PORTA+0, 3 
;SZZP_m.c,124 :: 		formirajNiz();
	CALL        _formirajNiz+0, 0
;SZZP_m.c,125 :: 		len = putConstString(httpHeader);
	MOVLW       _httpHeader+0
	MOVWF       FARG_putConstString_s+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_putConstString_s+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_putConstString_s+2 
	CALL        _putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;SZZP_m.c,126 :: 		len += putConstString(httpMimeTypeHTML);
	MOVLW       _httpMimeTypeHTML+0
	MOVWF       FARG_putConstString_s+0 
	MOVLW       hi_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_putConstString_s+1 
	MOVLW       higher_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_putConstString_s+2 
	CALL        _putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;SZZP_m.c,127 :: 		len += putString("Start\n\n");
	MOVLW       ?lstr1_SZZP_m+0
	MOVWF       FARG_putString_s+0 
	MOVLW       hi_addr(?lstr1_SZZP_m+0)
	MOVWF       FARG_putString_s+1 
	CALL        _putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;SZZP_m.c,128 :: 		len += putString(niz);
	MOVLW       _niz+0
	MOVWF       FARG_putString_s+0 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FARG_putString_s+1 
	CALL        _putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;SZZP_m.c,129 :: 		PORTA.F3=0;
	BCF         PORTA+0, 3 
;SZZP_m.c,130 :: 		}
L_SPI_Ethernet_UserTCP8:
;SZZP_m.c,132 :: 		return (len); // return to the library with the number of bytes to transmit
	MOVF        SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       R0 
	MOVF        SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       R1 
;SZZP_m.c,133 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserTCP

_SPI_Ethernet_UserUDP:

;SZZP_m.c,135 :: 		unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
;SZZP_m.c,137 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;SZZP_m.c,138 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserUDP

_putConstString:

;SZZP_m.c,140 :: 		unsigned int putConstString(const char *s)
;SZZP_m.c,142 :: 		unsigned int ctr = 0;
	CLRF        putConstString_ctr_L0+0 
	CLRF        putConstString_ctr_L0+1 
;SZZP_m.c,143 :: 		while (*s)
L_putConstString9:
	MOVF        FARG_putConstString_s+0, 0 
	MOVWF       TBLPTRL 
	MOVF        FARG_putConstString_s+1, 0 
	MOVWF       TBLPTRH 
	MOVF        FARG_putConstString_s+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_putConstString10
;SZZP_m.c,145 :: 		SPI_Ethernet_putByte(*s++);
	MOVF        FARG_putConstString_s+0, 0 
	MOVWF       TBLPTRL 
	MOVF        FARG_putConstString_s+1, 0 
	MOVWF       TBLPTRH 
	MOVF        FARG_putConstString_s+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_SPI_Ethernet_putByte_v+0
	CALL        _SPI_Ethernet_putByte+0, 0
	MOVLW       1
	ADDWF       FARG_putConstString_s+0, 1 
	MOVLW       0
	ADDWFC      FARG_putConstString_s+1, 1 
	ADDWFC      FARG_putConstString_s+2, 1 
;SZZP_m.c,146 :: 		ctr++;
	INFSNZ      putConstString_ctr_L0+0, 1 
	INCF        putConstString_ctr_L0+1, 1 
;SZZP_m.c,147 :: 		}
	GOTO        L_putConstString9
L_putConstString10:
;SZZP_m.c,148 :: 		return (ctr);
	MOVF        putConstString_ctr_L0+0, 0 
	MOVWF       R0 
	MOVF        putConstString_ctr_L0+1, 0 
	MOVWF       R1 
;SZZP_m.c,149 :: 		}
	RETURN      0
; end of _putConstString

_putString:

;SZZP_m.c,151 :: 		unsigned int putString(char *s)
;SZZP_m.c,153 :: 		unsigned int ctr = 0;
	CLRF        putString_ctr_L0+0 
	CLRF        putString_ctr_L0+1 
;SZZP_m.c,154 :: 		while (*s)
L_putString11:
	MOVFF       FARG_putString_s+0, FSR0L
	MOVFF       FARG_putString_s+1, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_putString12
;SZZP_m.c,156 :: 		SPI_Ethernet_putByte(*s++);
	MOVFF       FARG_putString_s+0, FSR0L
	MOVFF       FARG_putString_s+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_SPI_Ethernet_putByte_v+0 
	CALL        _SPI_Ethernet_putByte+0, 0
	INFSNZ      FARG_putString_s+0, 1 
	INCF        FARG_putString_s+1, 1 
;SZZP_m.c,157 :: 		ctr++;
	INFSNZ      putString_ctr_L0+0, 1 
	INCF        putString_ctr_L0+1, 1 
;SZZP_m.c,158 :: 		}
	GOTO        L_putString11
L_putString12:
;SZZP_m.c,159 :: 		return (ctr);
	MOVF        putString_ctr_L0+0, 0 
	MOVWF       R0 
	MOVF        putString_ctr_L0+1, 0 
	MOVWF       R1 
;SZZP_m.c,160 :: 		}
	RETURN      0
; end of _putString

_dodajuNiz:

;SZZP_m.c,162 :: 		void dodajuNiz(char *p_ch)
;SZZP_m.c,164 :: 		while ((*p_ch) != 0x00)
L_dodajuNiz13:
	MOVFF       FARG_dodajuNiz_p_ch+0, FSR0L
	MOVFF       FARG_dodajuNiz_p_ch+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_dodajuNiz14
;SZZP_m.c,166 :: 		niz[br_ch] = *p_ch;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVFF       FARG_dodajuNiz_p_ch+0, FSR0L
	MOVFF       FARG_dodajuNiz_p_ch+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;SZZP_m.c,167 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;SZZP_m.c,168 :: 		p_ch++;
	INFSNZ      FARG_dodajuNiz_p_ch+0, 1 
	INCF        FARG_dodajuNiz_p_ch+1, 1 
;SZZP_m.c,169 :: 		}
	GOTO        L_dodajuNiz13
L_dodajuNiz14:
;SZZP_m.c,170 :: 		}
	RETURN      0
; end of _dodajuNiz

_formirajNiz:

;SZZP_m.c,172 :: 		void formirajNiz()
;SZZP_m.c,175 :: 		int i = 0;
	CLRF        formirajNiz_i_L0+0 
	CLRF        formirajNiz_i_L0+1 
;SZZP_m.c,177 :: 		br_ch = 0;   // pozicioniranje na pocetak niza
	CLRF        _br_ch+0 
;SZZP_m.c,179 :: 		for (i = 0; i < 32; i++)
	CLRF        formirajNiz_i_L0+0 
	CLRF        formirajNiz_i_L0+1 
L_formirajNiz15:
	MOVLW       128
	XORWF       formirajNiz_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__formirajNiz181
	MOVLW       32
	SUBWF       formirajNiz_i_L0+0, 0 
L__formirajNiz181:
	BTFSC       STATUS+0, 0 
	GOTO        L_formirajNiz16
;SZZP_m.c,181 :: 		if (Comm[i] == 1)
	MOVLW       _Comm+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Comm+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz18
;SZZP_m.c,183 :: 		dodajuNiz(room);
	MOVLW       _room+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(_room+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
;SZZP_m.c,184 :: 		ByteToStr(i, txt); // temperatura
	MOVF        formirajNiz_i_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       formirajNiz_txt_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(formirajNiz_txt_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;SZZP_m.c,185 :: 		dodajuNiz(txt);
	MOVLW       formirajNiz_txt_L0+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(formirajNiz_txt_L0+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
;SZZP_m.c,186 :: 		dodajuNiz(": ");
	MOVLW       ?lstr2_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr2_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
;SZZP_m.c,187 :: 		if (PIR[i] == 1)
	MOVLW       _PIR+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_PIR+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz19
;SZZP_m.c,188 :: 		dodajuNiz("PIR ");
	MOVLW       ?lstr3_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr3_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz19:
;SZZP_m.c,189 :: 		if (SMOKE[i] == 1)
	MOVLW       _SMOKE+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_SMOKE+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz20
;SZZP_m.c,190 :: 		dodajuNiz("SMOKE ");
	MOVLW       ?lstr4_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr4_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz20:
;SZZP_m.c,191 :: 		if (O2[i] == 1)
	MOVLW       _O2+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_O2+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz21
;SZZP_m.c,192 :: 		dodajuNiz("O2 ");
	MOVLW       ?lstr5_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr5_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz21:
;SZZP_m.c,193 :: 		if (DRILL[i] == 1)
	MOVLW       _DRILL+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DRILL+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz22
;SZZP_m.c,194 :: 		dodajuNiz("DRILL ");
	MOVLW       ?lstr6_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr6_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz22:
;SZZP_m.c,195 :: 		if (GAS[i] == 1)
	MOVLW       _GAS+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_GAS+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz23
;SZZP_m.c,196 :: 		dodajuNiz("GAS ");
	MOVLW       ?lstr7_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr7_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz23:
;SZZP_m.c,197 :: 		if (VENT[i] == 1)
	MOVLW       _VENT+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_VENT+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz24
;SZZP_m.c,198 :: 		dodajuNiz("VENT ");
	MOVLW       ?lstr8_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr8_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz24:
;SZZP_m.c,199 :: 		if (DOOR[i] == 1)
	MOVLW       _DOOR+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DOOR+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz25
;SZZP_m.c,200 :: 		dodajuNiz("DOOR ");
	MOVLW       ?lstr9_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr9_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz25:
;SZZP_m.c,201 :: 		if (SOUND[i] == 1)
	MOVLW       _SOUND+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_SOUND+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz26
;SZZP_m.c,202 :: 		dodajuNiz("SOUND ");
	MOVLW       ?lstr10_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr10_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
L_formirajNiz26:
;SZZP_m.c,203 :: 		dodajuNiz("TEMP:");
	MOVLW       ?lstr11_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr11_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
;SZZP_m.c,205 :: 		convert(Temperature[i]);
	MOVLW       _Temperature+0
	ADDWF       formirajNiz_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Temperature+0)
	ADDWFC      formirajNiz_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_convert_number+0 
	CALL        _convert+0, 0
;SZZP_m.c,206 :: 		niz[br_ch] = X10 + 0x30;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       48
	ADDWF       _X10+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SZZP_m.c,207 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;SZZP_m.c,208 :: 		niz[br_ch] = X1 + 0x30;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       48
	ADDWF       _X1+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;SZZP_m.c,209 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;SZZP_m.c,212 :: 		dodajuNiz("\n\n"); // temperatura
	MOVLW       ?lstr12_SZZP_m+0
	MOVWF       FARG_dodajuNiz_p_ch+0 
	MOVLW       hi_addr(?lstr12_SZZP_m+0)
	MOVWF       FARG_dodajuNiz_p_ch+1 
	CALL        _dodajuNiz+0, 0
;SZZP_m.c,213 :: 		}                      // od if(Comm[i]==1){
L_formirajNiz18:
;SZZP_m.c,179 :: 		for (i = 0; i < 32; i++)
	INFSNZ      formirajNiz_i_L0+0, 1 
	INCF        formirajNiz_i_L0+1, 1 
;SZZP_m.c,214 :: 		}                          // od for(i=0; i<16; i++)
	GOTO        L_formirajNiz15
L_formirajNiz16:
;SZZP_m.c,215 :: 		niz[br_ch] = 0x00;         // kraj stringa
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,216 :: 		}
	RETURN      0
; end of _formirajNiz

_init:

;SZZP_m.c,219 :: 		void init()
;SZZP_m.c,222 :: 		PIR1 = 0b00000000; // flegovi prijema preko UART-a
	CLRF        PIR1+0 
;SZZP_m.c,223 :: 		PIE1 = 0b00100001; // dozvola prekida za UART, RCIE, TMR1IE
	MOVLW       33
	MOVWF       PIE1+0 
;SZZP_m.c,229 :: 		T1CON = 0b10110000; // konfiguracija za tajmer1
	MOVLW       176
	MOVWF       T1CON+0 
;SZZP_m.c,230 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;SZZP_m.c,236 :: 		TMR1L = 0xB5;
	MOVLW       181
	MOVWF       TMR1L+0 
;SZZP_m.c,237 :: 		TMR1H = 0xB3;
	MOVLW       179
	MOVWF       TMR1H+0 
;SZZP_m.c,241 :: 		INTCON = 0b01000000; // periferijski interapt
	MOVLW       64
	MOVWF       INTCON+0 
;SZZP_m.c,242 :: 		INTCON.GIE = 1;      // globalna dozvola prekida
	BSF         INTCON+0, 7 
;SZZP_m.c,245 :: 		TRISA = 0x00; // objasniti u izvestaju
	CLRF        TRISA+0 
;SZZP_m.c,246 :: 		TRISB = 0x0F; // prekidaci na portovima od RB0 do RB3 su digitalni ulazi
	MOVLW       15
	MOVWF       TRISB+0 
;SZZP_m.c,247 :: 		TRISC = 0xD0; // 0b11010000
	MOVLW       208
	MOVWF       TRISC+0 
;SZZP_m.c,248 :: 		PORTA = 0x00;
	CLRF        PORTA+0 
;SZZP_m.c,249 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;SZZP_m.c,250 :: 		PORTC = 0x00;
	CLRF        PORTC+0 
;SZZP_m.c,254 :: 		ADCON0 = 0x00; // iskljucujemo A/D konverziju
	CLRF        ADCON0+0 
;SZZP_m.c,255 :: 		ADCON1 = 0x0F; // svi digitalni
	MOVLW       15
	MOVWF       ADCON1+0 
;SZZP_m.c,257 :: 		UART1_Init(19200);
	MOVLW       80
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;SZZP_m.c,259 :: 		TXSTA.TXEN = 1;
	BSF         TXSTA+0, 5 
;SZZP_m.c,260 :: 		RCSTA.SPEN = 1;
	BSF         RCSTA+0, 7 
;SZZP_m.c,261 :: 		RCSTA.CREN = 1;
	BSF         RCSTA+0, 4 
;SZZP_m.c,264 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;SZZP_m.c,265 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;SZZP_m.c,268 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;SZZP_m.c,269 :: 		SPI_Ethernet_Init(myMacAddr, myIpAddr, SPI_Ethernet_FULLDUPLEX); // inicijalizujemo Ethernet port
	MOVLW       _myMacAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_mac+0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_mac+1 
	MOVLW       _myIpAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_ip+0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_ip+1 
	MOVLW       1
	MOVWF       FARG_SPI_Ethernet_Init_fullDuplex+0 
	CALL        _SPI_Ethernet_Init+0, 0
;SZZP_m.c,270 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;SZZP_m.c,272 :: 		}
	RETURN      0
; end of _init

_init_variables:

;SZZP_m.c,274 :: 		void init_variables()
;SZZP_m.c,276 :: 		i = 0;
	CLRF        _i+0 
;SZZP_m.c,277 :: 		br = 0x00;
	CLRF        _br+0 
;SZZP_m.c,278 :: 		br_ch = 0x00;
	CLRF        _br_ch+0 
;SZZP_m.c,279 :: 		Flag1 = 0x00;
	CLRF        _Flag1+0 
;SZZP_m.c,280 :: 		ROOM_ID = 0x00;
	CLRF        _ROOM_ID+0 
;SZZP_m.c,281 :: 		OBB = 0x00;
	CLRF        _OBB+0 
;SZZP_m.c,282 :: 		for (i = 0; i < 150; i++)
	CLRF        _i+0 
L_init_variables27:
	MOVLW       150
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_init_variables28
;SZZP_m.c,283 :: 		niz[i] = 0x00;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,282 :: 		for (i = 0; i < 150; i++)
	INCF        _i+0, 1 
;SZZP_m.c,283 :: 		niz[i] = 0x00;
	GOTO        L_init_variables27
L_init_variables28:
;SZZP_m.c,284 :: 		stanjeDisp = 0;
	CLRF        _stanjeDisp+0 
;SZZP_m.c,286 :: 		for (i = 0; i < 32; i++)
	CLRF        _i+0 
L_init_variables30:
	MOVLW       32
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_init_variables31
;SZZP_m.c,288 :: 		PIR[i] = 0x00;
	MOVLW       _PIR+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_PIR+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,289 :: 		SMOKE[i] = 0x00;
	MOVLW       _SMOKE+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_SMOKE+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,290 :: 		O2[i] = 0x00;
	MOVLW       _O2+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_O2+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,291 :: 		DRILL[i] = 0x00;
	MOVLW       _DRILL+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_DRILL+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,292 :: 		GAS[i] = 0x00;
	MOVLW       _GAS+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_GAS+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,293 :: 		VENT[i] = 0x00;
	MOVLW       _VENT+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_VENT+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,294 :: 		DOOR[i] = 0x00;
	MOVLW       _DOOR+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_DOOR+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,295 :: 		SOUND[i] = 0x00;
	MOVLW       _SOUND+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_SOUND+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,296 :: 		Comm[i] = 0x00;
	MOVLW       _Comm+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,297 :: 		Temperature[i] = 0x00;
	MOVLW       _Temperature+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Temperature+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;SZZP_m.c,286 :: 		for (i = 0; i < 32; i++)
	INCF        _i+0, 1 
;SZZP_m.c,298 :: 		}
	GOTO        L_init_variables30
L_init_variables31:
;SZZP_m.c,299 :: 		}
	RETURN      0
; end of _init_variables

_LCDdisp:

;SZZP_m.c,303 :: 		void LCDdisp()
;SZZP_m.c,305 :: 		int i = 0;
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
;SZZP_m.c,306 :: 		if (stanjeDisp == 1)
	MOVF        _stanjeDisp+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp33
;SZZP_m.c,308 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp34
;SZZP_m.c,309 :: 		LCD_Out(1, 1, "DRILL (15-0)   1");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr13_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr13_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp35
L_LCDdisp34:
;SZZP_m.c,311 :: 		LCD_Out(1, 1, "DRILL (31-16)  1");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr14_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr14_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp35:
;SZZP_m.c,312 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp36:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp182
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp182:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp37
;SZZP_m.c,313 :: 		if (DRILL[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _DRILL+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DRILL+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp39
;SZZP_m.c,314 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp40
L_LCDdisp39:
;SZZP_m.c,316 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp40:
;SZZP_m.c,312 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,316 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp36
L_LCDdisp37:
;SZZP_m.c,317 :: 		}
	GOTO        L_LCDdisp41
L_LCDdisp33:
;SZZP_m.c,318 :: 		else if (stanjeDisp == 2)
	MOVF        _stanjeDisp+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp42
;SZZP_m.c,320 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp43
;SZZP_m.c,321 :: 		LCD_Out(1, 1, "O2 (15-0)      2");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr15_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr15_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp44
L_LCDdisp43:
;SZZP_m.c,323 :: 		LCD_Out(1, 1, "O2 (31-16)     2");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr16_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr16_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp44:
;SZZP_m.c,324 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp45:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp183
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp183:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp46
;SZZP_m.c,325 :: 		if (O2[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _O2+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_O2+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp48
;SZZP_m.c,326 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp49
L_LCDdisp48:
;SZZP_m.c,328 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp49:
;SZZP_m.c,324 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,328 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp45
L_LCDdisp46:
;SZZP_m.c,329 :: 		}
	GOTO        L_LCDdisp50
L_LCDdisp42:
;SZZP_m.c,330 :: 		else if (stanjeDisp == 3)
	MOVF        _stanjeDisp+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp51
;SZZP_m.c,332 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp52
;SZZP_m.c,333 :: 		LCD_Out(1, 1, "SMOKE (15-0)   3");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr17_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr17_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp53
L_LCDdisp52:
;SZZP_m.c,335 :: 		LCD_Out(1, 1, "SMOKE (31-16)  3");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr18_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr18_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp53:
;SZZP_m.c,336 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp54:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp184
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp184:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp55
;SZZP_m.c,337 :: 		if (SMOKE[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _SMOKE+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_SMOKE+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp57
;SZZP_m.c,338 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp58
L_LCDdisp57:
;SZZP_m.c,340 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp58:
;SZZP_m.c,336 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,340 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp54
L_LCDdisp55:
;SZZP_m.c,341 :: 		}
	GOTO        L_LCDdisp59
L_LCDdisp51:
;SZZP_m.c,342 :: 		else if (stanjeDisp == 4)
	MOVF        _stanjeDisp+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp60
;SZZP_m.c,344 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp61
;SZZP_m.c,345 :: 		LCD_Out(1, 1, "PIR (15-0)     4");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr19_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr19_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp62
L_LCDdisp61:
;SZZP_m.c,347 :: 		LCD_Out(1, 1, "PIR (31-16)    4");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr20_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr20_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp62:
;SZZP_m.c,348 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp63:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp185
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp185:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp64
;SZZP_m.c,349 :: 		if (PIR[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _PIR+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_PIR+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp66
;SZZP_m.c,350 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp67
L_LCDdisp66:
;SZZP_m.c,352 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp67:
;SZZP_m.c,348 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,352 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp63
L_LCDdisp64:
;SZZP_m.c,353 :: 		}
	GOTO        L_LCDdisp68
L_LCDdisp60:
;SZZP_m.c,354 :: 		else if (stanjeDisp == 5)
	MOVF        _stanjeDisp+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp69
;SZZP_m.c,356 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp70
;SZZP_m.c,357 :: 		LCD_Out(1, 1, "SOUND (15-0)   5");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr21_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr21_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp71
L_LCDdisp70:
;SZZP_m.c,359 :: 		LCD_Out(1, 1, "SOUND (31-16)  5");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr22_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr22_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp71:
;SZZP_m.c,360 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp72:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp186
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp186:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp73
;SZZP_m.c,361 :: 		if (SOUND[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _SOUND+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_SOUND+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp75
;SZZP_m.c,362 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp76
L_LCDdisp75:
;SZZP_m.c,364 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp76:
;SZZP_m.c,360 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,364 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp72
L_LCDdisp73:
;SZZP_m.c,365 :: 		}
	GOTO        L_LCDdisp77
L_LCDdisp69:
;SZZP_m.c,366 :: 		else if (stanjeDisp == 6)
	MOVF        _stanjeDisp+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp78
;SZZP_m.c,368 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp79
;SZZP_m.c,369 :: 		LCD_Out(1, 1, "DOORopen (15-0)6");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr23_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr23_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp80
L_LCDdisp79:
;SZZP_m.c,371 :: 		LCD_Out(1, 1, "DOORopen(31-16)6");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr24_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr24_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp80:
;SZZP_m.c,372 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp81:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp187
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp187:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp82
;SZZP_m.c,373 :: 		if (DOOR[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _DOOR+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DOOR+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp84
;SZZP_m.c,374 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp85
L_LCDdisp84:
;SZZP_m.c,376 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp85:
;SZZP_m.c,372 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,376 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp81
L_LCDdisp82:
;SZZP_m.c,377 :: 		}
	GOTO        L_LCDdisp86
L_LCDdisp78:
;SZZP_m.c,378 :: 		else if (stanjeDisp == 7)
	MOVF        _stanjeDisp+0, 0 
	XORLW       7
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp87
;SZZP_m.c,380 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp88
;SZZP_m.c,381 :: 		LCD_Out(1, 1, "VENT (15-0)    7");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr25_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr25_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp89
L_LCDdisp88:
;SZZP_m.c,383 :: 		LCD_Out(1, 1, "VENT (31-16)   7");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr26_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr26_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp89:
;SZZP_m.c,384 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp90:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp188
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp188:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp91
;SZZP_m.c,385 :: 		if (VENT[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _VENT+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_VENT+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp93
;SZZP_m.c,386 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp94
L_LCDdisp93:
;SZZP_m.c,388 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp94:
;SZZP_m.c,384 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,388 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp90
L_LCDdisp91:
;SZZP_m.c,389 :: 		}
	GOTO        L_LCDdisp95
L_LCDdisp87:
;SZZP_m.c,390 :: 		else if (stanjeDisp == 8)
	MOVF        _stanjeDisp+0, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp96
;SZZP_m.c,392 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp97
;SZZP_m.c,393 :: 		LCD_Out(1, 1, "GAS (15-0)     8");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr27_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr27_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp98
L_LCDdisp97:
;SZZP_m.c,395 :: 		LCD_Out(1, 1, "GAS (31-16)    8");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr28_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr28_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp98:
;SZZP_m.c,396 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp99:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp189
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp189:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp100
;SZZP_m.c,397 :: 		if (GAS[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _GAS+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_GAS+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp102
;SZZP_m.c,398 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp103
L_LCDdisp102:
;SZZP_m.c,400 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp103:
;SZZP_m.c,396 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,400 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp99
L_LCDdisp100:
;SZZP_m.c,401 :: 		}
	GOTO        L_LCDdisp104
L_LCDdisp96:
;SZZP_m.c,402 :: 		else if (stanjeDisp == 0)
	MOVF        _stanjeDisp+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp105
;SZZP_m.c,404 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp106
;SZZP_m.c,405 :: 		LCD_Out(1, 1, "Comm (15-0)    0");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr29_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr29_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_LCDdisp107
L_LCDdisp106:
;SZZP_m.c,407 :: 		LCD_Out(1, 1, "Comm (31-16)   0");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr30_SZZP_m+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr30_SZZP_m+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_LCDdisp107:
;SZZP_m.c,408 :: 		for (i = 0; i < 16; i++)
	CLRF        LCDdisp_i_L0+0 
	CLRF        LCDdisp_i_L0+1 
L_LCDdisp108:
	MOVLW       128
	XORWF       LCDdisp_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__LCDdisp190
	MOVLW       16
	SUBWF       LCDdisp_i_L0+0, 0 
L__LCDdisp190:
	BTFSC       STATUS+0, 0 
	GOTO        L_LCDdisp109
;SZZP_m.c,409 :: 		if (Comm[i + Offset] == 1)
	MOVF        _Offset+0, 0 
	ADDWF       LCDdisp_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      LCDdisp_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _Comm+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Comm+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_LCDdisp111
;SZZP_m.c,410 :: 		LCD_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_LCDdisp112
L_LCDdisp111:
;SZZP_m.c,412 :: 		LCD_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        LCDdisp_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_LCDdisp112:
;SZZP_m.c,408 :: 		for (i = 0; i < 16; i++)
	INFSNZ      LCDdisp_i_L0+0, 1 
	INCF        LCDdisp_i_L0+1, 1 
;SZZP_m.c,412 :: 		LCD_Chr(2, 16 - i, '0');
	GOTO        L_LCDdisp108
L_LCDdisp109:
;SZZP_m.c,413 :: 		}
L_LCDdisp105:
L_LCDdisp104:
L_LCDdisp95:
L_LCDdisp86:
L_LCDdisp77:
L_LCDdisp68:
L_LCDdisp59:
L_LCDdisp50:
L_LCDdisp41:
;SZZP_m.c,414 :: 		}
	RETURN      0
; end of _LCDdisp

_interrupt:

;SZZP_m.c,416 :: 		void interrupt()
;SZZP_m.c,418 :: 		unsigned char ch = 0x00;
	CLRF        interrupt_ch_L0+0 
;SZZP_m.c,420 :: 		if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
	BTFSS       PIE1+0, 0 
	GOTO        L_interrupt115
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt115
L__interrupt177:
;SZZP_m.c,423 :: 		PIE1.TMR1IE = 1;
	BSF         PIE1+0, 0 
;SZZP_m.c,424 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;SZZP_m.c,425 :: 		if (br >= 0x04)
	MOVLW       4
	SUBWF       _br+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_interrupt116
;SZZP_m.c,427 :: 		br = 0x00;
	CLRF        _br+0 
;SZZP_m.c,428 :: 		Flag1 = 0x01; // podigo se flag koji govori da je doslo vreme da se prozove slave(prostorija)
	MOVLW       1
	MOVWF       _Flag1+0 
;SZZP_m.c,429 :: 		}
	GOTO        L_interrupt117
L_interrupt116:
;SZZP_m.c,431 :: 		br++;
	INCF        _br+0, 1 
L_interrupt117:
;SZZP_m.c,432 :: 		if (tt > 0) // treperenje tastera
	MOVF        _tt+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt118
;SZZP_m.c,433 :: 		tt--;
	DECF        _tt+0, 1 
L_interrupt118:
;SZZP_m.c,435 :: 		if ((PORTB.F0 == 1) && (tt == 0))
	BTFSS       PORTB+0, 0 
	GOTO        L_interrupt121
	MOVF        _tt+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt121
L__interrupt176:
;SZZP_m.c,437 :: 		if (stanjeDisp == 8)
	MOVF        _stanjeDisp+0, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt122
;SZZP_m.c,438 :: 		stanjeDisp = 0;
	CLRF        _stanjeDisp+0 
	GOTO        L_interrupt123
L_interrupt122:
;SZZP_m.c,440 :: 		stanjeDisp++;
	INCF        _stanjeDisp+0, 1 
L_interrupt123:
;SZZP_m.c,441 :: 		tt = 20;
	MOVLW       20
	MOVWF       _tt+0 
;SZZP_m.c,442 :: 		}
L_interrupt121:
;SZZP_m.c,443 :: 		if ((PORTB.F1 == 1) && (tt == 0))
	BTFSS       PORTB+0, 1 
	GOTO        L_interrupt126
	MOVF        _tt+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt126
L__interrupt175:
;SZZP_m.c,445 :: 		if (stanjeDisp == 0)
	MOVF        _stanjeDisp+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt127
;SZZP_m.c,446 :: 		stanjeDisp = 8;
	MOVLW       8
	MOVWF       _stanjeDisp+0 
	GOTO        L_interrupt128
L_interrupt127:
;SZZP_m.c,448 :: 		stanjeDisp--;
	DECF        _stanjeDisp+0, 1 
L_interrupt128:
;SZZP_m.c,449 :: 		tt = 20;
	MOVLW       20
	MOVWF       _tt+0 
;SZZP_m.c,450 :: 		}
L_interrupt126:
;SZZP_m.c,451 :: 		if ((PORTB.F2 == 1) && (tt == 0))
	BTFSS       PORTB+0, 2 
	GOTO        L_interrupt131
	MOVF        _tt+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt131
L__interrupt174:
;SZZP_m.c,453 :: 		if (Offset == 0)
	MOVF        _Offset+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt132
;SZZP_m.c,454 :: 		Offset = 16;
	MOVLW       16
	MOVWF       _Offset+0 
	GOTO        L_interrupt133
L_interrupt132:
;SZZP_m.c,456 :: 		Offset = 0;
	CLRF        _Offset+0 
L_interrupt133:
;SZZP_m.c,457 :: 		tt = 20;
	MOVLW       20
	MOVWF       _tt+0 
;SZZP_m.c,458 :: 		}
L_interrupt131:
;SZZP_m.c,460 :: 		TMR1L = 0xB5;
	MOVLW       181
	MOVWF       TMR1L+0 
;SZZP_m.c,461 :: 		TMR1H = 0xB3;
	MOVLW       179
	MOVWF       TMR1H+0 
;SZZP_m.c,462 :: 		}
L_interrupt115:
;SZZP_m.c,464 :: 		if ((PIE1.RCIE == 1) && (PIR1.RCIF == 1))
	BTFSS       PIE1+0, 5 
	GOTO        L_interrupt136
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt136
L__interrupt173:
;SZZP_m.c,466 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;SZZP_m.c,467 :: 		ch = RCREG; // prima se bajt preko UART-a
	MOVF        RCREG+0, 0 
	MOVWF       interrupt_ch_L0+0 
;SZZP_m.c,468 :: 		if (OBB != 0x00)
	MOVF        _OBB+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt137
;SZZP_m.c,470 :: 		if (OBB == 0x03)
	MOVF        _OBB+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt138
;SZZP_m.c,475 :: 		if (((ch & 0x1F) == ROOM_ID) && ((ch & 0xE0) == 0xA0))
	MOVLW       31
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORWF       _ROOM_ID+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt141
	MOVLW       224
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       160
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt141
L__interrupt172:
;SZZP_m.c,478 :: 		OBB = 2;
	MOVLW       2
	MOVWF       _OBB+0 
;SZZP_m.c,479 :: 		} // komunikacija je dobra
L_interrupt141:
;SZZP_m.c,480 :: 		}
	GOTO        L_interrupt142
L_interrupt138:
;SZZP_m.c,481 :: 		else if (OBB == 0x02) // statusni bajt
	MOVF        _OBB+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt143
;SZZP_m.c,484 :: 		if ((ch & 0x01) == 0x01)
	MOVLW       1
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt144
;SZZP_m.c,485 :: 		DRILL[ROOM_ID] = 1;
	MOVLW       _DRILL+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_DRILL+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt145
L_interrupt144:
;SZZP_m.c,487 :: 		DRILL[ROOM_ID] = 0;
	MOVLW       _DRILL+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_DRILL+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt145:
;SZZP_m.c,488 :: 		if ((ch & 0x02) == 0x02)
	MOVLW       2
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt146
;SZZP_m.c,489 :: 		O2[ROOM_ID] = 1;
	MOVLW       _O2+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_O2+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt147
L_interrupt146:
;SZZP_m.c,491 :: 		O2[ROOM_ID] = 0;
	MOVLW       _O2+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_O2+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt147:
;SZZP_m.c,492 :: 		if ((ch & 0x04) == 0x04)
	MOVLW       4
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt148
;SZZP_m.c,493 :: 		SMOKE[ROOM_ID] = 1;
	MOVLW       _SMOKE+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_SMOKE+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt149
L_interrupt148:
;SZZP_m.c,495 :: 		SMOKE[ROOM_ID] = 0;
	MOVLW       _SMOKE+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_SMOKE+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt149:
;SZZP_m.c,496 :: 		if ((ch & 0x08) == 0x08)
	MOVLW       8
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt150
;SZZP_m.c,497 :: 		PIR[ROOM_ID] = 1;
	MOVLW       _PIR+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_PIR+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt151
L_interrupt150:
;SZZP_m.c,499 :: 		PIR[ROOM_ID] = 0;
	MOVLW       _PIR+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_PIR+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt151:
;SZZP_m.c,501 :: 		if ((ch & 0x10) == 0x10)
	MOVLW       16
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt152
;SZZP_m.c,502 :: 		SOUND[ROOM_ID] = 1;
	MOVLW       _SOUND+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_SOUND+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt153
L_interrupt152:
;SZZP_m.c,504 :: 		SOUND[ROOM_ID] = 0;
	MOVLW       _SOUND+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_SOUND+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt153:
;SZZP_m.c,505 :: 		if ((ch & 0x20) == 0x20)
	MOVLW       32
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt154
;SZZP_m.c,506 :: 		DOOR[ROOM_ID] = 1;
	MOVLW       _DOOR+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_DOOR+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt155
L_interrupt154:
;SZZP_m.c,508 :: 		DOOR[ROOM_ID] = 0;
	MOVLW       _DOOR+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_DOOR+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt155:
;SZZP_m.c,509 :: 		if ((ch & 0x40) == 0x40)
	MOVLW       64
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt156
;SZZP_m.c,510 :: 		VENT[ROOM_ID] = 1;
	MOVLW       _VENT+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_VENT+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt157
L_interrupt156:
;SZZP_m.c,512 :: 		VENT[ROOM_ID] = 0;
	MOVLW       _VENT+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_VENT+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt157:
;SZZP_m.c,513 :: 		if ((ch & 0x80) == 0x80)
	MOVLW       128
	ANDWF       interrupt_ch_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       128
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt158
;SZZP_m.c,514 :: 		GAS[ROOM_ID] = 1;
	MOVLW       _GAS+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_GAS+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
	GOTO        L_interrupt159
L_interrupt158:
;SZZP_m.c,516 :: 		GAS[ROOM_ID] = 0;
	MOVLW       _GAS+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_GAS+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
L_interrupt159:
;SZZP_m.c,518 :: 		OBB--; // OBB=1;
	DECF        _OBB+0, 1 
;SZZP_m.c,519 :: 		}
	GOTO        L_interrupt160
L_interrupt143:
;SZZP_m.c,520 :: 		else if (OBB == 0x01) // Statusni za temperaturu
	MOVF        _OBB+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt161
;SZZP_m.c,522 :: 		Temperature[ROOM_ID] = ch;
	MOVLW       _Temperature+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Temperature+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        interrupt_ch_L0+0, 0 
	MOVWF       POSTINC1+0 
;SZZP_m.c,523 :: 		OBB = 0;
	CLRF        _OBB+0 
;SZZP_m.c,524 :: 		}
L_interrupt161:
L_interrupt160:
L_interrupt142:
;SZZP_m.c,525 :: 		}
L_interrupt137:
;SZZP_m.c,526 :: 		}
L_interrupt136:
;SZZP_m.c,527 :: 		}
L__interrupt191:
	RETFIE      1
; end of _interrupt

_transmit:

;SZZP_m.c,529 :: 		void transmit(unsigned char podaci)
;SZZP_m.c,531 :: 		TXREG = podaci;
	MOVF        FARG_transmit_podaci+0, 0 
	MOVWF       TXREG+0 
;SZZP_m.c,532 :: 		while (!TXSTA.TRMT)
L_transmit162:
	BTFSC       TXSTA+0, 1 
	GOTO        L_transmit163
;SZZP_m.c,533 :: 		;
	GOTO        L_transmit162
L_transmit163:
;SZZP_m.c,534 :: 		}
	RETURN      0
; end of _transmit

_main:

;SZZP_m.c,536 :: 		void main()
;SZZP_m.c,538 :: 		unsigned char ByteX = 0x00;
;SZZP_m.c,539 :: 		init();
	CALL        _init+0, 0
;SZZP_m.c,540 :: 		init_variables();
	CALL        _init_variables+0, 0
;SZZP_m.c,541 :: 		LCDdisp();
	CALL        _LCDdisp+0, 0
;SZZP_m.c,543 :: 		while (1)
L_main164:
;SZZP_m.c,545 :: 		SPI_Ethernet_doPacket();
	CALL        _SPI_Ethernet_doPacket+0, 0
;SZZP_m.c,546 :: 		if (Flag1 == 1)
	MOVF        _Flag1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main166
;SZZP_m.c,548 :: 		Flag1 = 0;
	CLRF        _Flag1+0 
;SZZP_m.c,551 :: 		if (OBB>0) Comm[ROOM_ID]=0;
	MOVF        _OBB+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_main167
	MOVLW       _Comm+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
	GOTO        L_main168
L_main167:
;SZZP_m.c,552 :: 		else Comm[ROOM_ID]=1;
	MOVLW       _Comm+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR1H 
	MOVF        _ROOM_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
L_main168:
;SZZP_m.c,554 :: 		PORTA.F2=0;
	BCF         PORTA+0, 2 
;SZZP_m.c,555 :: 		if (ROOM_ID >= 31) {
	MOVLW       31
	SUBWF       _ROOM_ID+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main169
;SZZP_m.c,556 :: 		ROOM_ID = 0;
	CLRF        _ROOM_ID+0 
;SZZP_m.c,557 :: 		PORTA.F2=1;
	BSF         PORTA+0, 2 
;SZZP_m.c,558 :: 		}
	GOTO        L_main170
L_main169:
;SZZP_m.c,560 :: 		ROOM_ID++;
	INCF        _ROOM_ID+0, 1 
L_main170:
;SZZP_m.c,562 :: 		ByteX = 0b10100000 + ROOM_ID;
	MOVF        _ROOM_ID+0, 0 
	ADDLW       160
	MOVWF       FARG_transmit_podaci+0 
;SZZP_m.c,563 :: 		Ctrl = 1;
	BSF         PORTA+0, 5 
;SZZP_m.c,564 :: 		transmit(ByteX);
	CALL        _transmit+0, 0
;SZZP_m.c,565 :: 		Ctrl = 0;
	BCF         PORTA+0, 5 
;SZZP_m.c,566 :: 		OBB = 3; // svake sekunde ozvezavanje displeja
	MOVLW       3
	MOVWF       _OBB+0 
;SZZP_m.c,567 :: 		if ((ROOM_ID & 0b00000011) == 0x00)
	MOVLW       3
	ANDWF       _ROOM_ID+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main171
;SZZP_m.c,568 :: 		LCDdisp();
	CALL        _LCDdisp+0, 0
L_main171:
;SZZP_m.c,569 :: 		}
L_main166:
;SZZP_m.c,570 :: 		}
	GOTO        L_main164
;SZZP_m.c,571 :: 		}
	GOTO        $+0
; end of _main
