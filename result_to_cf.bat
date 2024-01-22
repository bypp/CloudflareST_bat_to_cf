@echo off
chcp 65001
cls

set email=
set domain_name=
set ip_type=
set gloabl_api=
set zone_id=

echo "开始部署优选ip到域名..."
for /f "skip=1 delims=," %%i in (result.csv) do (
	curl -s -X POST "https://api.cloudflare.com/client/v4/zones/%zone_id%/dns_records" -H "X-Auth-Email:%email%" -H "X-Auth-Key:%gloabl_api%" -H "Content-Type:application/json" --data "{\"type\":\"%ip_type%\",\"name\":\"%domain_name%\",\"content\":\"%%i\",\"proxied\":false}"
	echo.
)
echo "部署完成"
pause
