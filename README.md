# **Counterstrike-Source_ClientLogViewer**
Für mich war es unangenehm .. läßtig, staendig in der Console durch ~100 Zeilen zu gehen, um nachzulesen was jemand in den Chat geschrieben hat oder um zu sehen ob ich den Gegner überhaupt getroffen habe. Deshalb habe ich die App gebaut, mit der ich auf einem zweiten Monitor oder Tablet via Webbrowser auf einen Blick sehe was mich interessiert.
<ul>
<li>Wer mich getroffen(Weiß), gekillt hat(Rot)</li>
<li>Wen ich getroffen(Weiß), gekillt habe(Grün)</li>
<li>Wer den Server betritt .. ich sage gern Moin moin.(Gelb 60% Deckkraft)</li>
<li>Admin Nachrichten(Gelb zwischen Trennlinien) &#x26; Spielerchat(Weiß,Türkis im Wechsel) sehen und nochmal leichter nachlesen, z.B wenn man auf die nächste Runde wartet</li>
<li>Uhrzeit, so sieht man wann die Chatmessage kam -und man brauch das Fenster nicht wechseln um zu sehen ob es Bedtime ist. &#x1F601;</li>
</ul>
<img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/CSSClientLogViewer_index_01.png"/>

[![Video-Titel](https://img.youtube.com/vi/I8PVUq3ZD3U/maxresdefault.jpg)](https://www.youtube.com/watch?v=I8PVUq3ZD3U)
https://youtu.be/I8PVUq3ZD3U

&#42;Die App ist für Deutsch CSS. Hat man andere Sprache eingestellt, muss im Code die Abfragen/Filter entsprechend angepasst werden.
<hr/>
<hr/>


## Installation
 s. <a href="https://youtube.com">Video</a> 
### File Details (zip)
|File|Comment|
|----|-------|
|".\WSSrv.psm1"| WebSocketServer, damit mit einem Webbrowser via Socket Daten ausgetauscht werden kann|
|".\LiteWebServer.psm1"| leichter Webserver der Seiten und Javascript von wwwroot s. unten bereitstellt
|".\CSSConsoleFilter.ps1"|dieses Script ist die App selbst, vom Endanwender zu starten.<br/>Logfilter ist fuer die Deutsche Steamversion entwickelt, fuer andere Sprachen muss Anpassungen im Code gemacht werden.
|"wwwroot"| Verzeichnis welches die Webseiten und Code fuer LiteWebServer enthaellt |
|| <table border=0><tr><td><ul><li> index.html></td><td><img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/CSSClientLogViewer_index_01.png" widht=120px height=200px/><br/>im Firefox </li></ul></td></tr><tr><td><ul><li> DReport.html </li><li>Chat.html</li><li>script.js</li></ul></td><tr></table>|

### Variablen, anzupassen an eigene Umgebung

<table>
<th>File</th>
<th></th>
<tr><td>".\CSSConsoleFilter.ps1"</td>
<td><p>
############################################################################################################<br/>
############################################################################################################<br/>
&#35; Globale Variablen, anzupassen an eigene Umgebung<br/>
############################################################################################################<br/>
############################################################################################################<br/>
&#x24;global:CSLogFile        = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Source\cstrike\console.log"<br/>
&#x24;global:yourUserName     = "Blue" # braucht es zum Filter von wem man gekillt bzw. verwundet wurde ("Blue" als Beispiel .. mein Tag)<br/>
&#x24;global:webroot          = ".\wwwroot\" # location wo index.html, DReport.html, Chat.html, script.js zu finden sind<br/>


&#x24;global:webSrv           = "http://localhost:5000/" 
&#35;&#x24;global:webSrv           = "http://+:5000/" #listen on any interface (matching netsh or running on admin console required)<br/>

&#x24;global:webSocketDReport = "http://localhost:5001/" #"http://+:5001/",  # listen on any interface (matching netsh or running on admin console required)<br/>
&#x24;global:webSocketChat    = "http://localhost:5002/" #"http://+:5002/",  # listen on any interface (matching netsh or running on admin console required)<br/>
&#35;&#x24;global:webSocketDReport = "http://+:5001/" # listen on any interface (matching netsh or running on admin console required)<br/>
&#35;&#x24;global:webSocketChat    = "http://+:5002/" # listen on any interface (matching netsh or running on admin console required)


<&#35; 
Will man von externen Geraeten(Tablet) auf den laufenden Webserver zugreifen (http://+:500x/) muss in der Windowsfirewall die Ports freigeben sein 
und dem Anwender der das Script startet via netsh alc gesetzt sein. s. "Windows Security Policy"
&#35;>

############################################################################################################
</p></td>
</tr>
</table>
<br/>

Aktivieren der Console &#x26; Connection debug, bei start von CSS
<ul>
<li>Steam</li>
<li>Bibliothek</li>
<li>CSS rechte Maus-->Eigenschaften</li>
<li>Menue "Allgemein" &commat;Startoptionen <code>-console -condebug</code>hinzufuegen</li>
</ul>
<img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/css_enable_console_condebug.png"/>
<img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/css_enabled_logfile.png"/>


### Windows Security Policy: Um dieses PS-Script laufen zu lassen, muss es mit einem Zertifikat signiert werden.

Ausführliche Information, wie man ein "self signed certificat" erstellt und sein Script signiert<br/><a href="https://www.powershelltips.com/powershell-sign-scripts/">https://www.powershelltips.com/powershell-sign-scripts/</a>

Aus dem Link in kurz, s. <a href="https://youtube.com">Video</a> bzw. in Textform folgend:

Starte eine Prowershell

<table>
<th colspan="2"  align= "left" >Powershell gestartet als</th>
<tr><td>normaler User<br/>Win+x | &#x229E;+x , Terminal  </td>
<td>darf localhost nutzen (kein Kontakt von ausserhalb des eigenen System)<br/><br/>Um rauszufinden was euer Useraccount ist:<br/><img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/PSWhoami.png" widht=120px height=150px/></td>
</tr>
<tr>
<td>als Administrator<br/>Win+x | &#x229E;+x , Terminal(Administrator) </td>
<td>UTF8 support in Windows Powershell<br/>To activate it:<br/><br/><code>
    Run intl.cpl &crarr; #(which opens the regional settings in Control Panel)<br/><br/>
    </code>
    Follow the instructions in the screenshot below.<br/>
<img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/YGaG1.png" widht=270px height=450px/><br/><a href="https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096">Stackoverflow</a><br/><br/>
wenn man von einem Tablet oder Handy auf diesen Webserver zugreifen moechte<br/>= v. extern via Webbrowser, muss dem Anwender, der die App starten will, dass horchen auf allen Interfaces erlaubt werden.<br/>s. whoami normaler User<br/><br/>

<blockquote>netsh http add urlacl url=http://+:5000/ user=its\bb listen=yes<br/>
netsh http add urlacl url=http://+:5001/ user=its\bb listen=yes<br/>
netsh http add urlacl url=http://+:5002/ user=its\bb listen=yes<br/>
<br/>
</blockquote>

##### Windows Firewall

```
New-NetFirewallRule -DisplayName "CSSLogViewer" -Direction Inbound -Protocol TCP -LocalPort 5000 -Action Allow
New-NetFirewallRule -DisplayName "CSSLogViewer_DMReport" -Direction Inbound -Protocol TCP -LocalPort 5001 -Action Allow
New-NetFirewallRule -DisplayName "CSSLogViewer_Chat" -Direction Inbound -Protocol TCP -LocalPort 5002 -Action Allow

```
<img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/CSSClientLogViewer_WFirewall.png" widht=120px height=150px/>
<br/>

Eventuelle Freigabe in einer Fritzbox in Abhängigkeit zur Version oder anderer Router etc. können hier nicht abgebildet werden.
</td>
</tr></table>

### als normaler User:
wechselt in der Powershell, in das Verzeichnis wo das Script liegt / wo ihr die Zipfile entpackt habt. (Adressezeile vom Dateiexplorer..)
Setzt den Pfad aus dem Dateiexplorer anstatt folgendem Pfad (cd = change directory)

<blockquote>
cd "Pfad"
&crarr;
</blockquote>
(cd = change directory)
<br/><br/>
copy & paste nachfolgende Statements in die geoeffnete Powershell 

#### 1. Erstellen eines "self signed certificate"
Create self-signed code signing certificate (requires admin for LocalMachine store)<br/>
```
$cert = New-SelfSignedCertificate `
-Subject 'CN=PowerShell Dev Signing' `
-CertStoreLocation Cert:\CurrentUser\My `
-KeyUsage DigitalSignature `
-Type CodeSigningCert `
-NotAfter (Get-Date).AddYears(2)

Write-Host "Created certificate: $($cert.Thumbprint)"

# For the cert to be trusted locally during testing, add to Trusted Publishers
$rootStore = New-Object System.Security.Cryptography.X509Certificates.X509Store('Root','CurrentUser')
$rootStore.Open('ReadWrite')
$rootStore.Add($cert)
$rootStore.Close()

```


#### 2. Signieren aller Powershellfiles

```
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Select-Object -First 1
$files2sign=".\WSSrv.psm1",".\LiteWebServer.psm1",".\CSSConsoleFilter.ps1"
foreach ($file2sign in $files2sign) { Set-AuthenticodeSignature -FilePath $file2Sign -Certificate $cert -TimestampServer 'http://timestamp.digicert.com' }

```

&#42;&#42; bei jeder Änderung die man macht, signieren aller geaenderten Powershellfiles wiederholen.

#### 3. Powershell Executionpolicy
<a href="https://learn.microsoft.com/de-de/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.6">https://learn.microsoft.com/de-de/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.6</a>
<a href="https://serverspace.io/support/help/about-execution-policies-powershell/">https://serverspace.io/support/help/about-execution-policies-powershell/</a>
&#42; Als der Anwender der das Script starten wird.

``` Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope CurrentUser```




Damit sollte das Script per Doppelklick gestartet werden und mit dem Browser eine Verbindung via

<table>
<tr><td>local: </td><td>http://localhost:5000/</td><td></td></tr>
<tr><td>remote:</td><td>http://YourIP:5000<br/>http://YourComputername:5000</td><td>s. oben netsh<br/>&#42; Windows Firewall, die Ports müssen freigegeben sein</td></tr>
</table>

 hergestellt werden können.

<hr/>

<img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/createdBy.png" />
 