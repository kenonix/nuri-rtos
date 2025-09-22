ARCH = armv7-a #아키텍처 변수
MCPU = cortex-a8 #cpu 변수

CC = arm-none-eabi-gcc #C compiler 변수
AS = arm-none-eabi-as #어셈블러 변수
LD = arm-none-eabi-ld #링커 변수
OC = arm-none-eabi-objcopy #objcopy 변수

LINKER_SCRIPT = ./navilos.ld #링커 스크립트 파일 위치 변수

ASM_SRCS = $(wildcard boot/*.S)
#boot 디렉토리 안에 확장자가 .S 인 파일 이름을 모두 넣는 변수
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS)) 
#boot/ 안에 있는 .S 파일을 .o파일로 이름을 바꿔 넣는다. - 그냥 컴파일할때 쓸 이름을 담은 변수가 필요했던 것일 뿐임

navilos = build/navilos.axf #빌드되는 axf 파일의 위치
navilos_bin = build/navilos.bin #빌드되는 bin 파일의 위치

.PHONY: all clean run debug gdb
#타겟을 가상으로 만드는 것
#원래 all 하면 all 파일을 만들어야 하는데, 사실 파일 안만들지 않음? 얘가 타겟을 가상으로 정의해서 없는거로 치는거임

all: $(navilos) #all 을 쳤을때 실행할 스크립트

clean: #clean을 쳤을때 실행할 스크립트 	(빌드 파일을 지움)
	@rm -fr build 

run: $(navilos) #실행 하는 스크립트
	qemu-system-arm -M realview-pb-a8 -kernel $(navilos)

debug: $(navilos) #실행(gdb 디버그)
	qemu-system-arm -M realview-pb-a8 -kernel $(navilos) -S -gdb tcp::1234,ipv4

$(navilos) : $(ASM_OBJS) $(LINKER_SCRIPT)  
	$(LD) -n -T $(LINKER_SCRIPT) -o $(navilos) $(ASM_OBJS)
	$(OC) -O binary $(navilos) $(navilos_bin)
#navilos.axf 파일을 만드는 것, 조건은 ASM_OBJS와 LINKER_SCRIPT 가 있을때 실행 가능함.(조작할 파일들 확인)
#1. OBJ 파일과 링커 스크립트 파일을 넣는다.
#2. 링커 스크립트로 빌드해서 OBJ 파일을 만든다.
#3. OC - objcopy로 axf 파일을 bin 파일로 빌드한다.

build/%.o: boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
#오브젝트 파일을 빌드할 스크립트
# 따로 호출안함. 그냥 오브젝트 파일 만들고 싶을 때 치면 됨