#Simple ping sweap that can return all local hosts in one small and local subnet

param($ip)

if(!$ip){

    echo ""
    echo "Insira no primeiro argumento o IP do alvo."
    echo "Exemplo: .\ping_sweap 192.168.0"

} else {
    echo "Varrendo sub-rede $ip ..."
    echo ""
    
    foreach ($var1 in 1..254){
        try {$output = $output2 = ping -n 1 "$ip.$var1" | Select-String "bytes=32"
            $output.Line.split(' ')[2] -replace ":",""
            $output2.Line.split(' ')[5] -replace "TTL=",""
    }catch {}
    }
}
