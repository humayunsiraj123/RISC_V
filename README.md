# RISC_V
# RISC-V Single-Cycle Core

This repository contains the design and implementation of a RISC-V single-cycle core. The core follows the RISC-V instruction set architecture and executes instructions in a single clock cycle.

## Table of Contents

- [Introduction](#introduction)
- [Modules](#modules)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The RISC-V Single-Cycle Core is a simplified implementation of a RISC-V processor that executes each instruction in a single clock cycle. It is intended for educational purposes to demonstrate the basic concepts of processor architecture and instruction execution.

## Modules

1. **Instruction Memory**: This module holds the program instructions to be executed by the processor.

2. **Data Memory**: Responsible for storing and retrieving data during instruction execution.

3. **Control Unit**: Manages the control signals for various components of the processor based on the current instruction.

4. **ALU (Arithmetic Logic Unit)**: Performs arithmetic and logic operations on data.

5. **Register File**: Stores and retrieves data from registers.

6. **Decoder**: Decodes the instruction to generate control signals for different components.

7. **Muxes and Signal Routing**: Various multiplexers and signal routing logic to control data flow.

8. **Single-Cycle CPU**: The top-level module that integrates all the components and orchestrates instruction execution.

## Getting Started

To simulate and test the RISC-V Single-Cycle Core, follow these steps:

1. Clone this repository:
   ```bash
   git clone https://github.com/humayunsiraj123/RISC_V.git
