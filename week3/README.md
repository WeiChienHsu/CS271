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

## Represent decimal 45 as 8-bit with even parity Hamming code

m = 8, 
r = (log8 + 1) = 4,
so n = 12

45 = 0010 1101 binary (8-bit)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
| ?  |  ? |  0 |  ? |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |

### 1's place

Parity bit #1 represents all place numbers having 1 in the 1's place.

Even parity requires that the count of '1' bits in these place(plus the parity bit) must be even. (There is one '1' data(9) bit in these place, so set bit #1 to 1)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  ? |  0 |  ? |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |

### 2's place

Parity bit #2 represents all place numbers having 1 in the 2's place.

There are two '1' (6,10) data bit in these place, so set bit #2 to 0)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  ? |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |

### 4's place

Parity bit #4 represents all place numbers having 1 in the 4's place.

There are two '1' (6, 12) data bit in these place, so set bit #4 to 0)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  0 |  0 |  1 |  0 |  ? |  1 |  1 |  0 |  1 |


### 8's place

Parity bit #8 represents all place numbers having 1 in the 8's place.

There are three '1' (9, 10, 12) data bit in these place, so set bit #4 to 1)

| p  | p  | d  | p  | d  | d  | d  | p  | d  | d  | d  | d  |
| 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 |
|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|
|  1 |  0 |  0 |  0 |  0 |  1 |  0 | 1  |  1 |  1 |  0 |  1 |