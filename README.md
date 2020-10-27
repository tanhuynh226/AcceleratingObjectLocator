# AcceleratingObjectLocator - Structural Model
## Goal: Design an accelerating object locator that implements the following equation: <p align="center">![Image of Locator Equation](https://raw.githubusercontent.com/tanhuynh226/AcceleratingObjectLocator/main/images/locator-equation.gif)</p>


#### Locator Controller & Datapath:
<p align="center"><img src="https://raw.githubusercontent.com/tanhuynh226/AcceleratingObjectLocator/main/images/locator-figure.gif"></p>

#### FSM Model:
<p align="center"><img src="https://raw.githubusercontent.com/tanhuynh226/AcceleratingObjectLocator/main/images/FSMD%20Model%20for%20Lab%203s.png"></p>

#### Constants
* Zero Constant, stored in regArray(0)
* Constant acceleration (a): 11 m/s2 (meters per second squared), stored in regArray(1)
* Time (t): 8 seconds, stored in regArray(2)
* An initial velocity (v0): 3 m/s (meters per second), stored in regArray(3)
* Starting location (x0): 5 m (meters), stored in regArray(4)
* regArray(5) through regArray(7) are free slots

#### Clock cycle calculations
Logical Component Delays:
*	State Register (StateReg): 4 ns from Clk to output, 1 ns setup time
*	8×16 Register File (RegFile): 6 ns from input to output (reading), 6 ns from Clk to output (writing), 1 ns setup time (writing)
*	ALU (ALU): 12 ns from input to output
*	16-bit Shifter: 4 ns from input to output
*	2-to-1 Selector: 3 ns from input to output
*	16-bit Output Register (OutReg): 4 ns from Clk to output; 1 ns setup time
*	16-bit Three-state Buffer (ThreeStateBuff): 2 ns from input to output


**Minimum clock cycle** = StateReg + CombLogic<sup>[1](#1)</sup> + RegFile + ALU + Selector  
= (4 + 1) + 11 + (6 + 6 + 1) + 12 + 3 = **44 ns**

<Comb Logic="1">1</a>: Combinational Logic Delay(CombLogic): 11 ns
