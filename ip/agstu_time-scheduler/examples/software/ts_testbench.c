/*
 * ts_testbench.c
 *
 *  Created on: 1 Apr 2025
 *      Author: Igor Parchakov
 */
#include "sys/alt_stdio.h"
#include "io.h"
#include <system.h>
#include <sys/alt_irq.h>
#include "agstu_time_scheduler_regs.h"
#include "time_scheduler.h"
#include "agstu_hw_timer_regs.h"

#define HUGE_DELAY (6 * 1000 * 1000)

#define TIMER_B AGSTU_HW_TIMER_0
#define TIMER_P0 AGSTU_HW_TIMER_2
#define TIMER_P1 AGSTU_HW_TIMER_1
#define TIMER_P2 AGSTU_HW_TIMER_3

#define IORD_TIME_SCHEDULER_PERIOD_REG(base, period)  (\
    IORD_32DIRECT(base, (TIME_SCHEDULER_PERIOD_REG + (4 * period))) \
          )


int weak_int = 0xffff;
// Period functions
void period_0(void){ // load 2 * 1000 * 1000
    static unsigned counter = 0;
    volatile unsigned period_load = TIMER_READ(TIMER_P0);
    TIMER_ST_MES(TIMER_P0);
    alt_printf("+++ Period 0 +++ %x ",counter++ & 0xff);
//    while ((2 * 1000 * 1000) > TIMER_READ(TIMER_P0)){
//        unsigned period_load = 1;
//    }
    alt_printf("CounteD %x, PerioD %x\n",TIMER_READ(TIMER_P0), period_load);
}
void period_1(void){
    static unsigned counter = 0;
    volatile unsigned period_load;

    period_load = TIMER_READ(TIMER_P1);
    TIMER_ST_MES(TIMER_P1);
    alt_printf("+++ Period 1 ++.+ %x ",counter++ & 0xff);
//    while ((30 * 1000 * 1000) > TIMER_READ(TIMER_P1)){
//        unsigned period_load = 1;
//    }
    alt_printf("counted %x, period %x\n",TIMER_READ(TIMER_P1), period_load);
}
void period_2(void){
    static unsigned counter = 0;
    volatile unsigned period_load = TIMER_READ(TIMER_P2);
    TIMER_ST_MES(TIMER_P2);
    alt_printf("*** Period 2 *** %x ",counter++ & 0xff);
    while (2 * (25 * 1000 * 1000) > TIMER_READ(TIMER_P2)){
        unsigned period_load = 1;
    }
    alt_printf("COUNTED %x, PERIOD %x\n",TIMER_READ(TIMER_P2), period_load);
}

TIME_SCHEDULER_FUNCTIONS(TIME_SCHEDULER_0,
        period_0,
        period_1,
        period_2
        );

unsigned period_0_data = 0;
unsigned time_mes_b = 0;
unsigned time_mes_wr_char = 0;
unsigned time_adj_b = 0;
int main()
{
    // Register
    //time_scheduler_init(&TIME_SCHEDULER_0_i);
//    IOWR_TIME_SCHEDULER_PERIOD_REG(TIME_SCHEDULER_0_BASE, 1, 3);
    IOWR_TIME_SCHEDULER_PERIOD_REG(TIME_SCHEDULER_0_BASE, 2, 22);

    //Enable interrupts
    TIME_SCHEDULER_PERIOD_ENABLE(TIME_SCHEDULER_0, 0x1);
    TIME_SCHEDULER_PERIOD_ENABLE(TIME_SCHEDULER_0, 0x2);
    TIME_SCHEDULER_PERIOD_ENABLE(TIME_SCHEDULER_0, 0x0);
    TIME_SCHEDULER_TIMER_RUN(TIME_SCHEDULER_0);

  /* Event loop never exits. */
    TIMER_ST_MES(TIMER_B);
    time_adj_b = TIMER_READ(TIMER_B);
    alt_printf("Period 2 limit %x\n",IORD_TIME_SCHEDULER_PERIOD_REG(TIME_SCHEDULER_0_BASE,2));
    alt_printf("Period 1 limit %x\n",IORD_TIME_SCHEDULER_PERIOD_REG(TIME_SCHEDULER_0_BASE,1));
    alt_printf("Period 0 limit %x\n",IORD_TIME_SCHEDULER_PERIOD_REG(TIME_SCHEDULER_0_BASE,0));
    alt_printf("-- background time adjustment %x\n",time_adj_b);
  while (1){
      static int j = 0;
//    delay and print background loop message
      for (int i = HUGE_DELAY; i > 0; i --){
          int j = i;
      }
      //TIMER_ST_MES(TIMER_B);
      //TIMER_RESET(TIMER_B);

      j =  (j + 1) & 0xff;
      TIMER_ST_MES(TIMER_B);
//      alt_printf("-- background -- %x\n",j);
      time_mes_b = TIMER_READ(TIMER_B) - time_adj_b;
      // measure one symbol printing
      TIMER_ST_MES(TIMER_B);
      alt_putchar('X');
      time_mes_wr_char = TIMER_READ(TIMER_B) - time_adj_b;
//      alt_printf("-- background time %x, one char time %x\n",time_mes_b, time_mes_wr_char);

  }

  return 0;
}




