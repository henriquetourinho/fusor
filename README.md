# 🕒 FUSOR — Ajuste Automático de Fuso Horário

<p align="center">
  <img src="https://img.shields.io/github/languages/top/henriquetourinho/fusor?style=for-the-badge" alt="Linguagem Principal">
  <img src="https://img.shields.io/github/repo-size/henriquetourinho/fusor?style=for-the-badge" alt="Tamanho do Repositório">
  <img src="https://img.shields.io/badge/Status-Estável-brightgreen?style=for-the-badge" alt="Status">
  <img src="https://img.shields.io/badge/Vers%C3%A3o-1.0-blueviolet?style=for-the-badge" alt="Versão">
  <img src="https://img.shields.io/badge/Depend%C3%AAncias-Nenhuma-orange?style=for-the-badge" alt="Dependências">
  <img src="https://img.shields.io/badge/C%C3%B3digo%20Aberto-Sim-success?style=for-the-badge" alt="Código Aberto">
  <img src="https://img.shields.io/badge/Licen%C3%A7a-GPLv3-blue.svg?style=for-the-badge" alt="Licença GPLv3">
</p>

<p align="center">
  Script inteligente, autossuficiente e sem dependências que detecta sua localização e ajusta automaticamente o fuso horário do sistema.
</p>

<p align="center">
  <a href="#-sobre-o-projeto">Sobre</a> •
  <a href="#-funcionalidades">Funcionalidades</a> •
  <a href="#-demonstração">Demonstração</a> •
  <a href="#-tecnologias">Tecnologias</a> •
  <a href="#-como-usar">Como Usar</a> •
  <a href="#-licença">Licença</a> •
  <a href="#-autor">Autor</a>
</p>

---

## 🎯 Sobre o Projeto

O **FUSOR** é um script autossuficiente, projetado para **detectar automaticamente o fuso horário correto com base na sua localização** via IP público e aplicá-lo ao sistema Linux. Ideal para servidores, containers, sistemas headless ou qualquer máquina onde o tempo preciso é essencial.

---

## ✨ Funcionalidades

- 📍 **Geolocalização via IP automático**
- 🧠 **Detecção inteligente de `curl` ou `wget`**
- ⚙️ **Ajuste automático do fuso horário com `timedatectl`**
- 🛰️ **Sincronização automática de horário com NTP**
- 🔒 **Sem dependências externas (nem `jq`)**
- 📜 **Código limpo, colorido e explicativo**
- 💡 **Execução silenciosa ou com feedback detalhado**

---

## 📽️ Demonstração

```bash
sudo ./fusor.sh
````

> Resultado esperado:
>
> * Detecta sua cidade, país e fuso horário ideal
> * Verifica o fuso atual do sistema
> * Ajusta automaticamente se estiver incorreto
> * Ativa sincronização por rede (NTP)
> * Exibe um resumo final do horário

---

## 🛠️ Tecnologias Utilizadas

* Bash (100% POSIX compatível)
* `curl` ou `wget` (qualquer um funciona)
* `timedatectl` (presente em distros modernas)

---

## 🚀 Como Usar

### Pré-requisitos

* Sistema Linux com `timedatectl` (ex: Ubuntu, Debian, CentOS, Rocky, AlmaLinux)
* Acesso root (necessário para mudar o fuso)

### Instalação e Execução

```bash
git clone https://github.com/henriquetourinho/fusor.git
cd fusor
chmod +x fusor.sh
sudo ./fusor.sh
```

Ou, se quiser executar direto:

```bash
curl -sL https://raw.githubusercontent.com/henriquetourinho/fusor/main/fusor.sh | sudo bash
```

---

## 📜 Licença

Distribuído sob a **Licença Pública Geral GNU v3.0**
🔗 [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html)

---

## 👨‍💻 Autor

**Carlos Henrique Tourinho Santana**
📍 Salvador – Bahia – Brasil

* GitHub: [@henriquetourinho](https://github.com/henriquetourinho)
* LinkedIn: [Carlos Henrique Tourinho Santana](https://br.linkedin.com/in/carloshenriquetourinhosantana)
* Wiki Debian: [wiki.debian.org/henriquetourinho](https://wiki.debian.org/henriquetourinho)

---

<p align="center">
🛰️ Ajuste seu tempo. Alinhe seu sistema com o mundo.
</p>
