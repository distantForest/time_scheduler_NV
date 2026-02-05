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
 * This file defines:
 *  - macros for control an read status of the AGSTU_time_scheduler component
 *  - a macro that HAL uses to create a device instance for each time scheduler device
 *    prsent in the system - the TIME_SCHEDULER_INSTANCE macro.
 *  - a macro that HAL uses to initialise each timer scheduler device present in the system,
 *    the TIME_SCHEDULER_INIT macro.
 */

#ifndef INC_TIME_SCHEDULER_H_
#define INC_TIME_SCHEDULER_H_

//#include "io.h"
#include "sys/alt_stdio.h"
#include "agstu_time_scheduler_regs.h"


/** \def TIME_SCHEDULER_VECTOR_READ
 * A time scheduler device exposes a vector during processing of an IRQ.
 * This macro reads this vector from the given time scheduler device.
 */
#define TIME_SCHEDULER_VECTOR_READ(x) ( \
    IORD_32DIRECT(CONCATENATE(x, _BASE), \
    TIME_SCHEDULER_IRQ_VECTOR_REG))


/** \def TIME_SCHEDULER_TIMER_RUN
 * This macro starts the given time scheduler device.
 */
#define TIME_SCHEDULER_TIMER_RUN(X) do{  \
    IOWR_32DIRECT(  \
		    CONCATENATE(X, _BASE),	\
		    TIME_SCHEDULER_CS_REG,	\
		    (0x1));  \
  } while (0)


/** \def TIME_SCHEDULER_TIMER_STOP
 * This macro halts the tick timer of the given time scheduler device.
 */
#define TIME_SCHEDULER_TIMER_STOP(X) do{  \
    IOWR_32DIRECT(  \
		    CONCATENATE(X, _BASE),	\
		    TIME_SCHEDULER_CS_REG,	\
		    (0x0)); \
  } while (0)


/** \def TIME_SCHEDULER_PERIOD_ENABLE
 * This macro enables IRQ from given period for the given time scheduler device.
 * The macro does not affect the tick timer of the time scheduler device.
 */
#define TIME_SCHEDULER_PERIOD_ENABLE(name, period) do{ \
    IOWR_TIME_SCHEDULER_IRQ_ENABLE_REG( \
    CONCATENATE(name, _BASE), \
    (IORD_TIME_SCHEDULER_IRQ_ENABLE_REG(CONCATENATE(name, _BASE)) | (1 << period))); \
      } while (0)


/** \def TIME_SCHEDULER_PERIOD_SET
 * This macro enables IRQ from given period for the given time scheduler device.
 * The macro does not affect the tick timer of the time scheduler device.
 */
#define TIME_SCHEDULER_PERIOD_SET(name, period_no, period) do{	\
    IOWR_TIME_SCHEDULER_PERIOD_REG( \
    CONCATENATE(name, _BASE), \
    period_no, (period - 1)); \
      } while (0)


// type definition for pointer to array of pointers to function
typedef void (*period_function_ptr)(void);
typedef period_function_ptr function_array_t[];

// time scheduler instance type declarations
typedef struct  {
    unsigned base; // base address for time scheduler device
    unsigned irq;  // IRQ level for time scheduler device
    unsigned irq_id;
  period_function_ptr (*period_functions)[];
} general_context;


/** \def TIME_SCHEDULER_INIT
 * This creates an instance for specific time scheduler device
 */
#define TIME_SCHEDULER_INSTANCE(name, class) \
    struct name##_context {             \
        unsigned base;               \
        unsigned irq;               \
        unsigned irq_id;            \
        period_function_ptr (*functions)[name##_HEIGHT];};	\
    __attribute__((weak)) period_function_ptr name##_functions[name##_HEIGHT] = {NULL}; \
    struct name##_context name##_i = {  \
                                        .base = name##_BASE, \
                                        .irq = name##_IRQ,  \
                                        .irq_id = name##_IRQ_INTERRUPT_CONTROLLER_ID, \
                                        .functions = name##_functions};


/** \def TIME_SCHEDULER_INIT
 * This macro defines a period function table for specific time scheduler device
 */
#define TIME_SCHEDULER_FUNCTIONS(name, ...)					\
  period_function_ptr name##_functions[name##_HEIGHT] = {__VA_ARGS__};


/** \def TIME_SCHEDULER_INIT
 * This macro registers an ISR for specific time scheduler device
 */
#define TIME_SCHEDULER_INIT(name, class) \
        do {                  \
            if (alt_ic_isr_register(\
                            name##_i.irq_id,\
                            name##_i.irq,\
                            alt_isr_period_0,\
                            &name##_i,\
                            0x0\
                    )) {                 \
                alt_printf("Error ISR register scheduler_%x",name##_i.irq);\
            }                                  \
            else {                                \
                alt_printf("Register success, irq_id %x, irq %x, base %x\n",\
                        name##_i.irq_id, name##_i.irq, name##_i.base);\
            } \
        }while (0)

// prototype for ISR
void alt_isr_period_0 (void* isr_context);

#endif /* INC_TIME_SCHEDULER_H_ */
