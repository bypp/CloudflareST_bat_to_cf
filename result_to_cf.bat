@echo off
chcp 65001
cls

for /f "tokens=1* delims==" %%a in (bat_config.txt) do (
	if %%a == email (set email=%%b)
	if %%a == domain_name (set domain_name=%%b)
	if %%a == ip_type (set ip_type=%%b)
	if %%a == zone_id (set zone_id=%%b)
	if %%a == gloabl_api (set gloabl_api=%%b)
)

echo "开始部署优选ip到域名..."
for /f "skip=1 delims=," %%i in (result.csv) do (
	curl -s -X POST "https://api.cloudflare.com/client/v4/zones/%zone_id%/dns_records" -H "X-Auth-Email:%email%" -H "X-Auth-Key:%gloabl_api%" -H "Content-Type:application/json" --data "{\"type\":\"%ip_type%\",\"name\":\"%domain_name%\",\"content\":\"%%i\",\"proxied\":false}"
	echo.
)
echo "部署完成"
pause
