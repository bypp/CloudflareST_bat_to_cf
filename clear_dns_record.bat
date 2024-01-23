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

echo "正在查询域名资料..."
For /F %%r in ('curl -s -X GET "https://api.cloudflare.com/client/v4/zones/%zone_id%/dns_records?type=%ip_type%&name=%domain_name%" -H "X-Auth-Email:%email%" -H "X-Auth-Key:%gloabl_api%" -H "Content-Type:application/json"') do Set dns_records=%%r
echo "查询完毕，开始清理域名..."

for /f %%a in ('"echo %dns_records%" ^| jq .success') do (
	if /I "%%a" == "true" (
		for /f %%b in ('"echo %dns_records%" ^| jq .result[].id') do (
			curl -X DELETE "https://api.cloudflare.com/client/v4/zones/%zone_id%/dns_records/%%b" -H "X-Auth-Email:%email%" -H "X-Auth-Key:%gloabl_api%" -H "Content-Type: application/json"
			echo.
		)
	) 
)
echo "域名清理完成"
pause
