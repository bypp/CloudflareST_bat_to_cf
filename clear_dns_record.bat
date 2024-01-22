@echo off
chcp 65001
cls

set email=
set domain_name=
set ip_type=
set gloabl_api=
set zone_id=

echo "正在查询域名资料..."
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/%zone_id%/dns_records?type=%ip_type%&name=%domain_name%" -H "X-Auth-Email:%email%" -H "X-Auth-Key:%gloabl_api%" -H "Content-Type:application/json" > output.tmp
echo "查询完毕，开始清理域名..."
for /f %%a in ('jq ".success" output.tmp') do (
	if /I "%%a" == "true" (
		for /f %%b in ('jq ".result[].id" output.tmp') do (
			curl -X DELETE "https://api.cloudflare.com/client/v4/zones/%zone_id%/dns_records/%%b" -H "X-Auth-Email:%email%" -H "X-Auth-Key:%gloabl_api%" -H "Content-Type: application/json"
			echo.
		)
	) 
)
del output.tmp
echo "域名清理完成"
pause
