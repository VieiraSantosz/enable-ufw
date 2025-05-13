<h1 align="center">

![image](https://github.com/user-attachments/assets/208b5073-3233-4ba3-aa4e-180979c800c0)

Script para ativação do UFW

</h1>

<h4 align="center">

Instruções para executar o script enable_ufw.sh. 

</h4>

## Pré-Requisitos

Antes de executar o script, verifique se o seu servidor atende aos seguintes requisitos:

- **Sistema operacional:** Ubuntu ou Debian

## Execução do Script
**1. Atualizar o servidor**

Antes de executar o script, certifique-se de que o servidor está atualizado. Isso garante que os pacotes necessários sejam instalados corretamente.
```bash
sudo apt update && sudo apt upgrade -y
```

**2. Clone o repositório**

Clone o repositório onde o script de instalação está armazenado.
```bash
git clone https://github.com/VieiraSantosz/script-ufw.git
```

**3. Navegar até o diretório do script**

Acesse a pasta onde o script foi clonado.
```bash
cd script-ufw
```

**4. Conceder permissões para o script**

Antes de executar o script, é necessário garantir que ele tenha permissões de execução.
```bash
chmod +x enable_ufw.sh
```

**5. Executar o script de instalação**

Agora, execute o script para iniciar a instalação do Grafana.
```bash
./enable_ufw.sh
```

![image](https://github.com/user-attachments/assets/b5c8b4c3-4c39-4834-bf12-c836a607aa07)

Após a execução do script, serão exibidas as portas adicionadas às regras de exceção do UFW (firewall).

![image](https://github.com/user-attachments/assets/7783b32f-6797-4550-8278-e6b45e1ed517)




