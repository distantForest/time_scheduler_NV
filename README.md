# time_scheduler
Construction of time scheduler component for FPGA
## Project Overview

The purpose of this project is to create a complete component that manages the execution of functions (implemented as standard C-functions) according to a predefined time schedule.

## Component Functionality

The functionality of the component is defined as follows:

- The component repeatedly executes a C-function at a predetermined time interval, referred to in the text as a **period**.
- Each C-function managed by the component is linked to a specific time period and is referred to as a **period function**.
- In cases of overlap, the scheduler prioritizes period functions based on their predefined priorities (**preemption**).
- If a period function’s execution exceeds its assigned period length, the function is allowed to complete, and the next execution starts at the subsequent period. Such cases are logged as **period misses**.

## Integration and Configuration

The component is designed to work with a Nios® V processor via Avalon® interfaces and builds upon a prototype developed within the framework of the project *“Time-Controlled Scheduler in FPGA. Engineering Project – Examination.”*

The component is intended for integration into Nios® V-based systems via Quartus Platform Designer, where the following parameters can be configured:

- The number of periods the component will handle
- The priority for each period
- The time interval for each period

[## Additional Development]:#

## Additional Development 

As part of the component, a software driver has been developed to facilitate management of the component from software running on the Nios® V processor. Additionally, test programs have been created to verify both the hardware and software functionality.

## Version Control and Project Management

The source code is maintained in a GitHub repository, which is also used for version control and project tracking.
