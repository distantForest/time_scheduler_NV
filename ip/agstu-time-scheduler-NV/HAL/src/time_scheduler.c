/*
 ------------------------------------------------------------------
 * Company: TEIS AB
 * Engineer: Igor Parchakov
 *
 * Created on: june 20, 2025
 * Design Name: AGSTU_time_scheduler
 * Target Devices: MAX10
 * Tool versions: Quartus v18 and Eclipse Mars.2 Release (4.5.2)
 *
 *
 ------------------------------------------------------------------
 */
/** \file
 * This file presents ISR for task scheduler device.
 */

#include "sys/alt_stdio.h"
#include "io.h"
#include "system.h"
#include <sys/alt_irq.h>
#include "agstu_time_scheduler_regs.h"
#include "time_scheduler.h"


unsigned depth = 0;

/**
 * \brief      ISR for timer scheduler device
 *
 * \details    the ISR reads vector from the time scheduler and calls a period function
 *             from the priod function table, using the vector as the index for the table.
 *
 * \param      isr_context represents time scheduler device instance
 *
 * \return     void
 */
void alt_isr_period_0 (void* isr_context){
  general_context *base = (general_context*)isr_context;
  unsigned vector = IORD_TIME_SCHEDULER_IRQ_VECTOR_REG(base->base);
  alt_u32 irq_enabled;

  depth += 1;
  IOWR_TIME_SCHEDULER_IRQ_VECTOR_REG(base->base, 0x0);
 __asm__ volatile ("rdctl %0, ienable" : "=r" (irq_enabled));
 __asm__ volatile ("wrctl ienable, %0" : : "r" (irq_enabled | (1 << base->irq)) : "memory");
 __asm__ volatile ("wrctl status, %0" : : "r" (1 << 0) : "memory");

/*  Log for debugging
  alt_printf("function %x\n",(*(base->period_functions))[vector]);
  alt_printf("..irq vector %x, depth %x",vector, depth);
*/

  // call period function by vector
  if ((*(base->period_functions))[vector]){(*base->period_functions)[vector]();}

 __asm__ volatile ("wrctl status, %0" : : "r" (0) : "memory");
 __asm__ volatile ("wrctl ienable, %0" : : "r" (irq_enabled) : "memory");
  IOWR_TIME_SCHEDULER_IRQ_ACK_REG(base->base, 1 << vector);
  depth -= 1;
}


