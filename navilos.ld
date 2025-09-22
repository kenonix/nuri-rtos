ENTRY(vector_start)
SECTIONS
{
  . = 0x0; /*메모리 시작 위치 - 0x0*/

  .text : /*text 섹션*/
  {
    *(vector_start)
    *(.text .rodata)
  }
  .data : /*data 섹션*/
  {
    *(.data)
  }
  .bss : /*bss 섹션*/
  {
    *(.bss)
  }
}
