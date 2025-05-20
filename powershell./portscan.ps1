# A simple scanner for top ports in powershell
param($ip)

if (!$ip){
    echo ""
    echo "Insira como primeiro argumento a rede do IP/domínio alvo para varrer asportas mais comuns."
    echo "Exemplo: .\portscan 192.168.0"
    exit(0)
}

$topports = 21,22,23,80,81,27,440,443,445,1337,2011,21011

foreach ($port in $topports){
    if(Test-NetConnection $ip -Port $port -WarningAction SilentlyContinue -InformationLevel Quiet) {
        echo ""
        echo "Porta $port aberta."
    }
}
