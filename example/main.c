#include <WProgram.h>
#include "general.h"
#include "serial_lcd.h"

#define NR_OF_DELAY_ENTRIES 23 /* delay values that form a value loop */
static const int16_t delay_us[] = { 20000, 18000, 16000, 14000, 12000, 10000, 8000,
                                     6000,  4000,  2000,  1000,  1000,  1000, 1000,
                                     2000,  4000, 6000,   8000, 10000, 12000, 14000,
                                    16000, 18000 };
#define NR_OF_OUTPUT_PINS 4
static const uint8_t output_pin[] = {2,3,4,5};
static int16_t value[] = {0,0,0,0};
static int16_t i=0;
static uint8_t delay_index = 7; /* begin with fast fading */
static uint16_t loop_counter = 0;

void delay_execution(int16_t delay_us)
{
    /* Use delay() as a fallback for too large values that delayMicroseconds() cannot handle */
    if (delay_us < 16000) {
        delayMicroseconds(delay_us);
    } else {
        delay(delay_us / 1000);
    }
}

void setup()
{
    serial_lcd_initialize(); /* Serial port 1, 19200 bps */

    if (serial_lcd_is_backlight_supported()) {
        serial_lcd_set_backlight(TRUE);
    }

    /* Prepare pins for PWM output */
    for (i=0; i<NR_OF_OUTPUT_PINS; i++) {
        pinMode(output_pin[i], OUTPUT);
        digitalWrite(output_pin[i], LOW);
    }
}

/* This loop will first fade in four LEDS in sequential order. Then they will
 * fade out in the reverse order. For each time the loop() is called, a different
 * delay value is used that affects the fading speed. These values are picked
 * from an array with values that form a cycle when the array index goes from
 * the last to the first value.
 *
 * Fading the LCD is realized with the help of pulse width modulation.
 *
 * Also, a LCD is used to printout delay values and which LED is currently being
 * handled.
 */ 
void loop()
{
    serial_lcd_clear();
    serial_lcd_printf("loop_counter: %d\n", loop_counter);
    serial_lcd_printf("delay_us: %d\n", delay_us[delay_index]);

    serial_lcd_printf("fade in pin  ");
    for (i=0; i<NR_OF_OUTPUT_PINS; i++) {
        serial_lcd_printf("%d", i);
        while (value[i] <255) {
            value[i] += 5;
            if (value[i] > 255) {
                value[i] = 255;
            }                
            analogWrite(output_pin[i], value[i]);
            delay_execution(delay_us[delay_index]);
        }
    }

    serial_lcd_printf("\nfade out pin ");
    for (i=NR_OF_OUTPUT_PINS-1; i >=0; i--) {
        serial_lcd_printf("%d", i);
        while (value[i] > 0) {
            value[i] -= 5;
            if (value < 0) {
                value[i] = 0;
            }
            analogWrite(output_pin[i], value[i]);
            delay_execution(delay_us[delay_index]);
        }
    }

  delay_index++;
  if (delay_index >= NR_OF_DELAY_ENTRIES) {
      delay_index = 0;
  }

  loop_counter++;
}

int main(void)
{
    init(); /* Arduino initializations */
    setup();
    while (TRUE) { loop(); }
    return 0;
}

/* This function should never be called, but a link dependency exists */
extern "C" void_t __cxa_pure_virtual(void)
{
    while(TRUE) {}
}

