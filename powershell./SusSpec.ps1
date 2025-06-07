##Suspicious Process Scan Script v1.0

param($1)

Write-Host ""
Write-Host "#########################################################################"
Write-Host "############_____###################_____################################"
Write-Host "##########/ _____|################/ _____|###############################"
Write-Host "#########/ /#####################/ /#####################################"
Write-Host "#########\ \_____##########___###\ \_____###_____##____###____###########"
Write-Host "##########\_____ \#| |#| |/___/###\_____ \#|  _  || __ |#|  __|##########"
Write-Host "############### \ \| |#| |\___##########\ \| |_| || ___|#| |#############"
Write-Host "###########_____/ /| |#| | ___\####_____/ /|___ _|| |__##| |__###########"
Write-Host "##########|_____ / |_____/\___/###|______/#|_|####|____|#|____|##########"
Write-Host "#########################################################################"
Write-Host ""


if ($($args.Count) -ne 0 -or $($1) -eq "-h"){
    Write-Host ""
    Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ DESCRIÇÃO DO SCAN +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
    Write-Host "O programa realiza a captura de todos os processos e vai somando pontos a ele caso se enquadre em um lista de suspeitos."
    Write-Host "Existem três listas: diretórios suspeitos, extensões suspeitas e nomes suspeitos, cada processo realiza um processo de  "
    Write-Host "iteração com cada item da lista e para cada enquadramento dentro da lista é somado o score de um ponto a criticidade."
    Write-Host ""
    Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ INTRUÇÕES DE USO +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
    Write-Host "Insira um argumento para definir o nível de criticidade do scanner."
    Write-Host "O nível de criticidade determinará qual o somatório de flags que um processo deverá ter para ser considerado suspeito."
    Write-Host ""
    Write-Host "Exemplo: .\SusSpec.ps1 2"
    exit 1
}

Write-Host "[ENTRADA]: $1"

try{
    if ($($1.Length) -gt 4 -or $([int]$1) -gt 9999){
        Write-Host "[ERRO] Limite de caracteres excedido."

        Write-Host ""
        Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ DESCRIÇÃO DO SCAN +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
        Write-Host "O programa realiza a captura de todos os processos e vai somando pontos a ele caso se enquadre em um lista de suspeitos."
        Write-Host "Existem três listas: diretórios suspeitos, extensões suspeitas e nomes suspeitos, cada processo realiza um processo de  "
        Write-Host "iteração com cada item da lista e para cada enquadramento dentro da lista é somado o score de um ponto a criticidade."
        Write-Host ""
        Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ INTRUÇÕES DE USO +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
        Write-Host "Insira um argumento para definir o nível de criticidade do scanner."
        Write-Host "O nível de criticidade determinará qual o somatório de flags que um processo deverá ter para ser considerado suspeito."
        Write-Host ""
        Write-Host "Exemplo: .\SusSpec.ps1 2"
        exit 1
    }
}catch{
    Write-Host "[ERRO] Limite de caracteres excedido ou entrada inválida."
    
        Write-Host ""
    Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ DESCRIÇÃO DO SCAN +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
    Write-Host "O programa realiza a captura de todos os processos e vai somando pontos a ele caso se enquadre em um lista de suspeitos."
    Write-Host "Existem três listas: diretórios suspeitos, extensões suspeitas e nomes suspeitos, cada processo realiza um processo de  "
    Write-Host "iteração com cada item da lista e para cada enquadramento dentro da lista é somado o score de um ponto a criticidade."
    Write-Host ""
    Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ INTRUÇÕES DE USO +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
    Write-Host "Insira um argumento para definir o nível de criticidade do scanner."
    Write-Host "O nível de criticidade determinará qual o somatório de flags que um processo deverá ter para ser considerado suspeito."
    Write-Host ""
    Write-Host "Exemplo: .\SusSpec.ps1 2"

    exit 1    
}

try{
    $crit = [int]$1
    Write-Host "Nível de criticidade definido como $crit"
}catch{
    Write-Host "[ERRO] Entrada inválida. Insira apenas a algarismos."
        Write-Host ""
        Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ DESCRIÇÃO DO SCAN +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
        Write-Host "O programa realiza a captura de todos os processos e vai somando pontos a ele caso se enquadre em um lista de suspeitos."
        Write-Host "Existem três listas: diretórios suspeitos, extensões suspeitas e nomes suspeitos, cada processo realiza um processo de  "
        Write-Host "iteração com cada item da lista e para cada enquadramento dentro da lista é somado o score de um ponto a criticidade."
        Write-Host ""
        Write-Host "+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+ INTRUÇÕES DE USO +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
        Write-Host "Insira um argumento para definir o nível de criticidade do scanner."
        Write-Host "O nível de criticidade determinará qual o somatório de flags que um processo deverá ter para ser considerado suspeito."
        Write-Host ""
        Write-Host "Exemplo: .\SusSpec.ps1 2"
        exit 1
}

$susdirs = @("Downloads", "System32", "system32", "osmar", "Program Files")               #Define a lista de diretórios que serão considerados suspeitos
$susnames = @("svchost", "svch0st", "calc", "powershell", "chrome_updater")               #Define a lista de nomes de  suspeitos
$susext = @("exe", "ps1", "bat", "py")                                                    #Define a lista de extensões suspeitas

$suslist = @()
    
$processos = Get-Process                                                                    #Define os objetos de iteração como a variável $processos                                      

foreach ($processo in $processos){
    $n = 0
    foreach ($dir in $susdirs){
        try {
            if ($($processo.Path).Contains($dir)){
                Write-Host "[!PROCESSO COM DIRETÓRIO SUSPEITO]  Nome:$($processo.ProcessName)  Diretório: $($processo.Path)"
                $n =$n + 1
            }
        }catch{
          Write-Host "[!PROCESSO DE EXPRESSÃO COM VALOR NULO] Nome:$($processo.ProcessName)"
       }
    
    }
    
       foreach ($name in $susnames){
            try{
                if ($($processo.ProcessName).Contains($name)){
                    Write-Host "[!!PROCESSO COM NOME SUSPEITO]  Nome:$($processo.ProcessName)  Diretório: $($processo.Path)"
                    $n = $n + 1
                }
            }catch{
                Write-Host "[!!PROCESSO DE EXPRESSÃO COM VALOR NULO] Nome:$($processo.ProcessName)"
            }
        
        }
        
            foreach($ext in $susext){
                try{
                    if ($($processo.Path.Split(".")).Contains($ext)){
                        Write-Host "[!!!PROCESSO COM EXTENSÃO SUSPEITA] Nome: $($processo.ProcessName)  Diretório: $($processo.Path)"
                        $n = $n + 1
                    }
                }catch{
                    Write-Host "[!!!PROCESSO DE EXPRESSÃO DE VALOR NULO] nome: $($processo.ProcessName)"
                }    
            }
    Write-Host "SOMATORIO DE PONTOS N = $($n)"
    if ($n -gt $crit){
        $suslist += $processo
    }    
}

Write-Host ""
Write-Host "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
Write-Host "+-+-+-+-+-+-+-+-+-+-+-+-+- LISTA DE PROCESSOS COM MAIS DE $crit ASPECTO(S) SUSPEITO(S) -+-+-+-+-+-+-+-+-+-+-+-+-+"
Write-Host "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
Write-Host ""

foreach($item in $suslist){
    Write-Host "Nome:   $($item.ProcessName)   ID:    $($item.Id)   Diretório:   $($item.Path)"
}

