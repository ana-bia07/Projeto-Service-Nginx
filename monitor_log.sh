#!/bin/bash
site="SEU_IP_AQUI" #pode ser verificado peo comando: ip a
dir="/var/log/nginx/scrip_logs"
log_file="$dir/monitor.log"
status_log="$dir/status.txt"

dishook="https://discord.com/api/webhooks/SEU_WEBHOOK"

mkdir -p "$dir"

status_code=$(curl -s -o /dev/null -w "%{http_code}" "$site")
data=$(date "+%d/%m/%Y %H:%M:%S")

if [ "$status_code" = "200" ]; then
	status_atual="online"
else
	status_atual="offline"
fi

if [ -f "$status_log" ]; then
	status_anterior=$(cat "$status_log")
else
	status_anterior="desconectado"
fi

if [ "$status_atual" != "status_anterior" ]; then
	echo "status atual: $status_atual . Atualizando status..." >> "$log_file"
	echo "$data = Site ficou $status_atual" >> "$log_file"

	if [ "$status_atual" = "offline" ]; then
		echo "enviando alerta" >> "$log_file"
		curl -H "Content-Type: application/json" -X POST -d "{\"content\": \":rotating_light: **ALERTA DO SERVIDOR** :rotating_light: \\n\`\`\`O site está OFFLINE, fazendo reincialização $data\`\`\`\"}" "$dishook"

		sleep 20

		systemctl restart nginx

		curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"\\n\`\`\`\O site foi reinicializado, $data\`\`\`\"}" "$dishook" 
	fi
fi

echo "Status: $status_atual" > "$status_log"
