# Multicycle

# Decode
## Instruction Decoder
### Tabla – Main Decoder 

| Op  | Funct₅ | Funct₀ | Type   | Branch | MemtoReg | MemW | ALUSrc | ImmSrc | RegW | RegSrc | ALUOp |
|:---:|:------:|:------:|:-------|:------:|:--------:|:----:|:------:|:------:|:----:|:------:|:-----:|
| 00  | 0      | X      | DP Reg | 0      | 0        | 0    | 0      | XX     | 1    | 00     | 1     |
| 00  | 1      | X      | DP Imm | 0      | 0        | 0    | 1      | 00     | 1    | X0     | 1     |
| 01  | X      | 0      | STR    | 0      | X        | 1    | 1      | 01     | 0    | 10     | 0     |
| 01  | X      | 1      | LDR    | 0      | 1        | 0    | 1      | 01     | 1    | X0     | 0     |
| 10  | X      | X      | B      | 1      | 0        | 0    | 0      | 10     | 0    | X1     | 0     |

---

### Tabla – ALU Decoder

| ALUOp | Funct₄:₁ (cmd) | Funct₀ (S) | Tipo   | ALUControl₃:₀ | FlagW₁:₀ | is\_mul | Funct\[20] |
| :---: | :------------: | :--------: | :----- | :-----------: | :------: | :-----: | :--------: |
|   0   |        X       |      X     | Not DP |   0000 (Add)  |    00    |    0    |      X     |
|   1   |      0100      |      0     | ADD    |   0000 (Add)  |    00    |    0    |      X     |
|   1   |      0100      |      1     | ADD    |   0000 (Add)  |    11    |    0    |      X     |
|   1   |      0010      |      0     | SUB    |   0001 (Sub)  |    00    |    0    |      X     |
|   1   |      0010      |      1     | SUB    |   0001 (Sub)  |    11    |    0    |      X     |
|   1   |      0000      |      0     | AND    |   0010 (And)  |    00    |    0    |      X     |
|   1   |      0000      |      1     | AND    |   0010 (And)  |    10    |    0    |      X     |
|   1   |      1100      |      0     | ORR    |   0011 (Or)   |    00    |    0    |      X     |
|   1   |      1100      |      1     | ORR    |   0011 (Or)   |    10    |    0    |      X     |
|   1   |      1001      |      0     | MUL    |   0100 (Mul)  |    00    |    0    |      X     |
|   1   |      1001      |      1     | MUL    |   0100 (Mul)  |    10    |    0    |      X     |
|   1   |      1011      |      0     | DIV    |   0111 (Div)  |    00    |    0    |      X     |
|   1   |      1011      |      1     | DIV    |   0111 (Div)  |    10    |    0    |      X     |
|   1   |      XXXX      |      0     | UMULL  |  0110 (Umull) |    00    |    1    |      0     |
|   1   |      XXXX      |      1     | UMULL  |  0110 (Umull) |    10    |    1    |      0     |
|   1   |      XXXX      |      0     | SMULL  |  1000 (Smull) |    00    |    1    |      1     |
|   1   |      XXXX      |      1     | SMULL  |  1000 (Smull) |    10    |    1    |      1     |

### ALU Operations y ALUControl Encodings

| Operación | ALUControl 3:0) | Descripción               |
|:---------:|:----------------:|:-------------------------:|
| **ADD**   | `0000`            | `Result = SrcA + SrcB`    |
| **SUB**   | `0001`            | `Result = SrcA - SrcB`    |
| **AND**   | `0010`            | `Result = SrcA & SrcB`    |
| **OR**    | `0011`            | `Result = SrcA \| SrcB`   |
| **MUL**   | `0100`            | `Result = SrcA * SrcB`    |
| **MOV**   | `0101`            | `Result = SrcB`           |
| **DIV**   | `0111`            | `Result = SrcA / SrcB`    |
