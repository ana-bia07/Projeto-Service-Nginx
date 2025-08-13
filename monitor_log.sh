#!/bin/bash

#definidindo variaveis com ip e localização de arquivos
site="SEU_IP_AQUI" #pode ser verificado peo comando: ip a
dir="/var/log/nginx/scrip_logs"		#lugar onde esta o logs
log_file="$dir/monitor.log" 		#log com o status a cada minuto
status_log="$dir/status.txt" 		#status atual do log

dishook="https://discord.com/api/webhooks/SEU_WEBHOOK" 		#link do webhook

mkdir -p "$dir" 		#cria o diretorio caso ele não exista

status_code=$(curl -s -o /dev/null -w "%{http_code}" "$site") 		#guarda o status do site como uma unica string "200" ou outro
data=$(date "+%d/%m/%Y %H:%M:%S") 		#variavel pra data

#verifica se a variavel é igual a "200" ja que 200 é o status de OK e guarda isso em uam variavel
if [ "$status_code" = "200" ]; then
	status_atual="online"
else
	status_atual="offline"
fi

#compara o status  
if [ -f "$status_log" ]; then
	status_anterior=$(cat "$status_log")
else
	status_anterior="desconectado"
fi

#compara o status atual do priemiro if com o status anterio do segundo if. Caso seja diferente o log é atualizado com o status atual
if [ "$status_atual" != "status_anterior" ]; then
	echo "status atual: $status_atual . Atualizando status..." >> "$log_file"
	echo "$data = Site ficou $status_atual" >> "$log_file"

#Verifica se o status é offline, envia um alerta para o servidor do discord e inicia a reinicialização depois de 20 segundos.

	if [ "$status_atual" = "offline" ]; then
		echo "enviando alerta" >> "$log_file"
		curl -H "Content-Type: application/json" -X POST -d "{\"content\": \":rotating_light: **ALERTA DO SERVIDOR** :rotating_light: \\n\`\`\`O site está OFFLINE, fazendo reincialização $data\`\`\`\"}" "$dishook"

		sleep 20

		systemctl restart nginx

		curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"\\n\`\`\`\O site foi reinicializado, $data\`\`\`\"}" "$dishook" 
	fi
fi

echo "Status: $status_atual" > "$status_log"
