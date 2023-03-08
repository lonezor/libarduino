# NOTE: Build divided into C and CPP parts because the C code doesn't build with the CPP compiler

CC=avr-gcc
CXX=avr-g++
AR=avr-ar

INC_DIRS := -I .

CFLAGS  := -Wall -Os
#CFLAGS  += -mmcu=atmega1280 -DF_CPU=16000000 # Arduino MEGA 1280
CFLAGS += -mmcu=atmega2560 -DF_CPU=16000000   # Arduino MEGA 2560
CFLAGS  += $(INC_DIRS) -DARDUINO

CXXFLAGS := -Wall -Os
#CXXFLAGS += -mmcu=atmega1280 -DF_CPU=16000000 # Arduino MEGA 1280
CXXFLAGS += -mmcu=atmega2560 -DF_CPU=16000000  # Arduino MEGA 2560
CXXFLAGS += $(INC_DIRS) -DARDUINO

HDR     :=	Arduino.h
HDR     +=	atomic.h
HDR     +=	binary.h
HDR     +=	Client.h
HDR     +=	crc16.h
HDR     +=	delay_basic.h
HDR     +=	delay.h
HDR     +=	eu_dst.h
HDR     +=	HardwareSerial_private.h
HDR     +=	HardwareSerial.h
HDR     +=	IPAddress.h
HDR     +=	parity.h
HDR     +=	PluggableUSB.h
HDR     +=	Print.h
HDR     +=	Printable.h
HDR     +=	Server.h
HDR     +=	setbaud.h
HDR     +=	Stream.h
HDR     +=	twi.h
HDR     +=	Udp.h
HDR     +=	usa_dst.h
HDR     +=	USBAPI.h
HDR     +=	USBCore.h
HDR     +=	USBDesc.h
HDR     +=	VirtualWire.h
HDR     +=	WCharacter.h
HDR     +=	Wire.h
HDR     +=	wiring_private.h
HDR     +=	WString.h

C_SRC   :=	hooks.c
C_SRC   +=	twi.c
C_SRC   +=	WInterrupts.c
C_SRC   +=	wiring_analog.c
C_SRC   +=	wiring_digital.c
C_SRC   +=	wiring_pulse.c
C_SRC   +=	wiring_shift.c
C_SRC   +=	wiring.c

CPP_SRC :=	abi.cpp
CPP_SRC +=	CDC.cpp
CPP_SRC +=	HardwareSerial.cpp
CPP_SRC +=	HardwareSerial0.cpp
CPP_SRC +=	HardwareSerial1.cpp
CPP_SRC +=	HardwareSerial2.cpp
CPP_SRC +=	HardwareSerial3.cpp
CPP_SRC +=	IPAddress.cpp
CPP_SRC +=	LiquidCrystal_I2C.cpp
CPP_SRC +=	main.cpp
CPP_SRC +=	PluggableUSB.cpp
CPP_SRC +=	Print.cpp
CPP_SRC +=	Stream.cpp
CPP_SRC +=	Tone.cpp
CPP_SRC +=	USBCore.cpp
CPP_SRC +=	VirtualWire.cpp
CPP_SRC +=	Wire.cpp
CPP_SRC +=	WMath.cpp
CPP_SRC +=	WString.cpp

OBJ := $(C_SRC:.c=.o) $(CPP_SRC:.cpp=.o)

all: arduino

build_info:
	@sh generate_build_info_header.sh

arduino: $(OBJ) $(C_SRC) $(CPP_SRC) $(HDR) build_info
	$(AR) rcs libarduino.a $(OBJ)
cloc:
	@cloc ./*
clean:
	@rm -rfv *.o
	@rm -rfv *.a
