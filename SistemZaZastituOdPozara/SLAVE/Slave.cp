#line 1 "D:/Users/Borko/Predmeti/Projektovanje elektronskih sistema/Studenti2022/Projekti/SistemZaZastituOdPozara/SLAVE/Slave.c"
#line 20 "D:/Users/Borko/Predmeti/Projektovanje elektronskih sistema/Studenti2022/Projekti/SistemZaZastituOdPozara/SLAVE/Slave.c"
sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC2_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;


sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;


unsigned char byteX = 0x00;
unsigned char Temperature = 0x00;
bit m_bSmoke;
bit m_bDrill;
bit m_bO2;
bit m_bPir;
bit m_bVent;
bit m_bDoorOpen;
bit m_bSound;
bit m_bGas;

unsigned char tt = 0x00;
unsigned char State = 0x00;
unsigned char Tajmer = 0x00;
unsigned char displej = 0x00;
unsigned char X1= 0x00;
unsigned char X10 = 0x00;

unsigned int i= 0x00;
unsigned char br = 0;
unsigned char ch = 0;
unsigned char RAMP_ID = 0;
bit Flag1;
bit CallFlag;
unsigned Command = 0;

void transmitByte(unsigned char bajt)
{
 TXREG = bajt;
 while (!TXSTA.TRMT)
 ;
}

unsigned char ad_convert()
{
 unsigned int temp = 0x0000;
 int i = 0;

 for (i = 1; i < 30; i++)
 ;
 ADCON0.GO_DONE = 1;
 while (ADCON0.GO_DONE)
 ;
 temp = (ADRESH << 8) + ADRESL;
 temp = temp >> 3;

 if (temp > 99)
 temp = 99;
 return ((unsigned char)temp);
}

void convert(unsigned char number)
{
 X1 = number;
 X10 = 0;
 while (X1 > 9)
 {
 X1 = X1 - 10;
 X10++;
 }
}

void updateLCD()
{
 if (displej == 0)
 {
 LCD_Out(1, 1, "PI SM 02  DR TE ");
 LCD_Out(2, 1, " X  X  X   X XX ");
 LCD_Chr(2, 2, m_bPir + 0x30);
 LCD_Chr(2, 5, m_bSmoke + 0x30);
 LCD_Chr(2, 8, m_bO2 + 0x30);
 LCD_Chr(2, 12, m_bDrill + 0x30);
 convert(Temperature);
 LCD_Chr(2, 14, X10 + 0x30);
 LCD_Chr(2, 15, X1 + 0x30);
 }
 else
 {
 LCD_Out(1, 1, "GA VE DO  Z S TA");
 LCD_Out(2, 1, " X  X  X  X X XX");
 LCD_Chr(2, 2, m_bGas + 0x30);
 LCD_Chr(2, 5, m_bVent + 0x30);
 LCD_Chr(2, 8, m_bDoorOpen + 0x30);
 LCD_Chr(2, 11, m_bSound + 0x30);
 LCD_Chr(2, 13, State + 0x30);
 convert(Tajmer);
 LCD_Chr(2, 15, X10 + 0x30);
 LCD_Chr(2, 16, X1 + 0x30);
 }
}

void processInputs()
{
 Temperature = ad_convert();

 m_bSmoke =  PORTD.F1 ;
 m_bDrill =  PORTD.F3 ;
 m_bO2 =  PORTD.F2 ;
 m_bPir =  PORTD.F0 ;

 m_bVent = 0;
 m_bDoorOpen = 0;
 m_bSound = 0;
 m_bGas = 0;

 if (Tajmer > 0)
 Tajmer--;
 switch (State)
 {
 case 0:
 m_bVent = 1;
 m_bDoorOpen = 1;
 if ((m_bSmoke == 1) || (Temperature > 50))
 {
 State = 1;
 Tajmer = 10;
 }
 else
 State = 0;
 break;
 case 1:
 m_bSound = 1;
 m_bDoorOpen = 1;
 m_bVent = 1;

 if ((Tajmer > 0) || ((Tajmer == 0) && (m_bPir == 1)))
 {
 State = 1;

 }
 else
 {
 State = 2;
 Tajmer = 10;
 }
 break;
 case 2:
 m_bSound = 1;
 if ((Tajmer == 0) && (m_bPir == 0))
 State = 3;
 else if ((Tajmer > 0) || ((Tajmer == 0) && (m_bPir == 1)))
 State = 2;
 break;
 case 3:
 m_bSound = 1;
 m_bGas = 1;
 if (m_bO2 == 1)
 State = 3;
 else
 {
 State = 4;
 Tajmer = 10;
 }
 break;
 case 4:
 m_bSound = 1;
 if ((m_bO2 == 0) && (Tajmer == 0))
 {
 State = 5;
 Tajmer = 10;
 }
 else if (Tajmer == 0)
 State = 3;
 else
 State = 4;
 break;
 case 5:
 m_bSound = 1;
 m_bVent = 1;
 if (m_bO2 == 0)
 State = 5;

 else if (Tajmer == 0)
 {
 State = 6;
 Tajmer = 10;
 }
 else
 State = 5;
 break;
 case 6:

 m_bVent = 1;
 m_bSound = 1;
 if (Tajmer == 0)
 if ((m_bSmoke == 1) || (Temperature > 50))
 {
 State = 1;
 Tajmer = 10;
 }
 else if (Tajmer > 0)
 State = 6;
 else
 State = 0;
 break;
 }

  PORTA.F2  = m_bGAS;
  PORTA.F3  = m_bSound;
  PORTA.F4  = m_bDoorOpen;
}

void init()
{

 TRISA = 0x03;
 TRISB = 0x3F;
 TRISC = 0xC0;


 TRISD = 0x0F;


 PORTA = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;
 PORTD = 0x00;

 ADCON0 = 0x81;
 ADCON1 = 0b10001110;
 INTCON = 0b11000000;
 PIE1 = 0b00000000;
 T1CON = 0b00110000;
 TMR1H = 0x0B;
 TMR1L = 0xDC;
 T1CON.TMR1ON = 1;

 PIR1.TMR1IF = 0;
 PIE1.TMR1IE = 1;

 Uart1_Init(19200);

 TXSTA.TXEN = 1;
 RCSTA.SPEN = 1;
 RCSTA.CREN = 1;

 PIE1.RCIE = 1;
 INTCON.GIE = 1;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
}

void init_variables()
{
 byteX = 0;
 Temperature = 0;
 m_bSmoke = 0;
 m_bDrill = 0;
 m_bO2 = 0;
 m_bPir = 0;
 m_bVent = 0;
 m_bDoorOpen = 0;
 m_bSound = 0;
 m_bGas = 0;

 State = 0;
 Tajmer = 0;
 displej = 0;
 X1 = 0;
 X10 = 0;
 Flag1 = 0;
 CallFlag = 0;
}

void interrupt()
{
 if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
 {

 PIR1.TMR1IF = 0;
 if (br == 0x09)
 {
 br = 0x00;
 Flag1 = 0x01;
 }
 else
 br++;

 if (tt > 0)
 tt--;
 if ( PORTB.F3  && (!tt))
 {
 if (displej < 1)
 displej++;
 else
 displej = 0;
 tt = 4;
 }
 TMR1H = 0x0B;
 TMR1L = 0xDC;
 }

 if ((PIE1.RCIE) && (PIR1.RCIF))
 {
 ch = RCREG;
 PIR1.RCIF = 0;
 if (((ch & 0x1F) == RAMP_ID) && ((ch & 0xE0) == 0xA0))
 {
 Command = ch;
 CallFlag = 1;
 }
 }
}

void main()
{
 init();
 init_variables();
 processInputs();
 updateLCD();
 while (1)
 {
 if (Flag1 == 1)
 {
 Flag1 = 0;
 processInputs();
 updateLCD();
 }
 if (CallFlag == 1)
 {

 CallFlag = 0;
  PORTC.F5  = 1;
 transmitByte(Command);
 byteX = 0x00;
 if (m_bPir == 1)
 byteX = byteX + 8;
 if (m_bSmoke == 1)
 byteX = byteX + 4;
 if (m_bO2 == 1)
 byteX = byteX + 2;
 if (m_bDrill == 1)
 byteX = byteX + 1;
 if (m_bSound == 1)
 byteX = byteX + 16;
 if (m_bDoorOpen == 1)
 byteX = byteX + 32;
 if (m_bVent == 1)
 byteX = byteX + 64;
 if (m_bGas == 1)
 byteX = byteX + 128;
 transmitByte(byteX);
 transmitByte(Temperature);
  PORTC.F5  = 0;
 }
 }
}
