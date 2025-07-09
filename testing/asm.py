# python3 asm.py test.asm out.memfile
import re
import sys
import traceback

TOKEN_SPEC = {
    "LABEL": r"[A-Za-z_][A-Za-z0-9_]*:",
    "REG": r"R(?:1[0-5]|[0-9])",
    "POINTER": r"[A-Za-z_][A-Za-z0-9_]*",
    # "OP": r'[A-Z]{1,5}(EQ|NE|CS|CC|MI|PL|VS|VC|HI|LS|GE|LT|GT|LE|AL)?S?',
    "IMM": r"#(?:0x[0-9a-fA-F]+|[0-9]+)",
    "COMMA": r",",
    "S_COLON": r";",
    "L_BRACKET": r"\[",
    "R_BRACKET": r"\]",
    "SPACE":r" ",
    "UNKOWN": r".",
}

def reg_val(r):
    val = int(r[1:])
    if not (0 <= val <= 15):
        raise ValueError(f"Registro fuera de rango (0-15): {r}")
    return val
def imm_val(s,m = 255):
    val = int(s[1:], 0)
    if not (0 <= val <= m):
        raise ValueError(f"Inmediato fuera de rango (0-{m}): {s}")
    return val

class ARM_Assembler:
    def __init__(self):
        pattern = "|".join(f"(?P<{name}>{regex})" for name, regex in TOKEN_SPEC.items())
        self.regex = re.compile(pattern, re.IGNORECASE)

        #################################
        #                               #
        # You can change encodings HERE #
        #                               #
        #################################

        self.dp_instr = {
            "AND": 0b0000,
            "SUB": 0b0010,
            "ADD": 0b0100,
            "ORR": 0b1100,
            "MOV": 0b1010,   
            "MUL": 0b1001,
            "DIV": 0b1011,
            "UMULL": 0b1110, # ALWAYS 1110
            "SMULL": 0b1110, #always
            "FADD": 0b1110, #always
            "FMULL": 0b1110, #always
            }

        self.mem_instr = {
            "STR": 0b00,
            "LDR": 0b01,
            "STRB": 0b10,
            "LDRB": 0b11,
        }
        self.b_instr = {"B": 0b0}
        self.conds = {
            "EQ": 0b0000,
            "NE": 0b0001,
            "CS": 0b0010,
            "HS": 0b0010,
            "CC": 0b0011,
            "LO": 0b0011,
            "MI": 0b0100,
            "PL": 0b0101,
            "VS": 0b0110,
            "VC": 0b0111,
            "HI": 0b1000,
            "LS": 0b1001,
            "GE": 0b1010,
            "LT": 0b1011,
            "GT": 0b1100,
            "LE": 0b1101,
            "AL": 0b1110,
        }

        #
        # Use this section to implement you own encodings with their respective "VALUE", these will have OP type of 11
        #
        self.spc_instr = {
            "ADDLNG": 0,  # Special instruction example
        }

        self.labels = {}
        self.valid_ops = (
            list(self.dp_instr.keys())
            + list(self.mem_instr.keys())
            + list(self.b_instr.keys())
            + list(self.spc_instr.keys())
        )

    # Only for tokenization purposes
    def tokenize_instruction(self, instr: str):
        tokens = []
        for match in self.regex.finditer(instr):
            kind = match.lastgroup
            value = match.group()

            if kind == "POINTER":
                possible_instr, cond, S = self.decode_mnemonic(value)
                if possible_instr in self.valid_ops and cond in self.conds:
                    kind = "OP"
            tokens.append((kind, value))
        return tokens

    def decode_mnemonic(self, instr: str):
        instr = instr.upper()
        flags = instr.endswith("S")
        if flags:
            instr = instr[:-1]
        cond = "AL"
        for suffix in self.conds:
            if instr.endswith(suffix):
                cond = suffix
                instr = instr[: -len(suffix)]
                break
        return instr, cond, flags
    
    #
    # MAIN INSTRUCTION ENCODER
    #
    def assemble_instruction(self, tokens: list[tuple[str, str]], pc) -> int:
        it = iter(tokens)
        w = next(it)

        # IGNORE LABEL
        while w[0] == "LABEL":
            if len(tokens) > 1:
                w = next(it)
            else:
                return -1

        if w[0] != "OP":
            raise RuntimeError(f"Function not implemented: {instr}")


        instr, cond, S = self.decode_mnemonic(w[1])
        
        regs = [reg_val(v) for (k, v) in tokens if k == "REG"]
        imms = [imm_val(v) for (k, v) in tokens if k == "IMM"]
        # OP == DP

        

        if instr in self.dp_instr:
            
            if instr == "FADD":
                if len(regs) == 3:
                    Rd, Rn, Rm = regs
                else:
                    print("Se necesitaban 3 registros")
                return (
                    (self.conds[cond] << 28) |
                    (0b11 << 26)             | # 11 para floating point
                    (0 << 23)                |  # I=0
                    (0b00 << 21)                |  #22:21 = 00 fadd 32
                    (0 << 20)                |  # S=0
                    (Rn << 16)             |
                    (Rd << 12)             |
                    (0 << 4)                |
                    (Rm)
                )
            if instr == "FADD_16":
                if len(regs) == 3:
                    Rd, Rn, Rm = regs
                else:
                    print("Se necesitaban 3 registros")
                return (
                    (self.conds[cond] << 28) |
                    (0b11 << 26)             | # 11 para floating point
                    (0 << 25)                |  # I=0
                    (0 << 24)                |  # A=0
                    (0 << 21)                |  # reservado
                    (0 << 20)                |  # S=0
                    (RdHi << 16)             |
                    (RdLo << 12)             |
                    (Rs << 8)                |
                    (0b1001 << 4)            |
                    (Rm)
                )    

            if instr == "FMUL":
                if len(regs) != 4:
                    raise RuntimeError("UMULL requiere 4 registros: RdLo, RdHi, Rm, Rs")
                RdHi, Rs,Rm, RdLo = regs
                return (
                    (self.conds[cond] << 28) |
                    (0b00 << 26)             |
                    (0 << 25)                |  # I=0
                    (0 << 24)                |  # A=0
                    (0 << 21)                |  # reservado
                    (0 << 20)                |  # S=0
                    (RdHi << 16)             |
                    (RdLo << 12)             |
                    (Rs << 8)                |
                    (0b1001 << 4)            |
                    (Rm)
                ) 
            if instr == "FMUL_16":
                if len(regs) != 4:
                    raise RuntimeError("UMULL requiere 4 registros: RdLo, RdHi, Rm, Rs")
                RdHi, Rs,Rm, RdLo = regs
                return (
                    (self.conds[cond] << 28) |
                    (0b00 << 26)             |
                    (0 << 25)                |  # I=0
                    (0 << 24)                |  # A=0
                    (0 << 21)                |  # reservado
                    (0 << 20)                |  # S=0
                    (RdHi << 16)             |
                    (RdLo << 12)             |
                    (Rs << 8)                |
                    (0b1001 << 4)            |
                    (Rm)
                )           
            if instr == "UMULL":
                if len(regs) != 4:
                    raise RuntimeError("UMULL requiere 4 registros: RdLo, RdHi, Rm, Rs")
                RdHi, Rs,Rm, RdLo = regs
                return (
                    (self.conds[cond] << 28) |
                    (0b00 << 26)             |
                    (0 << 25)                |  # I=0
                    (0 << 24)                |  # A=0
                    (0 << 21)                |  # reservado
                    (0 << 20)                |  # S=0
                    (RdHi << 16)             |
                    (RdLo << 12)             |
                    (Rs << 8)                |
                    (0b1001 << 4)            |
                    (Rm)
                )


            if instr == "SMULL":
                if len(regs) != 4:
                    raise RuntimeError("UMULL requiere 4 registros: RdLo, RdHi, Rm, Rs")
                RdHi, Rs,Rm, RdLo = regs
                return (
                    (self.conds[cond] << 28) |
                    (0b00 << 26)             |
                    (0 << 25)                |  # I=0
                    (0 << 24)                |  # A=0
                    (0 << 21)                |  # reservado
                    (1 << 20)                |  # S=1
                    (RdHi << 16)             |
                    (RdLo << 12)             |
                    (Rs << 8)                |
                    (0b1001 << 4)            |
                    (Rm)
                )

            if instr == "MOV":
                S = 0
                Rn = 0
                cmd = self.dp_instr[instr]

                if len(regs) == 1 and len(imms) == 1:
                    # MOV Rd, #imm
                    Rd = regs[0]
                    operand2 = imms[0]
                    I = 1
                elif len(regs) == 2 and len(imms) == 0:
                    # MOV Rd, Rm
                    Rd, Rm = regs
                    I = 0
                    operand2 = Rm
                else:
                    raise RuntimeError(
                        f"Invalid MOV format: shoulb be MOV Rd, Rm or MOV Rd, #imm"
                    )

                return (
                    (self.conds[cond] << 28)
                    | (0b00 << 26)
                    | (I << 25)
                    | (cmd << 21)
                    | (S << 20)
                    | (Rn << 16)
                    | (Rd << 12)
                    | operand2
                )

            #
            # If you are not using the standard CPU-lator encoding for 'MUL' remove the following condicional
            #
            if instr == "MUL":
                if len(regs) != 3:
                    raise RuntimeError(f"MUL requiere 3 registros: Rd, Rn, Rm")
                Rd, Rn, Rm = regs
                cmd = self.dp_instr[instr]   # 0b1001
                # Formato MUL:
                #   cond[31:28],
                #   00[27:26],
                #   opcode[24:21] = cmd,
                #   Rn[19:16],
                #   Rd[15:12],
                #   réplica opcode[7:4] = cmd,
                #   Rm[3:0]
                return (
                    (self.conds[cond] << 28)  |  # condición
                    (0b00            << 26)  |  # Data-Processing
                    (cmd             << 21)  |  # opcode bits [24:21]
                    (Rn              << 16)  |  # Rn
                    (Rd              << 12)  |  # Rd
                    (cmd             << 4 )  |  # replica opcode en [7:4]
                    (Rm)                       # Rm
                )


            if instr in ["LSL", "LSR"]:
                if len(regs) != 2 or not imms:
                    raise RuntimeError(
                        f" {instr} format invalid. Should be : {instr} Rd, Rm, #imm"
                    )
                Rd, Rm = regs
                shift_imm = imms[0]
                shift_type = 0b00 if instr == "LSL" else 0b01
                shift = (shift_imm << 7) | (shift_type << 5) | Rm
                cmd = self.dp_instr[instr]
                return (
                    (self.conds[cond] << 28)
                    | (0b00 << 26)
                    | (0 << 25)
                    | (cmd << 21)
                    | (S << 20)
                    | (0 << 16)
                    | (Rd << 12)
                    | shift
                )

            # General purpose encoding (eor, add, sub, etc)
            if len(regs) == 3:
                Rd, Rn, Rm = regs
                I = 0
                operand2 = Rm
            elif len(regs) == 2 and imms:
                Rd, Rn = regs
                I = 1
                operand2 = imms[0]
            else:
                raise RuntimeError("Invalid DP format")
            cmd = self.dp_instr[instr]

            return (
                (self.conds[cond] << 28)
                | (0b00 << 26)
                | (I << 25)
                | (cmd << 21)
                | (S << 20)
                | (Rn << 16)
                | (Rd << 12)
                | operand2
            )

        # OP == MEM
        if instr in self.mem_instr:
            #Check if MEM R1, [REG,REG] or [REG,IMM]
            Rd, Rn = regs[:2]
            code = self.mem_instr[instr]
            L = code & 1
            B = (code >> 1) & 1
            
            if len(regs) == 3:
                #is reg reg reg
                I = 1
                operand2 = (regs[2])
            elif len(regs) == 2 and len(imms) == 1:
                #is reg reg imm
                I = 0
                operand2 = imms[0]
            else: 
                raise RuntimeError("Invalid MEM type format")
            
            #always offset not post nor pre index
            return (
                (self.conds[cond] << 28)
                | (0b01 << 26)
                | (1 << 24)
                | (1 << 23)
                | (I << 25)
                | (B << 22)
                | (L << 20)                
                | (Rn << 16)
                | (Rd << 12)
                | operand2
            )

        # OP == B
        if instr in self.b_instr:
            label_tok = next((v for (k, v) in tokens if k == "POINTER"), None)
            if label_tok is None:
                raise RuntimeError("Falta label en B")
            if label_tok not in self.labels:
                raise RuntimeError(f"Label no definido: {label_tok}")
            offset = self.labels[label_tok] - (pc + 2)
            return (self.conds[cond] << 28) | (0b101 << 25) | (offset & 0xFFFFFF)

        #
        # Implement your own special encodings here with OP == SPC
        #
        if instr in self.spc_instr:
            # Example of fictional function with 4 registers input
            regs = [reg_val(v) for (k, v) in tokens if k == "REG"]
            if len(regs) != 4:
                raise RuntimeError(f"{instr} requires 4 registers")

            # Make sure register numbers are between 0-15
            RdLo, RdHi, RmLo, RmHi = regs  # The are already ints

            # Simple example codification
            return (
                (self.conds[cond] << 28)
                | (0b11 << 26)
                | (self.spc_instr[instr] << 20)
                | (RdLo << 16)
                | (RdHi << 12)
                | (RmLo << 8)
                | (RmHi << 4)
            )
        return 

    def assemble_program(self, program: str) -> list[int]:
        lines = program.strip().splitlines()
        lines = [l.split('//', 1)[0].strip() for l in lines]
        lines = [l for l in lines if l != ""]

        extract = []
        token_lines = []
        pc = 0  
        for i,line in enumerate(lines):
            tokens = self.tokenize_instruction(line)
            if not tokens:
                continue

            if tokens[0][0] == "LABEL":
                label_name = tokens[0][1][:-1]
                self.labels[label_name] = pc  # No se incrementa el PC
                # ¿Hay una instrucción en esta línea?
                if len(tokens) > 1:
                    instr_tokens = tokens[1:]
                    extract.append(line)
                    token_lines.append((i+1,pc, instr_tokens))
                    pc += 1  # Ahora sí hay instrucción
            else:
                extract.append(line)
                token_lines.append((i+1,pc, tokens))
                pc += 1  # Instrucción normal

        result = []
        i = 0
        for l,pc_val, tokens in token_lines:
            try:
                #CHECK SYNTAX
                kinds = [k for k,_ in tokens]
                if "UNKOWN" in kinds:
                    raise RuntimeError("Bad instruction formation.")
                result.append(self.assemble_instruction(tokens, pc_val))
                i += 1
            except Exception as e:
                print("\nERROR:", e)
                print("AT LINE:", i, ",WITH:", extract[i])
                print("FAILURE.")
                quit()
        return result, extract



#
# main entrypoint, reads asm and writes to file
#
if __name__ == "__main__":
    print("ARMv7 - Simple assembler. (Arch - CS2201) - 2025 - v2.0")
    if len(sys.argv) < 2:
        print("Execute as: python asm.py <input file> [<output file>]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "memfile.mem"

    assembler = ARM_Assembler()
    with open(input_file, "r") as infile:
        source_code = infile.read()

    lines = source_code.strip().splitlines()
    lines = [l for l in lines if l != ""]
    instrs, extract = assembler.assemble_program(source_code)

    print("\n== Instructions ==")
    for i, instr in enumerate(instrs):
        text = extract[i].lstrip().ljust(18)
        binstr = f"{instr:032b}"
        grouped = ' '.join(binstr[i:i+4] for i in range(0, len(binstr), 4))
        print(f"{i:02d} {text} : 0x{instr:08X}  b{grouped}") # para mostrar binario

    with open(output_file, "w") as f:
        for instr in instrs:
            f.write(f"{instr:08X}\n")

    print(f"\nSUCCESS: Hex memory written to {output_file}")
