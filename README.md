# Projeto-Service-Nginx

# 📌 Configuração de Servidor Web com Monitoramento Automático

![Ubuntu Server](https://img.shields.io/badge/Ubuntu_Server-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)

## 🎯 Objetivo
Subir um site e configurar o monitoramento dele, recebendo alertas no **Discord** caso o servidor caia, e realizar a reinicialização automática para colocá-lo no ar novamente.

---

## 1️⃣ Instalar e Configurar o Servidor

### 1.1 Instalar e Configurar a VM
- Criar uma máquina virtual.
- Instalar o **Ubuntu Server**.
- Configurar a rede em **modo Bridge** para acesso local.
- Configuração utilizada:  
![print configuração netplan](print-netplan.png)

Para alterar manualmente:
```bash
cd /etc/netplan
sudo nano nome_do_arquivo.yaml
