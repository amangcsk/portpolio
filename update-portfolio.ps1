# 작품목록_새로고침 : 폴더 이름을 정리하고, 폴더 속 작품 파일을 훑어서 portfolio-data.js 를 만듭니다.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# ---- 1) 예전 폴더 이름을 새 이름으로 바꾸기 (images -> gallery, videos -> musicvideos) ----
function Move-LegacyFolder($oldName, $newName) {
  $old = Join-Path $root $oldName
  $new = Join-Path $root $newName
  if (-not (Test-Path -LiteralPath $old)) { return }
  try {
    if (-not (Test-Path -LiteralPath $new)) {
      Rename-Item -LiteralPath $old -NewName $newName
      Write-Host "폴더 이름을 바꿨습니다: $oldName -> $newName"
    } else {
      foreach ($child in (Get-ChildItem -LiteralPath $old -Force)) {
        $dest = Join-Path $new $child.Name
        if (-not (Test-Path -LiteralPath $dest)) { Move-Item -LiteralPath $child.FullName -Destination $dest }
      }
      if (-not (Get-ChildItem -LiteralPath $old -Force)) { Remove-Item -LiteralPath $old }
      Write-Host "폴더 내용을 합쳤습니다: $oldName -> $newName"
    }
  } catch {
    Write-Host "※ '$oldName' 폴더 이름을 바꾸지 못했습니다. 탐색기에서 그 폴더를 닫고 다시 실행해 주세요."
  }
}
Move-LegacyFolder 'images' 'gallery'
Move-LegacyFolder 'videos' 'musicvideos'

# 폴더가 없으면 만들어 두기
foreach ($d in 'gallery','musicvideos','audios','study') {
  $path = Join-Path $root $d
  if (-not (Test-Path -LiteralPath $path)) { [void](New-Item -ItemType Directory -Path $path) }
}

# ---- 2) 폴더별로 받아들일 파일 종류 ----
$imgExt   = @('.jpg','.jpeg','.png','.webp','.gif','.bmp','.svg','.avif')
$vidExt   = @('.mp4','.webm','.mov','.m4v')
$audExt   = @('.mp3','.wav','.m4a','.ogg','.aac','.flac')
$frameExt = @('.html','.htm','.pdf')
$rules = [ordered]@{
  'gallery'     = $imgExt + $vidExt + $audExt + $frameExt
  'musicvideos' = $vidExt
  'audios'      = $audExt
  'stories'     = @('.txt','.md','.html','.htm','.pdf')
  'study'       = $imgExt + $vidExt + $audExt + @('.html','.htm','.pdf','.txt','.md','.doc','.docx','.hwp','.hwpx','.ppt','.pptx','.xls','.xlsx','.csv','.zip')
  'storyboard'  = @('.html','.htm')
  'apps'        = @('.html','.htm')
  'images'      = $imgExt
  'videos'      = $vidExt
}

# 위 목록에 없는 새 폴더(예: myworks)는 거의 모든 종류의 파일을 받아들입니다.
$openExt = $imgExt + $vidExt + $audExt + @('.html','.htm','.pdf','.txt','.md','.doc','.docx','.hwp','.hwpx','.ppt','.pptx','.xls','.xlsx','.csv','.zip')
$skipFolders = @('_thumbs','node_modules')

# ---- 글 파일 읽기 : 윈도우 메모장의 옛 한글 저장 방식(ANSI)이어도 알아서 맞춰 읽습니다 ----
function Read-TextAuto($path) {
  $bytes = [System.IO.File]::ReadAllBytes($path)
  try {
    $enc = New-Object System.Text.UTF8Encoding($false, $true)
    $t = $enc.GetString($bytes)
  } catch {
    try { $t = [System.Text.Encoding]::GetEncoding(949).GetString($bytes) }
    catch { $t = [System.Text.Encoding]::UTF8.GetString($bytes) }
  }
  return $t.TrimStart([char]0xFEFF)
}

# ---- 2-1) 작은 그림(미리보기) 만들기 준비 : 그림이 수백 장이어도 목록이 빠르게 뜨도록 줄여 둡니다 ----
$canThumb = $true
try { Add-Type -AssemblyName System.Drawing } catch { $canThumb = $false }
$thumbExt = @('.jpg','.jpeg','.png','.bmp','.gif')
$thumbMade = 0
function New-Thumb($srcPath, $dstPath) {
  $img = [System.Drawing.Image]::FromFile($srcPath)
  try {
    $max = 360
    $scale = [Math]::Min(1.0, $max / [Math]::Max($img.Width, $img.Height))
    $nw = [int][Math]::Max(1, [Math]::Round($img.Width * $scale))
    $nh = [int][Math]::Max(1, [Math]::Round($img.Height * $scale))
    $bmp = New-Object System.Drawing.Bitmap $nw, $nh
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::FromArgb(27,26,25))
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $nw, $nh)
    $g.Dispose()
    $dir = Split-Path -Parent $dstPath
    if (-not (Test-Path -LiteralPath $dir)) { [void](New-Item -ItemType Directory -Path $dir) }
    $bmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bmp.Dispose()
  } finally { $img.Dispose() }
}

# ---- 3) 폴더 훑기 ----
$items = New-Object System.Collections.ArrayList
# 훑을 폴더 = 위에 정해 둔 폴더 + 맨 위에 새로 만든 모든 폴더 (이름이 . 으로 시작하거나 _thumbs 인 폴더는 제외)
$folderList = New-Object System.Collections.ArrayList
foreach ($k in $rules.Keys) { [void]$folderList.Add($k) }
foreach ($dd in (Get-ChildItem -LiteralPath $root -Directory | Sort-Object Name)) {
  if ($dd.Name.StartsWith('.') -or ($skipFolders -contains $dd.Name)) { continue }
  if ($folderList -notcontains $dd.Name) { [void]$folderList.Add($dd.Name) }
}
foreach ($folder in $folderList) {
  $dir = Join-Path $root $folder
  if (-not (Test-Path -LiteralPath $dir)) { continue }
  $allowed = $openExt
  if ($rules.Contains($folder)) { $allowed = $rules[$folder] }
  $files = Get-ChildItem -LiteralPath $dir -Recurse -File | Sort-Object FullName
  foreach ($f in $files) {
    if ($f.Name.StartsWith('.') -or $f.Name.StartsWith('~')) { continue }
    if ($allowed -notcontains $f.Extension.ToLower()) { continue }
    $rel = $f.FullName.Substring($root.Length + 1).Replace('\', '/')
    $entry = [ordered]@{ file = $rel; date = $f.LastWriteTime.ToString('yyyy-MM-dd') }
    if ((@('.txt','.md') -contains $f.Extension.ToLower()) -and (($folder -eq 'stories') -or ($folder -eq 'study') -or (-not $rules.Contains($folder)))) {
      $entry['text'] = Read-TextAuto $f.FullName
    }
    # 그림 파일이면 작은 미리보기 그림을 만들어 _thumbs 폴더에 저장 (이미 있으면 건너뜀. 실패해도 목록 만들기는 계속됩니다)
    if ($canThumb -and ($thumbExt -contains $f.Extension.ToLower())) {
      try {
        $dst = Join-Path $root ('_thumbs\' + ($rel.Substring(0, $rel.Length - $f.Extension.Length).Replace('/', '\')) + '.jpg')
        if (-not (Test-Path -LiteralPath $dst) -or ((Get-Item -LiteralPath $dst).LastWriteTime -lt $f.LastWriteTime)) {
          New-Thumb $f.FullName $dst
          $script:thumbMade++
        }
      } catch { }
    }
    [void]$items.Add($entry)
  }
}

if ($items.Count -eq 0) { $json = '[]' } else { $json = ConvertTo-Json -InputObject @($items.ToArray()) -Depth 4 }
$out = "/* auto-generated by update script. do not edit by hand. */`r`nwindow.PORTFOLIO_FILES = $json;`r`n"
[System.IO.File]::WriteAllText((Join-Path $root 'portfolio-data.js'), $out, (New-Object System.Text.UTF8Encoding($false)))

# ---- 4) 폴더 구조 파일 만들기 : index.html 의 '폴더 구조' 보기에 쓰입니다. (실패해도 위의 작품 목록에는 영향이 없습니다) ----
try {
  function Build-TreeNode($path) {
    $kids = New-Object System.Collections.ArrayList
    $dirs = Get-ChildItem -LiteralPath $path -Directory -Force | Where-Object { -not $_.Name.StartsWith('.') -and $_.Name -ne '_thumbs' -and $_.Name -ne 'node_modules' } | Sort-Object Name
    foreach ($d in $dirs) { [void]$kids.Add((Build-TreeNode $d.FullName)) }
    $fs = Get-ChildItem -LiteralPath $path -File -Force | Where-Object { -not $_.Name.StartsWith('.') -and -not $_.Name.StartsWith('~') } | Sort-Object Name
    foreach ($f in $fs) { [void]$kids.Add([ordered]@{ n = $f.Name; t = 'f'; s = [long]$f.Length; d = $f.LastWriteTime.ToString('yyyy-MM-dd') }) }
    return [ordered]@{ n = (Split-Path -Leaf $path); t = 'd'; c = @($kids.ToArray()) }
  }
  $tree = Build-TreeNode $root
  $treeJson = ConvertTo-Json -InputObject $tree -Depth 30 -Compress
  $treeOut = "/* auto-generated: 폴더 구조 데이터. 작품목록_새로고침.bat 을 실행하면 새로 만들어집니다. */`r`nwindow.FOLDER_TREE = $treeJson;`r`n"
  [System.IO.File]::WriteAllText((Join-Path $root 'folder-tree.js'), $treeOut, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host '폴더 구조 파일(folder-tree.js)도 새로 만들었습니다.'
} catch {
  Write-Host '※ 폴더 구조 파일은 만들지 못했습니다. (작품 목록에는 영향이 없습니다.)'
}
Write-Host ''
Write-Host "완료! 작품 $($items.Count)개를 찾았습니다. (새로 만든 미리보기 그림 $thumbMade 개)"
Write-Host '이제 index.html 을 열거나 새로고침(F5) 하세요.'
