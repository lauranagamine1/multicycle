#!/usr/bin/env python3
import argparse
import sys

def repetir_archivo(input_path: str, output_path: str, veces: int):
    # Leer contenido del archivo de entrada
    try:
        with open(input_path, 'r', encoding='utf-8') as f_in:
            contenido = f_in.read()
    except FileNotFoundError:
        print(f"Error: no se encontró el archivo '{input_path}'", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error al leer '{input_path}': {e}", file=sys.stderr)
        sys.exit(1)

    # Escribir contenido repetido en el archivo de salida
    try:
        with open(output_path, 'w', encoding='utf-8') as f_out:
            for i in range(veces):
                f_out.write(contenido)
        print(f"✅ Escrito en '{output_path}' el contenido {veces} veces.")
    except Exception as e:
        print(f"Error al escribir en '{output_path}': {e}", file=sys.stderr)
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(
        description="Repite el contenido de un archivo de texto X veces en otro archivo.")
    parser.add_argument('input', help="Ruta al archivo de entrada (p. ej. input.txt)")
    parser.add_argument('output', help="Ruta al archivo de salida (p. ej. output.txt)")
    parser.add_argument('-n', '--times', type=int, default=1,
                        help="Número de veces que se repetirá el contenido (por defecto: 1)")
    args = parser.parse_args()

    if args.times < 1:
        print("Error: el número de repeticiones debe ser al menos 1.", file=sys.stderr)
        sys.exit(1)

    repetir_archivo(args.input, args.output, args.times)

if __name__ == '__main__':
    main()
