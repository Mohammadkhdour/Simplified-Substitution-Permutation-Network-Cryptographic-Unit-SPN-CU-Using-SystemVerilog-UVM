# 🔐 Simplified Substitution-Permutation Network Cryptographic Unit (SPN-CU)

<div align="center">

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-orange?style=for-the-badge&logo=v&logoColor=white)
![UVM](https://img.shields.io/badge/UVM-blue?style=for-the-badge)
![Hardware Security](https://img.shields.io/badge/Hardware_Security-red?style=for-the-badge&logo=shield&logoColor=white)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

*A hardware implementation of a Simplified SPN Cryptographic Unit with comprehensive UVM verification*

[Features](#-features) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents
- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Implementation Details](#-implementation-details)
- [Verification Strategy](#-verification-strategy)
- [Getting Started](#-getting-started)
- [Results and Performance](#-results-and-performance)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)

## 🚀 Overview

This project implements a hardware-based **Simplified Substitution-Permutation Network (SPN) Cryptographic Unit** using SystemVerilog with comprehensive UVM verification. The design serves as an educational model for understanding modern block cipher implementations in hardware.

### Key Highlights
- Complete RTL implementation in SystemVerilog
- Comprehensive UVM testbench
- Parameterizable design for flexibility
- Full documentation and example test cases

## ✨ Features

### Hardware Design
- **Configurable Parameters**
  - Adjustable block size (16/32/64-bit)
  - Customizable number of rounds
  - Flexible key size
  - Configurable S-box and P-box definitions

### Cryptographic Features
- **S-box Implementation**
  - Non-linear substitution
  - Confusion property
  - Lookup table based design

- **P-box Features**
  - Bit permutation network
  - Diffusion property
  - Optimized hardware routing

- **Key Schedule**
  - Round key generation
  - Key expansion algorithm
  - Secure key management

### Verification Features
- **UVM Environment**
  - Comprehensive test scenarios
  - Automated checking
  - Coverage-driven verification
  - Constrained random testing

## 🏗 Architecture

### Block Diagram
```
[Input Block] → [Add Round Key] → [S-Box] → [P-Box] → [Round Operations] → [Output Block]
                      ↑              
                [Key Schedule]
```

### Design Hierarchy
```
spn_top
├── spn_controller
├── sbox_module
├── pbox_module
├── key_expansion
└── round_logic
```

## 💻 Implementation Details

### RTL Structure
```
rtl/
├── spn_top.sv           # Top-level module
├── spn_controller.sv    # Control logic
├── sbox_module.sv       # Substitution box
├── pbox_module.sv       # Permutation box
├── key_expansion.sv     # Key schedule
└── round_logic.sv       # Round operations
```

### Verification Structure
```
tb/
├── spn_pkg.sv          # Package definitions
├── spn_if.sv           # Interface
├── spn_env.sv          # UVM environment
├── spn_sequence.sv     # Test sequences
└── spn_test.sv         # Test cases
```

## 🔍 Verification Strategy

### UVM Environment Components
- **Sequencer**: Generates test scenarios
- **Driver**: Converts sequences to DUT signals
- **Monitor**: Observes DUT interfaces
- **Scoreboard**: Validates DUT behavior
- **Coverage**: Tracks verification progress

### Test Scenarios
1. Basic Encryption/Decryption
2. Corner Cases
3. Random Data Patterns
4. Error Conditions
5. Performance Tests

## 🛠️ Getting Started

### Prerequisites
- SystemVerilog compatible simulator
- UVM library (1.2 or later)
- Basic understanding of cryptography

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Mohammadkhdour/Simplified-Substitution-Permutation-Network-Cryptographic-Unit-SPN-CU-Using-SystemVerilog-UVM.git
   cd Simplified-Substitution-Permutation-Network-Cryptographic-Unit-SPN-CU-Using-SystemVerilog-UVM
   ```

2. Set up your simulation environment:
   ```bash
   # Example for Questa/ModelSim
   vlib work
   vlog -sv +incdir+./rtl +incdir+./tb ./rtl/*.sv ./tb/*.sv
   vsim -c spn_top_tb -do "run -all"
   ```

## 📊 Results and Performance

### Verification Metrics
- Functional Coverage: 100%
- Code Coverage: >95%
- All test scenarios passing

### Hardware Metrics
- Maximum Frequency: [TBD] MHz
- Area Utilization: [TBD] Gates
- Power Consumption: [TBD] mW

## 📖 Documentation

Detailed documentation is available in the `docs/` directory:
- Design Specification
- Verification Plan
- Test Reports
- User Guide
- Example Use Cases

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- Code Style
- Pull Request Process
- Development Workflow
- Bug Reports
- Feature Requests

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Author

- **Mohammadkhdour** - *Initial work and maintenance*

---

<div align="center">

For questions or collaboration, please [open an issue](https://github.com/Mohammadkhdour/Simplified-Substitution-Permutation-Network-Cryptographic-Unit-SPN-CU-Using-SystemVerilog-UVM/issues) or contact the maintainers.

*Made with ❤️ for the Hardware Security Community*

</div>