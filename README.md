# Fibonacci-Sequence

Write a RISC-V program to calculate the nth (n=0, 1, 2, …) Fibonacci number. 


**The Fibonacci sequence:**
0, 1, 1, 2, 3, 5, 8, 13, 21, 35, 89, 144, ...
The equation to calculate the nth (n= 0, 1, 2, …) Fibonacci number:
𝑭𝟎 = 𝟎 , for n=0
𝑭𝟏 = 𝟏 , for n=1
𝑭𝒏 = 𝑭𝒏−𝟏 + 𝑭𝒏−𝟐 , for n>=2


**Your program will accept a user input n from the RARS simulator’s console and calculate the 𝑭𝒏.**

(1) The user input value n must be read in as a string through ecall.

(2) Your program will convert the input string to the actual value n, which should be stored in a register you choose.

For example, if the input string is 18 consisting of characters “1” (ascii value 49), “8” (ascii value 56) and a newline (ascii value 10), after the conversion, your register holding n should contain the integer 18.

Hint: the ASCII table and RISC-V multiplication instruction mul will be needed.
An example of the mul instruction:
mul t0, t1, t2 # suppose t1 = 5, t2 = 10, then t0 = t1 * t2 = 50


(3) Your program must have a procedure named fibo, which takes the converted integer n as the input argument, performs necessary calculation and returns 𝑭𝒏 to your main procedure. You can choose either an iterative or a recursive version to implement 𝑭𝒏 = 𝑭𝒏−𝟏 + 𝑭𝒏−𝟐.


(4) Upon the return from fibo, the main procedure must print 𝑭𝒏 with the followingformat (suppose n is 4):
user input value = 4
the Fibonacci number is 3


(5) Every time your program runs, it should accept user input only once, then calculate and print the result. DO NOT make an infinite loop to accept user input.


(6) For register names, please use RISC-V calling convention.


**Exception handling**

(1) The Fibonacci sequence grows very fast as n increases. For example, when n = 100, the Fibonacci number is 354224848179261915075, which is far greater than the maximum signed integer expressed by a RISC-V register. Your program must be able to detect signed overflows as you use 𝑭𝒏 = 𝑭𝒏−𝟏 + 𝑭𝒏−𝟐 to calculate. For the determination of overflow.

Warning: it is easy to check online resources for a list of fibo numbers and determine an upper limit of input n such that the nth fibo will not overflow a RISC-V register. However, in your program, you are not allowed to compare your n with such an upper limit. Instead, you must perform actual calculation using 
Fn = Fn-1 + Fn-2,
and use the result to tell if an overflow happens. 

(2) For any n value that leads to an overflow, the fibo function should return -1 to indicate an invalid value, and the main procedure should print the result as (suppose
n is 100):
user input value = 100
the Fibonacci number is -1
