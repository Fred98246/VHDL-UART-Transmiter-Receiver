# VHDL-UART-Receiver and Transmitter
VHDL UART Receiver and transmitter for the DE10-Lite (MAX 10) FPGA (in Quartus: 10M50DAF484C7G), decoding and displaying incoming PC serial data on 7-segment displays and echoing back to the PC.

The main function of this project:
Incoming ASCII characters typed on a PC are decoded, displayed in hexadecimal on the board's 7-segment displays (`HEX1`–`HEX0`), and simultaneously echoed back to the PC terminal.

## How it works:
The whole thing is coded in VHDL using finite state machines (FSMs) clocked at **50 MHz**. It contains 4 main VHDL files that have a hierarchical file structure:

- **`UART_R_T.vhd`**: Top-level entity (instantiates and connects the rest of the `.vhd` files)
- **`UART_R.vhd`**: UART 8-bit receiver, based on state machines
- **`UART_T.vhd`**: UART 8-bit transmitter, based on state machines
- **`HEX_TO_7SEG.vhd`**: Hex-to-7-segment decoder for displaying data

The project was built and compiled using **Intel Quartus Prime Lite**, the project files are the following:

- Project file: `UART_R-T.qpf`
- Pin Planner assignments for the DE10-Lite: `UART_R-T.qsf`

## Hardware Setup
To get this working, you can't just use a normal USB cable. You need a **USB to UART converter** wired to the FPGA. 
I used Amazon's XMSJSIY Conversor USB a TTL con chip CH343G Serial Adapter: (https://www.amazon.es/dp/B0DFM8X3ZT).

To connect the hardware:

1. Make sure the TTL converter is set to **3.3V**.
2. Wire the converter to the DE10-Lite:
   - Connect **TX** on the converter to **RX** (`PIN_AB5`) on the board 'IO0'.
   - Connect **RX** on the converter to **TX** (`PIN_AB6`) on the board 'IO1'.
   - Tie **GND** on the converter to **GND** on the board.
   - Leave **VCC disconnected** on the TTL converter.
3. Open or install **Tera Term** on your PC.
4. Configure the serial port:
   - Go to **Setup → Serial port**, select the `COM` port your TTL converter is connected to (check Windows Device Manager), and set **115200 baud**, **8 data bits**, **No parity**, **1 stop bit**.
   - Go to **Setup → Terminal** and make sure **Local echo** is unchecked.

   <img width="534" height="633" alt="image" src="https://github.com/user-attachments/assets/27104904-313b-438c-9b14-e8de647bb1df" />

5. Start typing! Tera Term sends the 8-bit UART data (ASCII characters) straight to the board, displaying the hex value on the 7-segment displays while the transmitter echoes the character back to the Tera Term window.

<img width="651" height="423" alt="image" src="https://github.com/user-attachments/assets/c34d050c-742d-415d-89d9-64fa941d9c79" />

## Pin Planner Settings (Intel MAX 10)
If you are setting this up in Quartus for the MAX 10 board, here is the exact pin planner configuration I used based on the DE-10 lite manual. Make sure the I/O standard for everything is set to **3.3-V LVTTL**.

I will leave the DE10 lite manual as a PDF file above.

- **`i_clk`**: `PIN_P11` — 50 MHz Onboard Clock (`MAX10_CLK1_50`)
- **`UART_RX_PIN`**: `PIN_AB5` — `Arduino_IO0` (`D0/RX` in the user manual)
- **`UART_TX_PIN`**: `PIN_AB6` — `Arduino_IO1` (`D1/TX` in the user manual)

**HEX0 Display (Left)**
* `HEX0[0]`: `PIN_C18`
* `HEX0[1]`: `PIN_D18`
* `HEX0[2]`: `PIN_E18`
* `HEX0[3]`: `PIN_B16`
* `HEX0[4]`: `PIN_A17`
* `HEX0[5]`: `PIN_A18`
* `HEX0[6]`: `PIN_B17`

**HEX1 Display (Right)**
* `HEX1[0]`: `PIN_C14`
* `HEX1[1]`: `PIN_E15`
* `HEX1[2]`: `PIN_C15`
* `HEX1[3]`: `PIN_C16`
* `HEX1[4]`: `PIN_E16`
* `HEX1[5]`: `PIN_D17`
* `HEX1[6]`: `PIN_C17`

<img width="3359" height="1731" alt="20261123_123654" src="https://github.com/user-attachments/assets/d7b11905-0cf4-4cf8-ab51-7bc146ccdd99" />





