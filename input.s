
.section .bss
# we declare the 'arr' memory location with size of 2 bytes.
.comm arr, 2

.section .text
.globl _start

# look here: these are your registers on x86_64:
# https://github.com/comporg26/BBS/blob/main/registers.txt

# for read() or write()
# %rax should contain a number of the syscall
#       read() syscall number is 0 in linux. 0x2000003 in macos.
#      write() syscall number is 1 in linux. 0x2000004 in macos.
# %rdi should contain a file descriptor.
#       stdin is 0, and stdout is 1
# %rsi shoud contain a buffer address (where to write the input, or where from output to console)
# %rdx should contain length of the buffer in bytes.

#exit() syscall number is 60 in linux. 0x2000001 in macos.

_start:
      mov $0, %rax                 # syscall number for read
      mov $0, %rdi                 # where to read from: stdin
      mov $arr, %rsi                 # buffer adr
      mov $2, %rdx                 # length of the buffer in bytes
      syscall

      mov  $1, %rax                # system call for write
      mov  $1, %rdi                # file handle for stdout
      mov  $arr, %rsi                # address of string to output
      mov  $2, %rdx                # number of bytes
      syscall

      mov   $60, %rax               # system call for exit
      # now, we want second character in the buffer to be
      # the return code of the program.
      # first character is (arr)
      # arr is a pointer, parentheses mean - get what is actually located
      # at that address.
      # so for the first character in the buffer we would do:
      # mov (arr), %rdi
      # but not only we need the second character
      # there is another problem:
      # before the comma we have a byte,
      # and after the comma we have a 64 bit register - i. e. 8 bytes.
      # we can use movb! but still, doesn't compile.
      # so how to move a byte in to that register?
      # a byte which is a second byte.
      movb  arr+1, %dil               # <--- CHANGED THIS
      syscall
