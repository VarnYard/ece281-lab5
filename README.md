# Lab 5: Basic CPU

VHDL for ECE 281 [Lab 5](https://usafa-ece.github.io/ece281-book/lab/lab5.html)

Targeted toward Digilent Basys3. Make sure to install the [board files](https://github.com/Xilinx/XilinxBoardStore/tree/2018.2/boards/Digilent/basys3).

Tested on Windows 11.

---

## Build the project

You can simply open the `.xpr` and Vivado will do the rest!

## GitHub Actions Testbench

The workflow uses the [setup-ghdl-ci](https://github.com/ghdl/setup-ghdl-ci) GitHub action
to run a *nightly* build of [GHDL](https://ghdl.github.io/ghdl/).

The workflow uses GHDL to analyze, elaborate, and run the entity specified in the `.github/workflows/testbench.yml`.

```yaml
env:
  TESTBENCH_ENTITY: myfile
```

If successful then GHDL will quietly exit with a `0` code.
If any of the `assert` statements fail **with** `severity failure` then GHDL will cease the simulation and exit with non-zero code; this will also cause the workflow to fail.
Assert statements of other severity levels, such as "error" w



# Documentation Statement

![image](https://github.com/VarnYard/ece281-lab5/assets/142039672/c242516d-a024-41bd-a401-b3050cddeba9)

![image](https://github.com/VarnYard/ece281-lab5/assets/142039672/55afafaf-2c05-4870-86f4-437a175d2720)

![image](https://github.com/VarnYard/ece281-lab5/assets/142039672/1665de1f-7c20-4278-8ced-9a65f71048a5)

![image](https://github.com/VarnYard/ece281-lab5/assets/142039672/3148cdbe-b5a9-4158-a384-d507636493a1)

-Pictured above is an introspective conversation with ChatOpenAI where some help was provided and even more tears were shed. This led to us adding elements to our component instantiation and declaration as well as editing our ALU file with the corrections recommended. 
-C3C Chapman helped to ensure that the files for controller_fsm and register were correct and offered some minor explanation of what he did in his specific files. 
-C3C West and C3C Varnier worked entirely collaboratively on the Lab, pushing to and pulling from the same repository. The textbook was used for the PreLab as well as an EI session with Capt. Yarbrough. 
-ChatOpenAI was used to assist with the ALU construction and to debug it but I cannot locate the conversation link. If it is subsequently found it will be added into this file. 
-C3C West talked to C3C Nunn over the phone for help with distinguishing the operator code in the register file. 
-No other help was provided to the best of C3C West and C3C Varnier's knowledge. 


