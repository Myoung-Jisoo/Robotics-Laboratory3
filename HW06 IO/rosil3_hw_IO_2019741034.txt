/*
 * 로봇학실험3 (월)
 * Created: 2021-04-26 오전 10:27:54
 * Author : 2019741034 명지수
 */ 
#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

int led = 0x01;

ISR(INT1_vect){ // interrupt 1 (PIND1) - External Interrupt발생시
	if(led == 0x80) led = 0x01;
	// 0b10000000에서 쉬프트 되면 0x00이 되버리기 때문에 직접 예외처리
	else led = (led << 1); // 왼쪽으로 1칸 shift
}

int main(void)
{
	// LED Setting
	DDRA  = 0xff; // OUTPUT으로 설정
	//Switch Setting
    DDRD = 0x00; // INPUT으로 설정
	
	// Switch 1 Setting - External Interrupt 
	EICRA = 0b00001000; // falling edge
	// Switch 1 Setting
	EIMSK = 0b00000010; // INT1 번 활성화
	
	sei(); // Global Interrupt 활성화
	
    while (1) 
    {
		if(!(PIND & 0x01)) {  // switch0이 눌리면 LED ON
			if(led == 0x80) led = 0x01;
			// 0b10000000에서 쉬프트 되면 0x00이 되버리기 때문에 직접 예외처리
			else led = (led << 1); // 왼쪽으로 1칸 shift
		}
		
		PORTA = ~led; // 0일때 LED가 켜지고 1일 때 꺼지는 구조이기 때문에 비트반전을 해줌
		_delay_ms(250);
	}
}

