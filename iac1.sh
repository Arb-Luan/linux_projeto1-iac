



















































#!/bin/bash

# Verifica se está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Este script deve ser executado como root!" >&2
    exit 1
fi

echo "Criando diretórios..."

# Cria diretórios (com -p para evitar erros se existirem)
mkdir -p /publico /adm /ven /sec || {
    echo "Erro ao criar diretórios" >&2
    exit 1
}

echo "Criando grupos de usuários..."

# Cria grupos (ignora se já existirem)
groupadd GRP_ADM 2>/dev/null || true
groupadd GRP_VEN 2>/dev/null || true
groupadd GRP_SEC 2>/dev/null || true

echo "Criando usuários..."

# Função para criar usuários
criar_usuario() {
    local usuario=$1
    local grupo=$2
    # Senha com hash mais seguro (SHA-512)
    local senha_hash=$(openssl passwd -6 "Senha@123")
    
    if ! id "$usuario" &>/dev/null; then
        useradd -m -s /bin/bash -p "senha123" -G "$grupo" "$usuario" && \
        echo "Usuário $usuario criado com sucesso"
    else
        echo "Usuário $usuario já existe, pulando..." >&2
    fi
}

#Criando usuarios e atribuindo a grupos

# Usuários administrativos
criar_usuario carlos GRP_ADM
criar_usuario maria GRP_ADM
criar_usuario joao GRP_ADM  # Sem acento para evitar problemas

# Usuários de vendas
criar_usuario debora GRP_VEN
criar_usuario sebastiana GRP_VEN
criar_usuario roberto GRP_VEN

# Usuários de secretaria
criar_usuario josefina GRP_SEC
criar_usuario amanda GRP_SEC
criar_usuario rogerio GRP_SEC

echo "Configurando permissões dos diretórios..."

# Configura proprietário e grupo
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

# Configura permissões
chmod 770 /adm /ven /sec
chmod 777 /publico  # Permissões para diretório público

echo "Configuração concluída com sucesso!"
echo "FIM"
