#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/delay.h>

// 매크로 함수
#define sbi(p,m) p |= (1<<m)  // m번째 bit를 1로 만드는 함수
#define cbi(p,m) p &= ~(1<<m) // m번째 bit를 0으로 만드는 함수

unsigned int cnt = 0;
unsigned int adc[4]; // ADC값을 각각 저장할 배열
unsigned int get_adc(int); // 4byte = 16bit
// 10bit의 ADC값을 반환해주어야 하기 때문
void USART1_Transmit( unsigned char data ); // USART1 송신
void USART1_TransNum(int num); // int형 data를 uart1으로 전송해 출력

void set_GPIO(void)
{
	// ADC 0~3 INPUT
	cbi(DDRF, 0);
	cbi(DDRF, 1);
	cbi(DDRF, 2);
	cbi(DDRF, 3);
	
	cbi(DDRD, 2); // USART1 RXD1 INPUT
	sbi(DDRD, 3); // USART1 TXD1 OUTPUT
	
	cbi(DDRB, 7); // OC2 OUTPUT
}

void set_USART1(void) // USART1 Register 설정
{
	UCSR1A = 0x00;
	UCSR1B = 0x18;    // RX, TX 활성화
	UCSR1C = 0x06;  // Character Size 8bit로 설정
	UBRR1L = 8;      // 115200bps
}

void set_TIMER2(void) // Timer2 Setting
{
	TCCR2   = (1<<WGM20)|(1<<WGM21)|(1<<COM21)|(0<<COM20)|(1<<CS22)|(0<<CS21)|(1<<CS20);
	// Fast PWM mode / Clear OC2 on compare match, set OC2 at BOTTOM / 분주비 1024
	TIMSK   = (1<<TOIE2);   // Timer/Counter2 Overflow Interrupt 활성화
	TCNT2   = 255-156;  // = 99 // 정확하게 나누어 떨어지진 않음 (원래는 98.5번이 정확함)
}

void set_ADC(void)
{
	ADMUX   = (0<<REFS1)|(1<<REFS0)|(0<<ADLAR);
	// AVCC with external capacitor at AREF pin, ADC Left Adjust Result
	ADCSRA   = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	// ADC Enable / ADC prescaler Select bit는 128로 설정
}

ISR(TIMER2_OVF_vect) // 10ms
{
	
	cli(); // 제어주기 내에서 이루어지는 것들이 우선이기 때문
	// get Sensor
	for(int i=0;i<4;i++) adc[i] = get_adc(i); // 0~3번까지의 ADC값을 받아온다.
	
	for(int i=0;i<3;i++) {
		USART1_TransNum(adc[i]);
		USART1_Transmit(',');
	} // ADC값을 송신
	USART1_TransNum(adc[3]);
	USART1_Transmit(0x0d);
	
	// 휴지기가 제어주기의 20%는 되어야 함
	TCNT2 = 255-156;
	// TCNT2 값을 99로 초기화 함으로써 다시 10ms후 Overflow Intterupt가 발생하게 함
	
	cnt++;
	sei(); // 다시 전역 인터럽트 활성화
}

int main(void)
{
	set_GPIO();
	set_USART1();
	set_TIMER2();
	set_ADC();
	sei();   // 전역 인터럽트 활성화

	while (1);
}

unsigned int get_adc(int id) // MUX값을 update하기 위한 함수
{
	ADMUX = (ADMUX & 0b11100000) | id;
	// 상위 3bit의 register 설정은 유지해주면서
	// MUX 값을 id와 'or 연산'함으로써 update
	
	cbi(ADCSRA, ADIF); // ADIF를 0으로 만듦, ADC Interrupt Flag를 Disable
	sbi(ADCSRA, ADSC); // ADC Conversion 시작
	
	while(!((ADCSRA)&(1<<ADIF))); // 대략 25pulse 가 걸림
	return ADC; // ADC는 10bit
}

void USART1_Transmit( unsigned char data ) // USART1 송신
{
	// UDR 값이 비었는지 확인(비어있으면 대기)
	while ( !( UCSR1A & (1<<UDRE)) );
	// buffer안에 데이터가 들어오면 데이터를 송신
	UDR1 = data; // UDR1에 들어온 data를 저장한다.
}

void USART1_TransNum(int num) // int형 data를 uart1으로 전송해 출력
{
	int j;
	if(num < 0) // data가 음수라면
	{
		USART1_Transmit('-'); // -를 출력해주고
		num = -num; // 절댓값 처리해준다.
	}
	
	for(j = 1000 ; j > 0; j /= 10) // 10000의 자리수터 천천히 출력
	{
		USART1_Transmit((num/j) + 48);
		// 아스키 코드로 '0'은 48이므로 48을 더해 송신한다.
		num %= j; // 첫번째 자리를 제외한다. (예. 12345면 2345로 만듦)
	}
}