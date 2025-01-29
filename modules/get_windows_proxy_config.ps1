# 读取注册表配置
$internet_setting = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$proxy_addr = $($internet_setting.ProxyServer)

# 提取代理地址
if (($proxy_addr -match "http=(.*?);") -or ($proxy_addr -match "https=(.*?);")) {
    $proxy_value = $matches[1]
    # 去除 http / https 前缀
    $proxy_value = $proxy_value.ToString().Replace("http://", "").Replace("https://", "")
    $proxy_value = "http://${proxy_value}"
} elseif ($proxy_addr -match "socks=(.*)") {
    $proxy_value = $matches[1]
    # 去除 socks 前缀
    $proxy_value = $proxy_value.ToString().Replace("http://", "").Replace("https://", "")
    $proxy_value = "socks://${proxy_value}"
} else {
    $proxy_value = "http://${proxy_addr}"
}

if ($internet_setting.ProxyEnable -eq 1) {
    Write-Host $proxy_value
}
