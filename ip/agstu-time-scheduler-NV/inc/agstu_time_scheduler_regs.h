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
 * This file defines macros for access to registers of the AGSTU_time_scheduler component.
 */

#ifndef INC_TIME_SCHEDULER_REGS_H_
#define INC_TIME_SCHEDULER_REGS_H_

#include "io.h"
#include <system.h>

//address map
/** \def Address map for time scheduler device
 * theese macros define address offsets for the registers that
 * a time scheduler device contains.
 */
#define TIME_SCHEDULER_IRQ_ENABLE_REG (0x00)
#define TIME_SCHEDULER_IRQ_ACK_REG (0x04)
#define TIME_SCHEDULER_IRQ_VECTOR_REG (0x08)
#define TIME_SCHEDULER_CS_REG (0x0c)
#define TIME_SCHEDULER_PERIOD_REG (0x10)

#define CONCATENATE(A,B) A##B

// Read registers
/** \def IORD_TIME_SCHEDULER_IRQ_ENABLE_REG
 * this macro generates an instruction to read the irq_enable
 * register. Bits in this register correspond to periods in the time
 * scheduler device and enable(1)/disable(0) interrupts individually
 * for each period.
 */
#define IORD_TIME_SCHEDULER_IRQ_ENABLE_REG(x) \
		(IORD_32DIRECT(x, TIME_SCHEDULER_IRQ_ENABLE_REG))


/** \def IORD_TIME_SCHEDULER_IRQ_VECTOR_REG
 * this macro generates an instruction to read the vector register. When the
 * time scheduler device is processing a period IRQ it sets the IRQ line and
 * puts the vector in the vector register. An ISR can read this register with
 * the macro IORD_TIME_SCHEDULER_IRQ_VECTOR_REG.
 */
#define IORD_TIME_SCHEDULER_IRQ_VECTOR_REG(base) \
		(IORD_32DIRECT(base, TIME_SCHEDULER_IRQ_VECTOR_REG))


/** \def IORD_TIME_SCHEDULER_PERIOD_REG
 * this macro generates an instruction to read the period register for period
 * number period_no. The period_no must take values from 0 to (_HIGHT - 1)
 */
#define IORD_TIME_SCHEDULER_PERIOD_REG(base, period_no)  (\
    IORD_32DIRECT(base, (TIME_SCHEDULER_PERIOD_REG + (4 * period_no))) \
          )


// Write registers
/** \def IOWR_TIME_SCHEDULER_IRQ_ENABLE_REG
 * this macro generates an instruction to write yo the irq_enable register.
 * IRQ for period n is enabled by setting bit n of the irq_enable register to 1.
 */
#define IOWR_TIME_SCHEDULER_IRQ_ENABLE_REG(base, data) do { \
        IOWR_32DIRECT(base, \
		      TIME_SCHEDULER_IRQ_ENABLE_REG, data);} while (0)


/** \def IOWR_TIME_SCHEDULER_IRQ_ACK_REG
 * this macro generates an instruction to write to the irq_ack register.
 * IRQ for period n is ackowledged by setting bit n of the irq_ack register to 1.
 */
#define IOWR_TIME_SCHEDULER_IRQ_ACK_REG(base, data) do { \
        IOWR_32DIRECT(base, \
		      TIME_SCHEDULER_IRQ_ACK_REG, data);} while (0)


/** \def IOWR_TIME_SCHEDULER_IRQ_VECTOR_REG
 * this macro generates an instruction to write to the vector register.
 * Writing to the vector register acknowledges the time scheduler device IRQ.
 */
#define IOWR_TIME_SCHEDULER_IRQ_VECTOR_REG(base, data) do { \
        IOWR_32DIRECT(base, \
		      TIME_SCHEDULER_IRQ_VECTOR_REG, data);} while (0)


/** \def IOWR_TIME_SCHEDULER_PERIOD_REG
 * this macro generates an instruction to write a period limit to the period_no period.
 * The period_no must take values from 0 to (_HIGHT - 1).
 */
#define IOWR_TIME_SCHEDULER_PERIOD_REG(base, period_no, limit) do { \
    IOWR_32DIRECT(base, \
		  (TIME_SCHEDULER_PERIOD_REG + (4 * period_no)), \
		  limit);} while (0)

#endif /* INC_TIME_SCHEDULER_REGS_H_ */
