# NOTE: Build divided into C and CPP parts because the C code doesn't build with the CPP compiler

CC=avr-gcc
CXX=avr-g++
AR=avr-ar

INC_DIRS := -I .

CFLAGS  := -Wall -Os
#CFLAGS  += -mmcu=atmega1280 -DF_CPU=16000000 # Arduino MEGA 1280
CFLAGS += -mmcu=atmega2560 -DF_CPU=16000000   # Arduino MEGA 2560
CFLAGS  += $(INC_DIRS)

CXXFLAGS := -Wall -Os
#CXXFLAGS += -mmcu=atmega1280 -DF_CPU=16000000 # Arduino MEGA 1280
CXXFLAGS += -mmcu=atmega2560 -DF_CPU=16000000  # Arduino MEGA 2560
CXXFLAGS += $(INC_DIRS)

HDR     :=	binary.h HardwareSerial.h pins_arduino.h Print.h Stream.h WConstants.h wiring.h wiring_private.h \
		WProgram.h WString.h Wire.h twi.h WCharacter.h
C_SRC   := pins_arduino.c wiring_analog.c wiring_digital.c wiring_shift.c wiring.c wiring_pulse.c WInterrupts.c twi.c
CPP_SRC := HardwareSerial.cpp Tone.cpp WString.cpp  Print.cpp  WMath.cpp Wire.cpp

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
