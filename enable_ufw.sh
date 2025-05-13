# !/bin/bash
#
# enable_ufw.sh - ativa o UFW e adicionar as portas ativas do sistema na regra de exceção do UFW.
#
# Autor..: Wesley Santos  <wesleyv760@gmail.com.br>
#
# -------------------------------------------------------------------------------------
#
# Este programa ativa o UFW (Firewall) e logo em seguida
# adicionar as portas ativas do sistema na regra de exceção do UFW.  
#


# Função para exibir a barra de progresso sincronizada com a execução real do comando
progress_bar() {
    local cmd="$1"      # Comando a ser executado passado como argumento
    local log_file="$2" # Nome do arquivo onde será armazenada a saída do comando

    rm -f "$log_file" # Remove o arquivo de log anterior, caso exista
    touch "$log_file" # Cria um novo arquivo vazio para armazenar a saída do comando

    # Executa o comando fornecido em segundo plano, redirecionando sua saída para o arquivo de log
    eval "$cmd" >"$log_file" 2>&1 &
    local cmd_pid=$!  # Captura o PID (identificador do processo) do comando em execução

    local total_lines=100     # Define um valor estimado de total de linhas processadas para calcular a barra de progresso
    local current_line=0      # Inicializa a variável que irá contar as linhas processadas no log
    local elapsed_time=0      # Tempo decorrido desde o início da execução do comando
    local max_time=180        # Tempo máximo (em segundos) antes de começar a exibir avisos (3 minutos)
    local warned=0            # Contador de quantos avisos já foram emitidos
    local warning_limit=5     # Limite máximo de avisos para o usuário
    local last_warning_time=0 # Registra o tempo do último aviso exibido

    # Loop que verifica continuamente se o processo ainda está rodando
    while kill -0 $cmd_pid 2>/dev/null; do

        # Conta o número de linhas geradas no arquivo de log até o momento
        current_line=$(wc -l < "$log_file")  
        
        # Calcula a porcentagem de progresso baseado no número de linhas geradas
        local progress=$((current_line * 100 / total_lines))

        # Garante que o progresso não ultrapasse 98% (para evitar uma finalização prematura)
        if [ $progress -gt 98 ]; then progress=98; fi  

        # Calcula quantos caracteres preencher na barra de progresso
        local filled=$((progress / 2)) # A cada 2% um ponto será preenchido
        local empty=$((50 - filled))   # Espaços vazios restantes para completar a barra

        # Exibe a barra de progresso no terminal
        printf "\r["                    # Retorna ao início da linha para sobreescrever a barra de progresso anterior
        printf "%0.s." $(seq 1 $filled) # Imprime os pontos correspondentes ao progresso
        printf "%0.s " $(seq 1 $empty)  # Imprime os espaços restantes
        printf "] %d%%" "$progress"     # Exibe a porcentagem de progresso
        sleep 0.5                       # Aguarda meio segundo antes da próxima atualização

        ((elapsed_time++)) # Incrementa o tempo decorrido

        # Verifica se o tempo máximo foi atingido e controla a exibição de avisos
        if ((elapsed_time >= max_time)); then

            if ((warned < warning_limit)); then
                local current_time=$(date +%s) # Obtém o tempo atual em segundos

                if ((current_time - last_warning_time >= 180)); then  # Se já passaram 3 minutos desde o último aviso
                    printf "\n\nO processo está demorando mais que o esperado. Aguarde...\n\n"

                    last_warning_time=$current_time # Atualiza o tempo do último aviso
                    ((warned++))                    # Incrementa o contador de avisos
                fi
            fi
        fi
    done

    # Quando o processo termina, exibe a barra de progresso completa
    printf "\r[..................................................] 100%% concluído\n"
}


# Função para verificar se o script está sendo executado como root
root () {
    if [ "$(id -u)" != 0 ]; then
        clear
        echo -e "\n🚫 Atenção!!!"
        echo -e "\nPara o funcionamento desse script, necessário executar com o usuário administrador (root).\n\n"
        exit 1
    fi    
}


# Função para escrever o banner no início da instalação
banner () {
    clear
    echo "

     /##   /## /######## /##      /##
    | ##  | ##| ##_____/| ##  /# | ##
    | ##  | ##| ##      | ## /###| ##
    | ##  | ##| #####   | ##/## ## ##
    | ##  | ##| ##__/   | ####_  ####
    | ##  | ##| ##      | ###/ \  ###
    |  ######/| ##      | ##/   \  ##
     \______/ |__/      |__/     \__/
                                
                        𝑀𝒶𝒹𝑒 𝐵𝓎: 𝒲 𝑒𝓈𝓁𝑒𝓎 𝒮𝒶𝓃𝓉𝑜𝓈"
}


# Função para verificar se o UFW está instalado
check_ufw () {
    sleep 3

    if command -v ufw >/dev/null 2>&1; then
        echo -e "\n\n✅ UFW já está instalado!"
        yes | sudo ufw enable >/dev/null 2>&1

    else
        echo -e "\n\n❌ UFW não encontrado, iniciando a instalação"
        progress_bar "sudo apt install -y ufw" "/tmp/ufw_log"
        yes | sudo ufw enable >/dev/null 2>&1
    fi
}


# Função para verificar quais portas o Sistema está usando e adicionar na regra de exceção
allow_ports_rules () {
    sleep 3

    # Pegando todas as portas em uso (TCP e UDP)
    ports=$(ss -tunlp | awk 'NR>1 {print $5}' | grep -oE '[0-9]+$' | sort -un)

    for port in $ports; do
        sleep 1
        sudo ufw allow $port/tcp >/dev/null 2>&1
        echo "Porta $port adicionada"
    done
    sleep 1
}


#Função para listar as portas que foram adicionas na regra de exceção
show_allowed_ports () {
    sleep 3

    echo -e "\n\nAs seguintes portas foram adicionadas na regra de exceção:"
    sudo ufw status | grep -v '(v6)' | grep -v 'Status:'
}


#################################################################################################################################


### Parte 1 - Validar se o Sistema Operacional possui o UFW instalado

root
banner

echo -e "\n\n-------- Verificando se seu Sistema Operacional possui o UFW (Firewall) ---------"
check_ufw
echo -e "\n\n-------------------- Verificação do UFW (Firewall) finalizada -------------------"

############################################################


### Parte 2 - Adicionar as portas que o Sistema está utilizando e adicionar na exceção

echo -e "\n\n\n\n---- 1. Adicionando as portas ativas na regra de exceção do UFW (Firewall) -----\n\n"
allow_ports_rules
echo -e "\n\n----------- Portas adicionadas na regra de exceção do UFW (Firewall) -----------"

############################################################


### Parte 3 - Listar as portas que foram adicionadas na regra de exceção

echo -e "\n\n\n\n----------------- Portas na regra de exceção do UFW (Firewall) -----------------"
show_allowed_ports
echo -e "\n--------------------------------------------------------------------------------\n\n"

############################################################
