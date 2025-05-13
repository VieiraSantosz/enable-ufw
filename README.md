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
git clone https://github.com/VieiraSantosz/enable-ufw.git
```

**3. Navegar até o diretório do script**

Acesse a pasta onde o script foi clonado.
```bash
cd enable-ufw
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

![image](https://github.com/user-attachments/assets/5f5ee545-e05f-4fc1-b5b5-305b7d141c47)





