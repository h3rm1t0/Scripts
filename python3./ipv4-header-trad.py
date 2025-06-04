# Script that i had to made to solve a problem in one challenge. In this challenge was gived to me a sequence of bytes and i need to understand what protocol is,
#my first action was translate all bytes from hexadecimal for ASCII, but some part of the sequence was not translated. Thats when i had the idea of be some header
#of one protocol. To correct translate the sequence this script was created.

#!/bin/python3

import sys
import struct
import socket

def parse_ipv4_header(raw_bytes):
    if len(raw_bytes) < 20:
        raise ValueError("IPv4 header deve possuir no mínimo 20 bytes.")

    header = struct.unpack('!BBHHHBBH4s4s', raw_bytes[:20])

    version_ihl = header[0]
    version = version_ihl >> 4
    ihl = version_ihl & 0x0F
    tos = header[1]
    total_length = header[2]
    identification = header[3]
    flags_fragment = header[4]
    flags = flags_fragment >> 13
    fragment_offset = flags_fragment & 0x1FFF
    ttl = header[5]
    protocol = header[6]
    checksum = header[7]
    src_ip = socket.inet_ntoa(header[8])
    dst_ip = socket.inet_ntoa(header[9])

    print(f"{'Field':<20} | Value")
    print("-" * 40)
    print(f"{'Version':<20} | {version}")
    print(f"{'IHL (Header Length)':<20} | {ihl * 4} bytes")
    print(f"{'Type of Service':<20} | {tos}")
    print(f"{'Total Length':<20} | {total_length} bytes")
    print(f"{'Identification':<20} | 0x{identification:04x}")
    print(f"{'Flags':<20} | {bin(flags)}")
    print(f"{'Fragment Offset':<20} | {fragment_offset}")
    print(f"{'TTL':<20} | {ttl}")
    print(f"{'Protocol':<20} | {protocol} ({protocol_name(protocol)})")
    print(f"{'Header Checksum':<20} | 0x{checksum:04x}")
    print(f"{'Source IP':<20} | {src_ip}")
    print(f"{'Destination IP':<20} | {dst_ip}")

def protocol_name(proto_number):
    protocol_map = {
        1: 'ICMP',
        6: 'TCP',
        17: 'UDP',
    }
    return protocol_map.get(proto_number, 'Não identificado pela base de dados do programa.')

def main():
    if len(sys.argv) < 2:
        print("Utilização: ./ipv4-header-trad.py \"<hex bytes>\"")
        print("Exemplo: ./ipv4-header-trad.py \"45 00 00 4c d1 b4 00 00 40 01 4e a3 ac 10 01 37 c0 a8 01 01\"")
        sys.exit(1)

    hex_input = sys.argv[1].strip()
    try:
        raw_bytes = bytes.fromhex(hex_input)
    except ValueError:
        print("[Error] Hex String inválida.")
        sys.exit(1)

    try:
        parse_ipv4_header(raw_bytes)
    except ValueError as e:
        print("Error:", e)

if __name__ == "__main__":
    main()
