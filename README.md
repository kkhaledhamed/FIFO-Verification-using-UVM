# FIFO-Verification-using-UVM
This project implements the Universal Verification Methodology (UVM) for the functional verification of a First-In-First-Out (FIFO) design. The testbench is written in SystemVerilog and uses UVM components such as sequences, drivers, monitors, and scoreboards to ensure the correctness of the FIFO design. The verification environment also includes functional coverage and assertions for comprehensive testing.

![FIFO_OneWayStreet_1](https://github.com/user-attachments/assets/c43f4088-9a65-4308-ae19-206e4c443c8d)

### Design Overview
The FIFO design includes several key flags and signals used for managing data flow:
- full: Indicates when the FIFO is full.
- empty: Indicates when the FIFO is empty.
- almostfull: Indicates when the FIFO is almost full.
- almostempty: Indicates when the FIFO is almost empty.
- wr_ack: Acknowledgment signal for successful writes.
- overflow: Indicates if data is written when the FIFO is full.
- underflow: Indicates if data is read when the FIFO is empty.

### Project Overview
This project focuses on verifying a FIFO design with the following key attributes:
- Depth: Configurable FIFO depth.
- Flags: Wr_ack, Full, empty, almost full, overflow, and underflow flags.
- Write and Read Control: Logic to handle data flow based on control signals wr_enable, rd_enable, and rst_n.

### Detected Design Bugs

- The FIFO design contains four known bugs that were targeted during verification:
- Reset Signals Overflow: Issues with wr_ack and underflow signals.
  
#### Unhandled Cases:
- If both read and write are enabled when FIFO is empty, only writing should take place.
- If both read and write are enabled when FIFO is full, only reading should take place.
- Underflow Bug: The underflow signal behaves sequentially instead of combinationally.
- Almost Full Flag: Incorrect depth calculation (FIFO_DEPTH-2 corrected to FIFO_DEPTH-1).
- Write/Overflow Conflict: Overflow should not be high after a successful write operation.
- Read/Underflow Conflict: Underflow should not be high after a successful read operation

### Verification Plan
Testbench Structure:
- Instantiates the DUT (FIFO_top), interface, and binds assertions (FIFO_SVA).
- Clock generation and virtual interface setup using UVM configuration database.
- Sequences cover the following scenarios: Reset, Write only, Read only, Write & Read, and Write & Read with empty sequences.
- Scoreboard and coverage collector to validate the FIFO's functional correctness and ensure coverage metrics are met.

The verification plan covers:
- Reset Sequences: Ensures that all signals and flags are properly reset.
- Write-Only Sequences: Verifies correct operation during write-only scenarios.
- Read-Only Sequences: Verifies correct operation during read-only scenarios.
- Combined Write-Read Sequences: Verifies proper handling of concurrent write and read operations, including corner cases such as FIFO full or empty conditions.

### Key UVM Components:

#### FIFO_test:
- Builds the UVM environment and sequences.
- Retrieves the virtual interface and configuration settings.
- Starts the sequences and monitors the test execution.

#### FIFO_sequence_item:
- Defines the data fields for communication with the DUT (Input and Output signals).
- Randomizes signals and defines constraints to ensure targeted coverage.

#### FIFO_env:
-Contains the key components for verification:
- FIFO_agent: Manages driver and monitor interaction with the DUT.
- FIFO_scoreboard: Compares actual DUT outputs with expected results from the reference model.
- FIFO_coverage: Collects functional coverage data.

#### FIFO_driver:
Pulls transactions from the sequencer and drives the interface signals in the run_phase.

#### FIFO_monitor:
Observes DUT signals, translates them into transactions, and sends them to analysis components such as the scoreboard and coverage.

#### FIFO_scoreboard:
Verifies DUT output by comparing it against a reference model, incrementing the error counter and displaying messages if discrepancies are found.

#### FIFO_coverage:
Collects functional coverage using covergroups to ensure that the verification plan has been thoroughly executed.

### Coverage Metrics:
- Functional Coverage: Includes key aspects such as write-read combinations, empty and full conditions, and handling of flags.
- Assertions: SVA properties are used to check the behavior of signals like full, empty, almostfull, almostempty, and flags during various scenarios.

### RTL Assertions
Several RTL assertions were implemented to ensure that the FIFO flags and pointers behave correctly under different scenarios, such as reset, overflow, underflow, read, and write operations.

### Interface Code
The project uses a SystemVerilog interface for connecting the testbench components with the DUT (Device Under Test). This interface simplifies signal handling and helps to verify the communication between different testbench components.

### Monitor
A dedicated monitor module tracks the transactions between the DUT and the testbench, ensuring the inputs and outputs behave as expected. The monitor also logs transaction information for further analysis.

### Testbench
The testbench is self-checking, using random and directed stimuli to test the FIFO under a wide range of conditions. A scoreboard compares the expected results with the actual outputs from the DUT. The testbench is designed to handle:

### Coverage
The verification methodology employed functional coverage to ensure that all corner cases and important scenarios were tested. The coverage model includes:

- Code Coverage: Including toggle, branch, statement, and condition coverage.
- Assertion Coverage: Ensuring that all RTL assertions were exercised.
- Functional Coverage: Using a covergroup to measure the effectiveness of the testbench in exercising different FIFO states (e.g., full, almost full, empty).

#### Overall Coverage
-Toggle Coverage: Measures how often each bit in the design toggles.
-Branch Coverage: Ensures all branches in conditional statements are exercised.
=Statement Coverage: Verifies all code statements are executed.
-Condition Coverage: Ensures that all conditions in the design have been evaluated.
-Assertions Coverage: Tracks how many of the implemented assertions have been triggered.
-Functional Coverage: Cross-coverage between write enable, read enable, and control signals (excluding data_out).

### Simulation Results
The FIFO verification was conducted using QuestaSim. Several key test cases and scenarios were simulated, At the end of the simulation, the FIFO is empty, indicating that all transactions were processed correctly.

### Conclusion
This project successfully verified the FIFO design, uncovering key bugs and ensuring the correct operation of the FIFO under various scenarios, including corner cases.
