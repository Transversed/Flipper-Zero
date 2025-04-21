# Lecture du script
$raw = Get-Content .\reverse.ps1 -Raw
$bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)

# Chiffrement XOR (clé = 23)
$key = 23
$xored = $bytes | ForEach-Object { $_ -bxor $key }

# Encodage Base64
$encoded = [Convert]::ToBase64String($xored)

# Résultat
$encoded | Set-Content .\payload.txt
