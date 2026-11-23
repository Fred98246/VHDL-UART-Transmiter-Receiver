# VHDL-UART-Receiver and Transmiter
VHDL UART receiver and transmiter for the DE10-Lite (MAX 10) FPGA, decoding and displaying incoming PC serial data on 7-segment displays and echoing back to the PC.

The main function of this project is to read the ASCII characters of each keyboard key you press and display them instantly on the 7-segment displays of the DE10-Lite board. 

## How it works:
The whole thing is coded in VHDL using state machines for passing to different blocks. It contains 4 main VHDL files that have a hierarchical file structure:

UART_R_T.vhd : Top level code (uses the rest of the .vhd files as entities that get plugged into it)
UART_R.vhd : UART 8 bit receiver code, based on state machines
UART_T.vhd : UART 8 bit transmiter code, based on state machines
HEX_TO_7SEG.vhd : HEX to seven segment code fr displaying data

The project was built and compiled using QUARTUS LITE, the project file is the following:

UART_R-T.QPF

The pin planner values that correspond for the DE10 LITE are stored in the UART_R-T.qsf file

## Hardware Setup
To get this working, you can't just use a normal USB cable. You need a **USB to UART converter** wired to the FPGA. 
I used amazons XMSJSIY Conversor USB a TTL con chip CH343G Serial Adapter:

https://www.amazon.es/XMSJSIY-controlador-convertidor-compatible-industriales/dp/B0DFM8X3ZT/ref=sr_1_20?dib=eyJ2IjoiMSJ9.3Ijb45eW0pRgGi6vMvmO7Xf03Bup9qknlCrgQkpn-_Su-a2_KfdJSHpkr58_dFLxusaG5dUxI19f7xofdJ3j_0IOIiYlgkzT3jj34LPUCE-9iB7CB6PLvi9UHuxLeGhyCNTguFzlHjx0b-ftkyrH4IyIf_OgaTO79hm8tuA6JnHBUYBtmGlhFHW9jNkaZB7kJ_60t8F8YSO03likmMrZO9zJsjBKqU5_JvuUSDToMRlHM_3nW5komDie3-VXVd2xrTkgr19_fu96XVBeBG1BOof9_RGoBUyWt1C9iEXvCFA.2hmL1FRzsQ4sXn1Sd9VCR1LQJY4hcm2s1ynQKL9vfnU&dib_tag=se&keywords=usb+ttl&qid=1795432003&sr=8-20

To connect the hardware:

1. Maxe sure the TTL converter is on 3.3V
1. Connect the **TX pin** from your converter to the **RX pin** on the board, and tie the grounds (GND) together.
2. Open up or install **Tera Term** on your PC.
3. Configure a serial port:
   Setup -> Serial port -> Find the COM port your TTL converter is conected to (Device manager) -> specify baud rate (150000) and 8 bit
5. Start typing! Tera Term acts as the terminal passing the 8-bit UART data (ASCII characters) straight to the board, you should also see how the transmiter echoes back the data to the terraterm window 

## Pin Planner Settings (Intel MAX 10)
If you are setting this up in Quartus for the MAX 10 board, here is the exact pin planner configuration I used based on the DE 10 lite manual. Make sure the I/O standard for everything is set to **3.3-V LVTTL**.

I will leave the DE10 lite manual as a PDF file above.

* **Clock (`i_clk`)**: `PIN_P11`
* **UART RX (`UART_RX_PIN`)**: `PIN_AB5`
* **UART TX (`UART_RX_PIN`)**: `PIN_AB6`

**HEX0 Display (Right)**
* `HEX0[0]`: `PIN_C18`
* `HEX0[1]`: `PIN_D18`
* `HEX0[2]`: `PIN_E18`
* `HEX0[3]`: `PIN_B16`
* `HEX0[4]`: `PIN_A17`
* `HEX0[5]`: `PIN_A18`
* `HEX0[6]`: `PIN_B17`

**HEX1 Display (Left)**
* `HEX1[0]`: `PIN_C14`
* `HEX1[1]`: `PIN_E15`
* `HEX1[2]`: `PIN_C15`
* `HEX1[3]`: `PIN_C16`
* `HEX1[4]`: `PIN_E16`
* `HEX1[5]`: `PIN_D17`
* `HEX1[6]`: `PIN_C17`
