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

| ALUOp | Funct₄:₁ (cmd) | Funct₀ (S) | Tipo   | ALUControl₁:₀ | FlagW₁:₀ |
|:-----:|:--------------:|:----------:|:-------|:-------------:|:---------:|
| 0     | X              | X          | Not DP | 00 (Add)      | 00        |
| 1     | 0100           | 0          | ADD    | 00 (Add)      | 00        |
| 1     | 0100           | 1          | ADD    | 00 (Add)      | 11        |
| 1     | 0010           | 0          | SUB    | 01 (Sub)      | 00        |
| 1     | 0010           | 1          | SUB    | 01 (Sub)      | 11        |
| 1     | 0000           | 0          | AND    | 10 (And)      | 00        |
| 1     | 0000           | 1          | AND    | 10 (And)      | 10        |
| 1     | 1100           | 0          | ORR    | 11 (Or)       | 00        |
| 1     | 1100           | 1          | ORR    | 11 (Or)       | 10        |
| 1     | 1001           | 0          | MUL    | XX            | 00        |
| 1     | 1001           | 1          | MUL    | XX            | 10        |

### ALU Operations y ALUControl Encodings

| Operación | ALUControl (2:0) | Descripción               |
|:---------:|:----------------:|:-------------------------:|
| **ADD**   | `000`            | `Result = SrcA + SrcB`    |
| **SUB**   | `001`            | `Result = SrcA - SrcB`    |
| **AND**   | `010`            | `Result = SrcA & SrcB`    |
| **OR**    | `011`            | `Result = SrcA \| SrcB`   |
| **MUL**   | `100`            | `Result = SrcA * SrcB`    |
| **MOV**   | `101`            | `Result = SrcB`           |
