# DISC06 sol<br>
## 1 Pre-Check<br>
### 1.1<br>
False. The simplier the boolean logic expression, the less propogating delay that needed, the more efficient the hareware implementation.

### 1.2<br>
False. 可以并联. Propagation delays add with the depth of the circuit, so a wide circuit with more gates can have less delay than just a few gates arranged in sequence.

### 1.3<br>
False. If the clock-to-q plus the setup time is greater than one cycle. The input of the register may change in the setup time.

## 2 Boolean Logic<br>
### 2.1<br>
$\bar{A} + AB = (\bar{A} + A)(\bar{A} + B) = \bar{A} + B$

### 2.2<br>
a)<br>
$(A+B)(A+\bar{B})C=(A+A\bar{B}+AB)C=A(T+B+\bar{B})C=AC$

b)<br>
$equation=\overline{\bar{A}BC+\bar{A}\bar{B}C}=\overline{\bar{A}C(B+\bar{B})}=\overline{\bar{A}C}=A+\bar{C}$

c)<br>
$\overline{A(\bar{B}\bar{C}+BC)}=\bar{A}+\overline{(\bar{B}\bar{C}+BC)}=\bar{A}+B\bar{C}+\bar{B}C$

d)<br>
$\bar{A}(A+B)+(B+AA)(A+\bar{B})=(A+B)(\bar{A}+A+\bar{B})=A+B$

## 3 Logic Gates<br>
### 3.1<br>
NOT,AND,OR,XOR,NAND,NOR,NXOR

### 3.2<br>
(a)<br>
$\bar{A}+\bar{B}$

(b)<br>
$\bar{A}\bar{B}$

(c)<br>
$AB+\bar{A}\bar{B}$

### 3.3<br>
(A NAND B) NAND (A NAND B)

## 4 State Intro

### 4.2<br>
14ns<br>
25ns<br>
40MHz

## 5 Finite State Machines<br>
### 5.1<br>
two or more consecutive 1s. 001000000110
