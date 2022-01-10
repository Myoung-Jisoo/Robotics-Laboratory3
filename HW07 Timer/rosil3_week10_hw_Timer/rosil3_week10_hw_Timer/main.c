#include <avr/io.h>
#include <avr/interrupt.h>

double top = 0.0;
unsigned int servo;

ISR(TIMER2_OVF_vect) // 10ms
{
	cli(); // 제어주기 내에서 이루어지는 것들이 우선이기 때문
	PORTA = 0x00; // 제어주기가 10ms가 맞는지 확인하기 위해 LED 켬
	PORTB = 0x20; // 서보모터 OC1A 출력
	
	// Control
	OCR1A = servo;
	
	// Output
	PORTA = 0xff; // LED 끄기
	PORTB = 0x00; // 서보모터 OC1A 출력을 끔
	// 휴지기가 제어주기의 20%는 되어야 함
	TCNT2 = 255-156;
	// TCNT2 값을 99로 초기화 함으로써 다시 10ms후 Overflow Intterupt가 발생하게 함
	sei(); // 다시 전역 인터럽트 활성화
}

ISR(INT0_vect)
{
	servo = top * (0.5 / 20.0); // = 3000
	// 0.5ms가 되므로 0도
}

ISR(INT1_vect)
{
	servo = top * (2.5 / 20.0); // = 5000
	// 2.5ms가 되므로 180도
}

int main(void)
{
	/* Replace with your application code */
	// Init
	DDRB  = 0x20; // PB5 (OC1A)를 Output으로 설정
	DDRA  = 0xff; // LED를 Output으로 설정
	DDRD  = 0x00; // switch0, switch1을 사용하기 위해 PD0와 PD1을 Input 설정
	
	// Switch setting
	EIMSK = (1<<INT0) | (1<<INT1);	 // INT0와 INT1 활성화
	EICRA = (1<<ISC01) | (1<<ISC11);
	// 둘 다 Falling edge 발생시 Interrupt가 활성화 되도록 설정
	
	// TIMER1 Setting
	TCCR1A	= (1<<COM1A1)|(1<<WGM11)|(0<<WGM10);
	// Fast PWM (TOP=ICR1) / Clear OC1A on compare match 사용
	TCCR1B  = (1<<WGM13)|(1<<WGM12)|(0<<CS12)|(1<< CS11)|(0<<CS10); // 분주비 8
	TCCR1C	= 0x00; // Force Output Compare A, B, C를 다 0으로 설정
	
	// TIMER2 Setting
	TCCR2	= (1<<WGM20)|(1<<WGM21)|(1<<COM21)|(0<<COM20)|(1<<CS22)|(0<<CS21)|(1<<CS20);
	// Fast PWM mode / Clear OC2 on compare match, set OC2 at BOTTOM / 분주비 1024
	TIMSK	= (1<<TOIE2);	// Timer/Counter2 Overflow Interrupt 활성화
	TCNT2	= 255-156;  // = 99 // 정확하게 나누어 떨어지진 않음 (원래는 98.5번이 정확함)

	// System Init
	ICR1	= 40000; // TOP값을 40000으로 설정해 서브모터의 주기를 20ms로 맞춰줌
	top		= ICR1;
	servo   = 40000.0 * (1.5/20.0); // = 1000, 서보모터의 첫시작 위치는 90도 (1.5ms)
	
	sei();			// 전역 인터럽트 활성화

	while (1);
}

