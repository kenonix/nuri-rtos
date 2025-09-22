.text /*이 코드는 text 섹션임*/
  .code 32 /*명령어 크기가 32비트*/

  .global vector_start /*.global 은 외부변수(c언어의 extern과 같게 사용됨)*/
  .global vector_end /* 위와 동일*/

  vector_start: /*레이블 선언*/
    MOV   R0, R1 //R1 을 R0으로 이동(레지스터 컨트롤)
  vector_end: //똑같이 레이블 선언 - 함수 비슷한거로 추청됨
    .space 1024, 0 // 해당 위치로부터 1024 바이트를 0으로 체움
.end //텍스트 섹션 종료
