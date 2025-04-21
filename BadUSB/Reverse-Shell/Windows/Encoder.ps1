$raw = Get-Content .\reverse.ps1 -Raw
$bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
$key = 23
$xored = $bytes | ForEach-Object { $_ -bxor $key }
$encoded = [Convert]::ToBase64String($xored)
Set-Clipboard $encoded
Write-Host "✅ Base64 copié dans le presse-papiers !"