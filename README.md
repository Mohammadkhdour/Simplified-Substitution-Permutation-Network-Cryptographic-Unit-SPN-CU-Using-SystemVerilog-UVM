# Simplified Substitution-Permutation Network Cryptographic Unit (SPN-CU) Using SystemVerilog & UVM

<div align="center">

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-orange?style=for-the-badge&logo=v&logoColor=white)
![UVM](https://img.shields.io/badge/UVM-blue?style=for-the-badge)
![Hardware Security](https://img.shields.io/badge/Hardware_Security-red?style=for-the-badge&logo=shield&logoColor=white)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![EDA Playground](https://img.shields.io/badge/EDA_Playground-Try_Online-brightgreen?style=for-the-badge&logo=play&logoColor=white)](https://www.edaplayground.com/x/uacM)

*A hardware implementation of a Simplified Substitution-Permutation Network (SPN) cryptographic unit with comprehensive verification using SystemVerilog and Universal Verification Methodology (UVM).*

</div>

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [File Structure](#file-structure)
- [Design Implementation](#design-implementation)
- [Verification Environment](#verification-environment)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Test Cases](#test-cases)
- [Results](#results)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## 🔍 Overview

This project implements a Simplified Substitution-Permutation Network (SPN) cryptographic unit in SystemVerilog with a comprehensive UVM-based verification environment. The SPN is a fundamental cryptographic building block used in modern block ciphers, demonstrating key concepts of confusion and diffusion in cryptographic algorithms.

### Key Highlights
- **16-bit block cipher** with 32-bit key
- **4-round encryption/decryption** process
- **Substitution-Permutation Network** architecture
- **Comprehensive UVM testbench** for verification
- **Real-time encryption/decryption** capability

### 🌐 Try it Online
**[🚀 Run the project on EDA Playground](https://www.edaplayground.com/x/uacM)** - No installation required!

## ✨ Features

- **Dual Operation Mode**: Supports both encryption (`OP_ENC`) and decryption (`OP_DEC`)
- **Error Handling**: Invalid operation detection with `OP_ERR` status
- **Synchronous Design**: Clock-based operation with reset capability
- **Modular Architecture**: Clean separation of S-box, P-box, and key schedule operations
- **UVM Verification**: Industry-standard verification methodology
- **Comprehensive Coverage**: Functional and code coverage analysis

## 🏗️ Architecture

### SPN Structure
The SPN consists of 4 rounds of operations:
1. **Key Addition**: XOR with round key
2. **S-box Substitution**: 4-bit to 4-bit substitution
3. **P-box Permutation**: Bit position permutation
4. **Final Round**: S-box substitution and key addition (no permutation)

### Block Diagram
```
Input (16-bit) → Round 1 → Round 2 → Round 3 → Round 4 → Output (16-bit)
                    ↓        ↓        ↓        ↓
               Key Schedule (32-bit key split into 4×16-bit round keys)
```

## 📁 File Structure

```
RTL/
├── design.sv            # Main SPN design implementation
└── spn_package.sv       # Package definitions and parameters
tb/
├── spn_agent.sv         # UVM agent
├── spn_driver.sv        # UVM driver
├── spn_enc_dec_test.sv  # Encryption/Decryption test
├── spn_env.sv           # UVM environment
├── spn_if.sv            # Interface definitions
├── spn_monitor.sv       # UVM monitor
├── spn_scoreborad.sv    # UVM scoreboard
├── spn_seq.sv           # Test sequences
├── spn_seq_item.sv      # Sequence item
├── spn_sequencer.sv     # UVM sequencer
├── spn_test.sv          # Base test class
└── testbench.sv         # Top-level testbench
document/
├── DV-Project-Report.pdf                    # Detailed project documentation
└── ENCS5337+Course+Project++Spring+24+25.pdf # Course project requirements
```

## 💻 Design Implementation

### Core Module: `SPN_CU`
```systemverilog
module SPN_CU (
    input  logic          clk,        // Clock signal
    input  logic          reset,      // Reset signal
    input  logic [1:0]    opcode,     // Operation code
    input  logic [15:0]   in_data,    // Input data
    input  logic [31:0]   key,        // Encryption/Decryption key
    output logic [15:0]   out_data,   // Output data
    output logic [1:0]    valid       // Operation status
);
```

### Key Schedule
The 32-bit master key is divided into four 16-bit round keys:
- `round_key[0] = {key[7:0], key[23:16]}`
- `round_key[1] = key[15:0]`
- `round_key[2] = {key[7:0], key[31:24]}`
- `round_key[3] = key[31:16]`

### S-box Implementation
4-bit substitution providing confusion:
```
S-box: [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7]
```

### P-box Implementation
16-bit permutation providing diffusion:
```
P-box: [0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15]
```

## 🧪 Verification Environment

### UVM Components

1. **Interface (`spn_if.sv`)**
   - Connects DUT signals
   - Provides clocking blocks for synchronization

2. **Sequence Item (`spn_seq_item.sv`)**
   - Encapsulates transaction data
   - Includes constraints for valid operations

3. **Sequences (`spn_seq.sv`)**
   - Defines test stimulus patterns
   - Contains various sequence types for different test scenarios

4. **Sequencer (`spn_sequencer.sv`)**
   - Manages sequence execution
   - Controls stimulus generation flow

5. **Driver (`spn_driver.sv`)**
   - Drives stimuli to DUT
   - Handles protocol timing

6. **Monitor (`spn_monitor.sv`)**
   - Observes DUT signals
   - Collects coverage data

7. **Scoreboard (`spn_scoreborad.sv`)**
   - Reference model implementation
   - Automatic checking of results
   - Pass/fail reporting

8. **Agent (`spn_agent.sv`)**
   - Contains driver, monitor, sequencer
   - Configurable for active/passive modes

9. **Environment (`spn_env.sv`)**
   - Top-level verification environment
   - Instantiates and connects all components

10. **Base Test (`spn_test.sv`)**
    - Base test class with common functionality
    - Provides foundation for specific test cases

11. **Encryption/Decryption Test (`spn_enc_dec_test.sv`)**
    - Specific test scenarios for encryption and decryption
    - Random and directed testing

12. **Top-level Testbench (`testbench.sv`)**
    - Module-based testbench wrapper
    - Instantiates DUT and UVM test environment

## 🚀 Getting Started

### Prerequisites
- SystemVerilog simulator (ModelSim, VCS, Xcelium, etc.)
- UVM library support
- Basic knowledge of cryptography and verification

### Quick Start Options

#### Option 1: EDA Playground (Recommended for Quick Testing)
1. **[Click here to open the project on EDA Playground](https://www.edaplayground.com/x/uacM)**
2. Click "Run" to execute the simulation
3. View results in the log window

#### Option 2: Local Setup
1. Clone the repository
2. Ensure your simulator supports UVM
3. Compile all SystemVerilog files
4. Run the testbench


## 📊 Usage

### Basic Encryption Example
```systemverilog
// Set inputs
opcode = 2'b01;           // OP_ENC
in_data = 16'h1234;       // Plain text
key = 32'hABCDEF01;       // Encryption key

// Wait for result
@(posedge clk);
// out_data contains encrypted result
// valid should be OP_ENC (2'b01)
```

### Basic Decryption Example
```systemverilog
// Set inputs
opcode = 2'b10;           // OP_DEC
in_data = 16'h5678;       // Cipher text
key = 32'hABCDEF01;       // Same key used for encryption

// Wait for result
@(posedge clk);
// out_data contains decrypted result
// valid should be OP_DEC (2'b10)
```

## 🧪 Test Cases

### Included Test Scenarios
1. **Basic Encryption Test**
   - Single encryption operation
   - Verify correct output and status

2. **Basic Decryption Test**
   - Single decryption operation
   - Verify correct output and status

3. **Round-trip Test**
   - Encrypt then decrypt same data
   - Verify original data is recovered

4. **Error Handling Test**
   - Invalid opcode handling
   - Reset functionality

5. **Random Testing**
   - Multiple random encrypt/decrypt operations
   - Coverage-driven verification

## 📈 Results

### Verification Results
- ✅ All encryption/decryption operations verified
- ✅ Reference model matches DUT behavior
- ✅ Error conditions properly handled
- ✅ 100% functional coverage achieved
- ✅ Reset and clock domain crossing verified

### Performance Characteristics
- **Latency**: 1 clock cycle per operation
- **Throughput**: 1 operation per clock cycle
- **Area**: Optimized for educational purposes
- **Power**: Low-power synchronous design

## 📚 Documentation

For detailed implementation details, verification methodology, and results analysis, please refer to:
- **[Project Report](document/DV-Project-Report.pdf)** - Complete documentation with diagrams and analysis

### Key Topics Covered in Documentation
- SPN algorithm theory and implementation
- Verification methodology and UVM components
- Coverage analysis and results
- Synthesis and timing analysis
- Future enhancement opportunities

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Guidelines
1. Follow SystemVerilog coding standards
2. Include comprehensive verification for new features
3. Update documentation for any changes
4. Ensure all tests pass before submitting

## 📄 License

This project is developed for educational purposes. Please refer to your institution's policies regarding academic projects.

## 🏆 Acknowledgments

- Developed as part of the Design Verification course
- Implements concepts from modern cryptography
- Uses industry-standard UVM methodology
- Thanks to the SystemVerilog and UVM communities

---

**Note**: This is an educational implementation of SPN for learning cryptographic concepts and verification methodologies. It should not be used for actual security applications without proper security analysis and validation.