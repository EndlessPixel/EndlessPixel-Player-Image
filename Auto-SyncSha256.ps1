<#
    自动同步图片 assets.json + 计算 SHA256 + 差异对比
    放在项目根目录运行
#>

$ErrorActionPreference = "Stop"

# 配置
$assetsDir      = "./assets"
$jsonPath       = "./assets.json"
$baseUrl        = "https://raw.githubusercontent.com/EndlessPixel/EndlessPixel-Player-Image/main/assets/"

# 读取现有 JSON
$jsonList = @()
if (Test-Path $jsonPath) {
    try {
        $jsonList = Get-Content $jsonPath -Raw | ConvertFrom-Json
    } catch {
        Write-Warning "JSON 格式错误，将重新生成"
        $jsonList = @()
    }
}

# 获取本地所有图片
$images = Get-ChildItem -Path $assetsDir -File -Include *.png, *.jpg, *.jpeg | Sort-Object LastWriteTime -Descending

# 差异统计
$stats = @{
    New       = 0
    Updated   = 0
    NoChange  = 0
    Missing   = 0
}

Write-Host "`n=== 图片差异对比 ===" -ForegroundColor Cyan

# 遍历本地图片
foreach ($img in $images) {
    $name = $img.Name
    $fullPath = $img.FullName
    $date = $img.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    $resolution = "3840x2160"
    $player = "system_mini"

    # 计算 SHA256
    $sha = (Get-FileHash -Path $fullPath -Algorithm SHA256).Hash

    # 查找是否已存在
    $item = $jsonList | Where-Object { $_.path -like "*$name" }

    if ($item) {
        # 已存在：对比 SHA
        if ($item.sha256 -ne $sha) {
            $item.sha256 = $sha
            Write-Host "[更新] $name" -ForegroundColor Yellow
            $stats.Updated++
        } else {
            $stats.NoChange++
        }
    } else {
        # 新增
        $newItem = [PSCustomObject]@{
            path    = $baseUrl + $name
            player  = $player
            date    = $date
            resolution    = $resolution
            sha256  = $sha
        }
        $jsonList += $newItem
        Write-Host "[新增] $name" -ForegroundColor Green
        $stats.New++
    }
}

# 检查 JSON 中存在但本地已删除的图片
$toRemove = @()
foreach ($item in $jsonList) {
    $name = $item.path.Split('/')[-1]
    $localPath = Join-Path $assetsDir $name
    if (-not (Test-Path $localPath)) {
        $toRemove += $item
        $stats.Missing++
    }
}

# 删除丢失项
foreach ($del in $toRemove) {
    $jsonList = $jsonList | Where-Object { $_ -ne $del }
    Write-Host "[已删除] $($del.path.Split('/')[-1])" -ForegroundColor Red
}

# 保存
$jsonList | ConvertTo-Json -Depth 10 | Out-File $jsonPath -Encoding utf8

# 输出报告
Write-Host "`n=== 同步完成 ===" -ForegroundColor Green
Write-Host "新增: $($stats.New) | 更新: $($stats.Updated) | 无变化: $($stats.NoChange) | 已删除: $($stats.Missing)"
Write-Host "文件已保存到: $jsonPath`n"