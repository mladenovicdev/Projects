#line 1 "D:/Users/Borko/Predmeti/Projektovanje elektronskih sistema/Studenti2022/Projekti/SistemZaZastituOdPozara/MASTER/SZZP_m.c"








typedef struct
{
 unsigned canCloseTCP : 1;
 unsigned isBroadcast : 1;
} TEthPktFlags;

const unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type:";
const unsigned char httpMimeTypeHTML[] = "text/html\n\n";
const unsigned char httpMimeTypeScript[] = "text/plain\n\n";
unsigned char httpMethod[] = "GET /";



sfr sbit SPI_Ethernet_Rst at RA1_bit;
sfr sbit SPI_Ethernet_CS at RA0_bit;
sfr sbit SPI_Ethernet_Rst_Direction at TRISA1_bit;
sfr sbit SPI_Ethernet_CS_Direction at TRISA0_bit;

unsigned char myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f};

unsigned char myIpAddr[4] = {192, 168, 1, 7};

unsigned char getRequest[15];
unsigned char dyna[31];
unsigned char httpCounter = 0;

unsigned char niz[150];


sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC2_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;


sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;


unsigned char i=0;
unsigned char br_ch=0;
unsigned char Flag1 =0;
unsigned char br =0;
unsigned char ROOM_ID=0;
unsigned char OBB=0;

unsigned char room[] = "SOBA ";



unsigned char PIR[32];
unsigned char SMOKE[32];
unsigned char O2[32];
unsigned char DRILL[32];
unsigned char GAS[32];
unsigned char VENT[32];
unsigned char DOOR[32];
unsigned char SOUND[32];
unsigned char Comm[32];
unsigned char Temperature[32];


unsigned char stanjeDisp = 0x00;
unsigned char Offset = 0x00;

unsigned char X1 = 0x00;
unsigned char X10 = 0x00;
unsigned char tt = 0x00;

unsigned int putConstString(const char *s);
void formirajNiz();
unsigned int putString(char *s);

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

unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, char *canClose)
{
 int len = 0;
 int i = 0;
 if (localPort != 80)
 return (0);

 for (i = 0; i < 10; i++)
 {
 getRequest[i] = SPI_Ethernet_getByte();
 }
 getRequest[i] = 0;

 if (memcmp(getRequest, httpMethod, 5))
 return (0);

 if (getRequest[5] != 's')
 {
 return 0;
 }
 if (len == 0)
 {
 PORTA.F3=1;


 formirajNiz();
 len = putConstString(httpHeader);
 len += putConstString(httpMimeTypeHTML);
 len += putString("Start\n\n");
 len += putString(niz);
 PORTA.F3=0;
 }

 return (len);
}

unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
{
 return 0;
}

unsigned int putConstString(const char *s)
{
 unsigned int ctr = 0;
 while (*s)
 {
 SPI_Ethernet_putByte(*s++);
 ctr++;
 }
 return (ctr);
}

unsigned int putString(char *s)
{
 unsigned int ctr = 0;
 while (*s)
 {
 SPI_Ethernet_putByte(*s++);
 ctr++;
 }
 return (ctr);
}

void dodajuNiz(char *p_ch)
{
 while ((*p_ch) != 0x00)
 {
 niz[br_ch] = *p_ch;
 br_ch++;
 p_ch++;
 }
}

void formirajNiz()
{

 int i = 0;
 char txt[4];
 br_ch = 0;

 for (i = 0; i < 32; i++)
 {
 if (Comm[i] == 1)
 {
 dodajuNiz(room);
 ByteToStr(i, txt);
 dodajuNiz(txt);
 dodajuNiz(": ");
 if (PIR[i] == 1)
 dodajuNiz("PIR ");
 if (SMOKE[i] == 1)
 dodajuNiz("SMOKE ");
 if (O2[i] == 1)
 dodajuNiz("O2 ");
 if (DRILL[i] == 1)
 dodajuNiz("DRILL ");
 if (GAS[i] == 1)
 dodajuNiz("GAS ");
 if (VENT[i] == 1)
 dodajuNiz("VENT ");
 if (DOOR[i] == 1)
 dodajuNiz("DOOR ");
 if (SOUND[i] == 1)
 dodajuNiz("SOUND ");
 dodajuNiz("TEMP:");

 convert(Temperature[i]);
 niz[br_ch] = X10 + 0x30;
 br_ch++;
 niz[br_ch] = X1 + 0x30;
 br_ch++;


 dodajuNiz("\n\n");
 }
 }
 niz[br_ch] = 0x00;
}


void init()
{

 PIR1 = 0b00000000;
 PIE1 = 0b00100001;





 T1CON = 0b10110000;
 T1CON.TMR1ON = 1;





 TMR1L = 0xB5;
 TMR1H = 0xB3;



 INTCON = 0b01000000;
 INTCON.GIE = 1;


 TRISA = 0x00;
 TRISB = 0x0F;
 TRISC = 0xD0;
 PORTA = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;



 ADCON0 = 0x00;
 ADCON1 = 0x0F;

 UART1_Init(19200);

 TXSTA.TXEN = 1;
 RCSTA.SPEN = 1;
 RCSTA.CREN = 1;


 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);


 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 SPI_Ethernet_Init(myMacAddr, myIpAddr,  1 );
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

}

void init_variables()
{
 i = 0;
 br = 0x00;
 br_ch = 0x00;
 Flag1 = 0x00;
 ROOM_ID = 0x00;
 OBB = 0x00;
 for (i = 0; i < 150; i++)
 niz[i] = 0x00;
 stanjeDisp = 0;

 for (i = 0; i < 32; i++)
 {
 PIR[i] = 0x00;
 SMOKE[i] = 0x00;
 O2[i] = 0x00;
 DRILL[i] = 0x00;
 GAS[i] = 0x00;
 VENT[i] = 0x00;
 DOOR[i] = 0x00;
 SOUND[i] = 0x00;
 Comm[i] = 0x00;
 Temperature[i] = 0x00;
 }
}



void LCDdisp()
{
 int i = 0;
 if (stanjeDisp == 1)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "DRILL (15-0)   1");
 else
 LCD_Out(1, 1, "DRILL (31-16)  1");
 for (i = 0; i < 16; i++)
 if (DRILL[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 2)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "O2 (15-0)      2");
 else
 LCD_Out(1, 1, "O2 (31-16)     2");
 for (i = 0; i < 16; i++)
 if (O2[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 3)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "SMOKE (15-0)   3");
 else
 LCD_Out(1, 1, "SMOKE (31-16)  3");
 for (i = 0; i < 16; i++)
 if (SMOKE[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 4)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "PIR (15-0)     4");
 else
 LCD_Out(1, 1, "PIR (31-16)    4");
 for (i = 0; i < 16; i++)
 if (PIR[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 5)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "SOUND (15-0)   5");
 else
 LCD_Out(1, 1, "SOUND (31-16)  5");
 for (i = 0; i < 16; i++)
 if (SOUND[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 6)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "DOORopen (15-0)6");
 else
 LCD_Out(1, 1, "DOORopen(31-16)6");
 for (i = 0; i < 16; i++)
 if (DOOR[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 7)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "VENT (15-0)    7");
 else
 LCD_Out(1, 1, "VENT (31-16)   7");
 for (i = 0; i < 16; i++)
 if (VENT[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 8)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "GAS (15-0)     8");
 else
 LCD_Out(1, 1, "GAS (31-16)    8");
 for (i = 0; i < 16; i++)
 if (GAS[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
 else if (stanjeDisp == 0)
 {
 if (Offset == 0)
 LCD_Out(1, 1, "Comm (15-0)    0");
 else
 LCD_Out(1, 1, "Comm (31-16)   0");
 for (i = 0; i < 16; i++)
 if (Comm[i + Offset] == 1)
 LCD_Chr(2, 16 - i, '1');
 else
 LCD_Chr(2, 16 - i, '0');
 }
}

void interrupt()
{
 unsigned char ch = 0x00;

 if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
 {

 PIE1.TMR1IE = 1;
 PIR1.TMR1IF = 0;
 if (br >= 0x04)
 {
 br = 0x00;
 Flag1 = 0x01;
 }
 else
 br++;
 if (tt > 0)
 tt--;

 if ((PORTB.F0 == 1) && (tt == 0))
 {
 if (stanjeDisp == 8)
 stanjeDisp = 0;
 else
 stanjeDisp++;
 tt = 20;
 }
 if ((PORTB.F1 == 1) && (tt == 0))
 {
 if (stanjeDisp == 0)
 stanjeDisp = 8;
 else
 stanjeDisp--;
 tt = 20;
 }
 if ((PORTB.F2 == 1) && (tt == 0))
 {
 if (Offset == 0)
 Offset = 16;
 else
 Offset = 0;
 tt = 20;
 }

 TMR1L = 0xB5;
 TMR1H = 0xB3;
 }

 if ((PIE1.RCIE == 1) && (PIR1.RCIF == 1))
 {
 PIR1.RCIF = 0;
 ch = RCREG;
 if (OBB != 0x00)
 {
 if (OBB == 0x03)
 {



 if (((ch & 0x1F) == ROOM_ID) && ((ch & 0xE0) == 0xA0))
 {

 OBB = 2;
 }
 }
 else if (OBB == 0x02)
 {

 if ((ch & 0x01) == 0x01)
 DRILL[ROOM_ID] = 1;
 else
 DRILL[ROOM_ID] = 0;
 if ((ch & 0x02) == 0x02)
 O2[ROOM_ID] = 1;
 else
 O2[ROOM_ID] = 0;
 if ((ch & 0x04) == 0x04)
 SMOKE[ROOM_ID] = 1;
 else
 SMOKE[ROOM_ID] = 0;
 if ((ch & 0x08) == 0x08)
 PIR[ROOM_ID] = 1;
 else
 PIR[ROOM_ID] = 0;

 if ((ch & 0x10) == 0x10)
 SOUND[ROOM_ID] = 1;
 else
 SOUND[ROOM_ID] = 0;
 if ((ch & 0x20) == 0x20)
 DOOR[ROOM_ID] = 1;
 else
 DOOR[ROOM_ID] = 0;
 if ((ch & 0x40) == 0x40)
 VENT[ROOM_ID] = 1;
 else
 VENT[ROOM_ID] = 0;
 if ((ch & 0x80) == 0x80)
 GAS[ROOM_ID] = 1;
 else
 GAS[ROOM_ID] = 0;

 OBB--;
 }
 else if (OBB == 0x01)
 {
 Temperature[ROOM_ID] = ch;
 OBB = 0;
 }
 }
 }
}

void transmit(unsigned char podaci)
{
 TXREG = podaci;
 while (!TXSTA.TRMT)
 ;
}

void main()
{
 unsigned char ByteX = 0x00;
 init();
 init_variables();
 LCDdisp();

 while (1)
 {
 SPI_Ethernet_doPacket();
 if (Flag1 == 1)
 {
 Flag1 = 0;


 if (OBB>0) Comm[ROOM_ID]=0;
 else Comm[ROOM_ID]=1;

 PORTA.F2=0;
 if (ROOM_ID >= 31) {
 ROOM_ID = 0;
 PORTA.F2=1;
 }
 else
 ROOM_ID++;

 ByteX = 0b10100000 + ROOM_ID;
  PORTA.F5  = 1;
 transmit(ByteX);
  PORTA.F5  = 0;
 OBB = 3;
 if ((ROOM_ID & 0b00000011) == 0x00)
 LCDdisp();
 }
 }
}
