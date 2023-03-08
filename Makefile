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

HDR     :=	Client.h Printable.h USBAPI.h WCharacter.h Arduino.h Stream.h wiring_private.h binary.h HardwareSerial.h IPAddress.h Print.h USBCore.h WString.h HardwareSerial_private.h PluggableUSB.h Server.h Udp.h USBDesc.h Wire.h  atomic.h  crc16.h  delay_basic.h  delay.h  eu_dst.h  parity.h  setbaud.h  twi.h  usa_dst.h
C_SRC   :=	hooks.c wiring_digital.c WInterrupts.c wiring_analog.c wiring_pulse.c wiring.c wiring_shift.c twi.c
CPP_SRC :=	abi.cpp HardwareSerial3.cpp Stream.cpp WMath.cpp HardwareSerial0.cpp HardwareSerial.cpp IPAddress.cpp Print.cpp USBCore.cpp WString.cpp HardwareSerial1.cpp PluggableUSB.cpp Tone.cpp CDC.cpp HardwareSerial2.cpp main.cpp Wire.cpp LiquidCrystal_I2C.cpp

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
