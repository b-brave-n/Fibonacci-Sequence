.data
buffer:     .space 12                 # reserve 12 bytes for the input text
msg1:       .asciz "user input value = " # prefix shown before echoing n
msg2:       .asciz "the Fibonacci number is " # prefix shown before the result

.text
main:
    # Read a line of text into buffer
    la a0, buffer                     # put address of buffer into a0
    li a1, 11                         # allow up to 10 chars plus newline
    li a7, 8                          # service code fxor string input (RARS)
    ecall                             # perform the input call

    # Parse the input string into integer n
    jal ra, convert                   # jump to string-to-int routine
    mv s2, a0                         # keep n in s2 instead of s0

    # Compute Fibonacci(n)
    mv a0, s2                         # place n as the function argument
    jal ra, fibo                      # call Fibonacci routine
    # --- CHANGE 1: Using different saved registers ---
    mv s3, a0                         # stash the result in s3 instead of s1

    # Emit "user input value = "
    la a0, msg1                       # a0 points to the label msg1
    li a7, 4                          # service code to print a string (RARS)
    ecall                             # print the message

    # Print the original integer n
    mv a0, s2                         # move n from s2 for printing
    li a7, 1                          # service code to print an integer (RARS)
    ecall                             # output n

    # Output a newline character
    li a0, 10                         # ASCII line feed
    li a7, 11                         # service code to print a character (RARS)
    ecall                             # write the newline

    # Emit "the Fibonacci number is "
    la a0, msg2                       # a0 points to the label msg2
    li a7, 4                          # service code to print a string
    ecall                             # print the message

    # Print the computed Fibonacci value
    mv a0, s3                         # place result from s3 for printing
    li a7, 1                          # service code to print an integer
    ecall                             # output the result

    # Output a newline character
    li a0, 10                         # ASCII line feed
    li a7, 11                         # service code to print a character
    ecall                             # write the newline

    # Terminate the program
    li a7, 10                         # service code to exit (RARS)
    ecall                             # end execution

# Convert the null-terminated buffer contents into an integer
convert:
    la t0, buffer                     # t0 walks the input bytes
    li t1, 0                          # accumulator starts at zero
    li t2, 10                         # base 10 multiplier
convert_loop:
    lbu t3, (t0)                      # fetch current character
    addi t0, t0, 1                    # advance to next character
    li t4, 10                         # ASCII newline code
    beq t3, t4, convert_end           # stop when newline is reached
    beqz t3, convert_end              # or stop at string terminator
    addi t3, t3, -48                  # turn '0'..'9' into 0..9
    mul t1, t1, t2                    # shift left one decimal digit
    add t1, t1, t3                    # incorporate current digit
    j convert_loop                    # continue scanning
convert_end:
    mv a0, t1                         # place numeric result in a0
    ret                               # return to caller

# Iterative Fibonacci with basic overflow detection
fibo:
    bnez a0, check_if_one             # If n is NOT 0, continue to next check.
    li a0, 0                          # Otherwise, n IS 0. Set return to 0 and exit.
    ret
check_if_one:
    li t0, 1                          # Load 1 for comparison
    bne a0, t0, start_loop            # If n is NOT 1, jump to the main loop setup.
    li a0, 1                          # Otherwise, n IS 1. Set return to 1 and exit.
    ret

start_loop:
    li s4, 0                          # s4 holds the n-2 term, starts at F(0)
    li s5, 1                          # s5 holds the n-1 term, starts at F(1)
    addi s6, a0, -1                   # Our loop counter starts at n-1
countdown_loop:
    beqz s6, countdown_end            # If counter reaches zero, we're done.
    
    add t5, s5, s4                    # New term = F(n-1) + F(n-2)
    bltz t5, fibo_overflow            # Check for overflow
    
    mv s4, s5                         # Update F(n-2) to be the old F(n-1)
    mv s5, t5                         # Update F(n-1) to be the new term
    
    addi s6, s6, -1                   # Decrement counter
    j countdown_loop
countdown_end:
    mv a0, s5                         # The result is now in s5
    ret

fibo_overflow:
    li a0, -1                         # indicate overflow with -1
    ret                               # return
