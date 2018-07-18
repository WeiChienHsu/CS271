# Simple Error Checking

## Parity 
is the total number of 1 bits (including the extra parity bit) in a binary code.

Each computer architecture is designed to use either even parity or odd parity.

System adds a parity bit to make each code match the systems' parity.

## Eaxmple parity bits for 8-bit code 1101 0110

- Even-parity system: 1 1101 0110 (sets parity bit to 1 to make a total 6 one-bits)

- Odd-parity system: 0 1101 0110 (sets parity bit to 0 to keep 5 one-bits)

Code is checked for parity error whenever it is used.

- 101010101 Error for even-parit architrecture.

Used for checking memory, network transmissions.

Not 100% reliable - But very GOOD because most errors are single bit.

## n-bit code word (n = m + r)
- m data bits
- r check bits(to check parity)
- there are 2^n possible code words
- only 2^m code words are valid

## Arranging the parity bits
For 8 data bits, how many parity bits should be added?

Number the bits left -> right, 1 -> n (Different from usual numbering)

Bits numbered with powers of 2 are "parity bits"; others are "data bits"

## Example 1 : Represent decimal 45 as 8-bit with even parity Hamming code

分別找 p 1, p 2, p 4, p 8 該填入的數字，如果是 Even parity， 找到與該位 Binary Code 為1的所有數字，所擁有的 1 的總和數字，是否為偶數，不是偶數的話，對應的數字為1，是的話為0。

m = 8, 
r = (log8 + 1) = 4,
so n = 12

45 = 0010 1101 binary (8-bit)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
| ?  |  ? |  0 |  ? |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |

### 1's place

Parity bit #1 represents all place numbers having 1 in the 1's place.

Even parity requires that the count of '1' bits in these place(plus the parity bit) must be even. (There is one '1' data(9) bit in these place, so set bit #1 to 1)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  ? |  0 |  ? |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |

### 2's place

Parity bit #2 represents all place numbers having 1 in the 2's place.

There are two '1' (6,10) data bit in these place, so set bit #2 to 0)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  ? |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |

### 4's place

Parity bit #4 represents all place numbers having 1 in the 4's place.

There are two '1' (6, 12) data bit in these place, so set bit #4 to 0)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  0 |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |


### 8's place

Parity bit #8 represents all place numbers having 1 in the 8's place.

There are three '1' (9, 10, 12) data bit in these place, so set bit #4 to 1)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  0 |  0 |  1 |  0 | 1  |  1 |  1 |  0 |  1 |



#### Results

45 = 00101101 (8-bit binary)
45 = 100001011101 (12-bit even parity Hamming code)

***

## Example 2 : 1001 1111 0111 is a 12-bit odd-parity representation correct its single-bit error

Data bits are 0111 0111 = 119


| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  1 |  1 |  1 |  1 | 1  |  0 |  1 |  1 |  1 |

### 1s parity

Wrong. -> 5, 7, 11 there are 3 '1' bits, 1 should be 0.

### 2s parity

Wrong. -> there are 4 '1' bits, 2 should be 1.

### 4s parity 

Correct -> There are 4 '1' bits and 4 is 1 as well.


### 8s parity

Wrong -> There are 3 '1' bits and 8 should be 0.


### Result 

The only bit that is in 1s and 2s and 8s and is NOT in 4s is bit number 11. 
Therefore, the number should be 1001 1111 0101 = 117 

***

# Internal Representation

Regardless of external representation, all I/O eventually is converted into electrical(binary) codes.

Inside the computer, everything is represented by gates (Open/Closed).

# Tasks we should do

You should be able to show the binary/hexadecimal representations of:
- integer values (signed/unsigned)
- Characters(tables given on tests)
- Floating-point values
- Error-detecting codes(Parity)
- Error-correcting codes(Hamming)

You should be able to convert representations
- Binary <-> Decimal
- Decimal <-> Hexadecimal
- Hexadecimal <-> Binary

***

