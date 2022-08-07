# Sequential Logic<br>
## Edge-triggered D-type flip-flop<br>
行为与master-slave flip-flop相同，都是由时钟边缘驱动，在时钟的上升沿，将输出改变为前一个时钟周期末尾的输入

- Setup Time: 在时钟上升沿触发**前**，输入需要保持多长时间的稳定
- Hold Time: 在时钟上升沿后触发**后**，输入需要保持多长时间的稳定
- Clock-to-Q Delay：时钟上升沿触发后到输出改变所需的时间

## Maximum Clock Frequency<br>
- Critical Path: The critical path is the longest delay between any two registers in a circuit
- The clock period must be longer than this critical path, or the signal will not propagate properly to that next register

即Clock-to-Q Delay + 两个寄存器之间的Combinational Logic Delay + Setup Time

## Pipelining<br>
通过拆分Combinational Logic，在其中插入寄存器的方式，可以减小Critical Path，从而提高时钟频率

