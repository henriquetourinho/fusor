#!/bin/bash

# ==============================================================================
# FUSOR (v1.0 - Autossuficiente)
# ==============================================================================
#
# Nome: Fusor
# Autor: Carlos Henrique Tourinho Santana
# GitHub: https://github.com/henriquetourinho/fusor
#
# CARACTERÍSTICAS:
# - TOTALMENTE AUTOMÁTICA: Nenhuma pergunta ao usuário.
# - INTELIGENTE: Detecta a ferramenta de rede disponível (curl ou wget).
# - AUTOSSUFICIENTE: Não requer a instalação de NENHUMA ferramenta adicional.
# - ROBUSTA: Verifica conexão, valida os dados e só age se necessário.
#
# ==============================================================================

# --- Definição de Cores para Feedback Visual ---
C_VERDE='\033[1;32m'
C_AMARELO='\033[1;33m'
C_VERMELHO='\033[1;31m'
C_CIANO='\033[1;36m'
C_NORMAL='\033[0m'

# --- Funções de Exibição Limpa ---
cabecalho() {
    clear
    echo -e "${C_CIANO}=======================================================================${C_NORMAL}"
    echo -e "${C_CIANO}                 Script Fusor - Ajuste Automático de Fuso               ${C_NORMAL}"
    echo -e "${C_CIANO}=======================================================================${C_NORMAL}"
    echo
}

info() { echo -e "${C_CIANO}ℹ${C_NORMAL} $1"; }
aviso() { echo -e "${C_AMARELO}⚠️ ${C_NORMAL} $1"; }
erro() { echo -e "${C_VERMELHO}❌ ERRO:${C_NORMAL} $1"; }
sucesso() { echo -e "${C_VERDE}✅ SUCESSO:${C_NORMAL} $1"; }

# --- Início da Lógica do Script ---
cabecalho

# 1. Verificar permissões de Root
if [[ $EUID -ne 0 ]]; then
   erro "Este script precisa de privilégios de root para funcionar."
   aviso "Por favor, execute com:${C_VERDE} sudo ./fusor.sh${C_NORMAL}"
   exit 1
fi
info "Permissões de root verificadas."

# 2. Detecção inteligente da ferramenta de rede
NET_CMD=""
if command -v curl &>/dev/null; then
    NET_CMD="curl -s"
    info "Ferramenta de rede encontrada: ${C_VERDE}curl${C_NORMAL}"
elif command -v wget &>/dev/null; then
    NET_CMD="wget -qO-"
    info "Ferramenta de rede encontrada: ${C_VERDE}wget${C_NORMAL}"
else
    erro "Nenhuma ferramenta de rede compatível (curl ou wget) foi encontrada."
    aviso "Não é possível continuar a detecção automática."
    exit 1
fi
sleep 1

# 3. Obter dados de geolocalização
info "Detectando sua localização com base no IP público..."
GEO_INFO=$($NET_CMD ipinfo.io/json)

if [[ -z "$GEO_INFO" ]]; then
    erro "Falha ao obter dados de geolocalização."
    aviso "Verifique sua conexão com a internet."
    exit 1
fi

# 4. Analisar os dados usando apenas ferramentas padrão (sem jq)
# Esta função usa 'sed' para extrair um valor de uma chave JSON.
parse_json() {
    local key=$1
    local json=$2
    echo "$json" | sed -n 's/.*"'"$key"'": "\(.*\)".*/\1/p'
}

TIMEZONE=$(parse_json "timezone" "$GEO_INFO")
CITY=$(parse_json "city" "$GEO_INFO")
COUNTRY=$(parse_json "country" "$GEO_INFO")

# 5. Validar os dados recebidos
if [[ -z "$TIMEZONE" ]]; then
    erro "Não foi possível identificar o fuso horário a partir da sua localização."
    aviso "A resposta do serviço de geolocalização pode ter mudado."
    exit 1
fi

info "Localização detectada: ${C_VERDE}$CITY, $COUNTRY${C_NORMAL}"
info "Fuso horário recomendado: ${C_VERDE}$TIMEZONE${C_NORMAL}"
sleep 1
echo

# 6. Comparar com o fuso horário atual e agir se necessário
CURRENT_TIMEZONE=$(timedatectl | grep 'Time zone' | awk '{print $3}')
info "Verificando o fuso horário atual do sistema..."
sleep 1

if [[ "$CURRENT_TIMEZONE" == "$TIMEZONE" ]]; then
    sucesso "O fuso horário do sistema já está configurado corretamente!"
    aviso "Nenhuma alteração é necessária."
else
    aviso "O fuso horário do sistema (${C_AMARELO}$CURRENT_TIMEZONE${C_NORMAL}) está diferente do recomendado."
    info "Ajustando o sistema para ${C_VERDE}$TIMEZONE${C_NORMAL}..."
    
    # Aplica o fuso horário E ativa a sincronização pela rede (NTP)
    timedatectl set-timezone "$TIMEZONE"
    timedatectl set-ntp true &>/dev/null
    
    if [[ $? -eq 0 ]]; then
        sucesso "Sistema atualizado com sucesso!"
    else
        erro "Ocorreu um erro ao tentar definir o fuso horário."
        exit 1
    fi
fi

# 7. Exibir o status final para confirmação
echo
info "Resumo final do estado do sistema:"
echo -e "${C_CIANO}-----------------------------------------------------------------------${C_NORMAL}"
echo -e "  ${C_AMARELO}Fuso Horário...........:${C_NORMAL} $(timedatectl | grep 'Time zone' | awk '{print $3}')"
echo -e "  ${C_AMARELO}Horário Sincronizado...:${C_NORMAL} $(timedatectl | grep 'synchronized' | awk '{print $4}')"
echo -e "  ${C_AMARELO}Serviço NTP Ativo......:${C_NORMAL} $(timedatectl | grep 'NTP service' | awk '{print $3}')"
echo -e "  ${C_VERDE}Hora Local Atual.......:${C_NORMAL} $(date)"
echo -e "${C_CIANO}-----------------------------------------------------------------------${C_NORMAL}"

exit 0