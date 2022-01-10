//// HW08 USART 과제 1번
//// 2019741034 명지수
//#define F_CPU 16000000UL
//#include <avr/interrupt.h>
//#include <avr/delay.h>
//
//ISR(USART1_RX_vect) // 수신이 완료됐을 때 Interrupt 활성화
//{
	//// data 수신이 완료되었는지 확인
	//while ( !(UCSR1A & (1<<RXC)) );
	//// RXC : 수인 완료 여부를 확인하는 flag
	//// UDR1에 저장되어있는 data를 반환한다.
	//USART1_Transmit(UDR1); // 들어온 값을 그대로 출력창에 띄움 (ECO mode)
//}
//
//void USART1_Transmit( unsigned char data ) // USART1 송신
//{
	//// UDR 값이 비었는지 확인(비어있으면 대기)
	//while ( !( UCSR1A & (1<<UDRE)) );
	//// buffer안에 데이터가 들어오면 데이터를 송신
	//UDR1 = data; // UDR1에 들어온 data를 저장한다.
//}
//
//int main(void)
//{
	///* Replace with your application code */
	//unsigned int a_data;
	//
	//// Init
	//// USART1
	//DDRD  = 0x08;
	//// PD2(RXD1) = input / PD3(TXD1) = output
	//
	//// USART1 setting
	//UCSR1A = 0x00;
	//UCSR1B = 0x98;
	//// RX Complete Interrupt (수신완료 interrupt)활성화
	//// RX, TX 활성화
	//UCSR1C = 0x06;  // Character Size 8bit로 설정
	//UBRR1L = 103;   // 9600BPS
//
	//// Global Intrrupt
	//sei();			// 전역 인터럽트 활성화
	//
	//while (1);
//}


//-------------------------------------------------------------------------------//
// HW08 USART 과제 2번
// 2019741034 명지수
#define F_CPU 16000000UL
#include <avr/interrupt.h>
#include <avr/delay.h>

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
	
	for(j = 10000 ; j > 0; j /= 10) // 10000의 자리수터 천천히 출력
	{
		USART1_Transmit((num/j) + 48);
		// 아스키 코드로 '0'은 48이므로 48을 더해 송신한다.
		num %= j; // 첫번째 자리를 제외한다. (예. 12345면 2345로 만듦)
	}
	USART1_Transmit(' '); // 한 칸 띄어쓰기
}

int main(void)
{
	/* Replace with your application code */
	unsigned int a_data;
	
	// Init
	// USART1
	DDRD  = 0x08;
	// PD2(RXD1) = input / PD3(TXD1) = output
	
	// USART1 setting
	UCSR1A = 0x00;
	UCSR1B = 0x18; 	// RX, TX 활성화
	UCSR1C = 0x06;  // Character Size 8bit로 설정
	UBRR1L = 103;   // 9600BPS
	
	a_data = 12345;
	USART1_TransNum(a_data);
	_delay_ms(1000);
	// 12345 송신
	
	a_data = -516;
	USART1_TransNum(a_data);
	_delay_ms(1000);
	// -516 송신
	
	a_data = -2;
	USART1_TransNum(a_data);
	_delay_ms(1000);
	// -2 송신
	
	while (1);
}

