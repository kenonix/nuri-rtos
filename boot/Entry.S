#include "ARMv7AR.h"
#include "MemoryMap.h"

.text /*이 코드는 text 섹션임*/
  .code 32 /*명령어 크기가 32비트*/

  .global vector_start /*.global 은 외부변수(c언어의 extern과 같게 사용됨)*/
  .global vector_end /* 위와 동일*/

  vector_start: /*레이블 선언*/
    LDR PC, reset_handler_addr
    LDR PC, undef_handler_addr
    LDR PC, svc_handler_addr
    LDR PC, pftch_abt_handler_addr
    LDR PC, data_abt_handler_addr
    B .
    LDR PC, irq_handler_addr
    LDR PC, fiq_handler_addr

    reset_handler_addr: .word reset_handler //지금까지 만들어진 헨들러는 얘밖에 없음, 나머진 더미임..
    undef_handler_addr: .word dummy_handler
    svc_handler_addr: .word dummy_handler
    pftch_abt_handler_addr : .word dummy_handler
    data_abt_handler_addr: .word dummy_handler
    irq_handler_addr: .word dummy_handler
    fiq_handler_addr: .word dummy_handler

  vector_end: //똑같이 레이블 선언 - 함수 비슷한거로 추청됨

  reset_handler: 
    MRS R0, cpsr
    //cpsr의 내용을 R0 레지스터로 전송 (MRS/MSR은 시스템 레지스터 수정할때 사용됨)
    BIC R1, R0, #0x1F
    // r0 과 0x1f 를 and 후 not 연산 하여 r1에 넣는다. 
    ORR R1, R1, #ARM_MODE_BIT_SVC //동작모드
    // R1과 ARM_MODE_BIT_SVC 를 비트 OR 연산 후 R1에 넣는다.
    MSR cpsr, R1
    //r1값을 cpsr에 넣는다.
    LDR sp, =SVC_STACK_TOP //스택 꼭대기 메모리주소
    //SVC_STACK_TOP 위치에서 데이터를 읽어서 sp(스텍 포인터)에 넣는다.
    
    //이후 아래 코드 구조 동일
    MRS R0, cpsr
    BIC R1, R0, #0x1F
    ORR R1, R1, #ARM_MODE_BIT_IRQ
    MSR cpsr, R1
    LDR sp, =IRQ_STACK_TOP

    MRS R0, cpsr
    BIC R1, R0, #0x1F
    ORR R1, R1, #ARM_MODE_BIT_FIQ
    MSR cpsr, R1
    LDR sp, =FIQ_STACK_TOP

    MRS R0, cpsr
    BIC R1, R0, #0x1F
    ORR R1, R1, #ARM_MODE_BIT_ABT
    MSR cpsr, R1
    LDR sp, =ABT_STACK_TOP

    MRS R0, cpsr
    BIC R1, R0, #0x1F
    ORR R1, R1, #ARM_MODE_BIT_UND
    MSR cpsr, R1
    LDR sp, =UND_STACK_TOP

    MRS R0, cpsr
    BIC R1, R0, #0x1F
    ORR R1, R1, #ARM_MODE_BIT_SYS
    MSR cpsr, R1
    LDR sp, =USRSYS_STACK_TOP

  dummy_handler:
    B .
.end //텍스트 섹션 종료
