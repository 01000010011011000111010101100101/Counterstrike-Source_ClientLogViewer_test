# **Counterstrike-Source_ClientLogViewer**
Für mich war es unangenehm .. läßtig, staendig in der Console durch ~100 Zeilen zu gehen, um nachzulesen was jemand in den Chat geschrieben hat oder um zu sehen ob ich den Gegner ueberhaupt getroffen habe. Deshalb habe ich die App gebaut, mit der ich auf einem zweiten Monitor via WebBrowser auf einen Blick sehe was mich interessiert.
<ul>
<li>Wer mich getroffen(Weiß), gekillt hat(Rot)</li>
<li>Wen ich getroffen(Weiß), gekillt habe(Grün)</li>
<li>Wer den Server betritt .. ich sage gern Moin moin.(Gelb 60% Deckkraft)</li>
<li>Admin Nachrichten(Gelb zwischen Trennlinien) &#x26; Spielerchat(Weiß,Türkis im Wechsel) sehen und nochmal leichter nachlesen, z.B wenn man auf die nächste Runde wartet</li>
<li>Uhrzeit, so sieht man wann die Chatmessage kam -und man brauch das Fenster nicht wechseln um zu sehen ob es Bedtime ist. &#x1F601;</li>
</ul>

<iframe width="560" height="315" src="https://www.youtube.com/embed/-cD0blu-LZ8?si=GIm5QC8_lPampOQ-" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## s. <a href="https://youtube.com">Video</a> 

&#42;Die App ist für Deutsch CSS. Hat man andere Sprache, muss im Code die Abfragen/Filter entsprechend angepasst werden.
<hr/>
<hr/>
Aktivieren der Console &#x26; Connection debug, bei start von CSS
<ul>
<li>Steam</li>
<li>Bibliothek</li>
<li>CSS rechte Maus-->Eigenschaften</li>
<li>Menue "Allgemein" &commat;Startoptionen <code>-console -condebug</code>hinzufuegen</li>
</ul>
<img src="https://github.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/blob/main/doc/img/css_enable_console_condebug.png?raw=true"/>
<img src="https://github.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/blob/main/doc/img/css_enabled_logfile.png?raw=true"/>



## File Details (zip)
|File|Comment|
|----|-------|
|".\WSSrv.psm1"| WebSocketServer, damit mit einem Webbrowser via Socket Daten ausgetauscht werden kann|
|".\LiteWebServer.psm1"| leichter Webserver der Seiten und Javascript von wwwroot s. unten bereitstellt
|".\CSSConsoleFilter.ps1"|dieses Script ist die App selbst, vom Endanwender zu starten.<br/>Logfilter ist fuer die Deutsche Steamversion entwickelt, fuer andere Sprachen muss Anpassungen im Code gemacht werden.
|"wwwroot"| Verzeichnis welches die Webseiten und Code fuer LiteWebServer enthaellt |
|| <table border=0><tr><td><ul><li> index.html></td><td><img src="https://raw.githubusercontent.com/01000010011011000111010101100101/Counterstrike-Source_ClientLogViewer/refs/heads/main/doc/img/CSSClientLogViewer_index_01.png" widht=150px height=250px/> </li></ul></td></tr><tr><td><ul><li> DReport.html </li><li>Chat.html</li><li>script.js</li></ul></td><tr></table>|

## Variablen, anzupassen an eigene Umgebung

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


&#x24;global:webSrv           = "http://localhost:5000/" #"http://+:5000/",  # listen on any interface (matching netsh or running on admin console required)<br/>

&#x24;global:webSocketDReport = "http://localhost:5001/" #"http://+:5001/",  # listen on any interface (matching netsh or running on admin console required)<br/>
&#x24;global:webSocketChat    = "http://localhost:5002/" #"http://+:5002/",  # listen on any interface (matching netsh or running on admin console required)<br/>

<&#35; 
Will man von externen Geraeten(Tablet) auf den laufenden Webserver zugreifen (http://+:500x/) muss in der Windowsfirewall die Ports freigeben sein 
und das Script in einer "als Administrator gestarteten Powershell" gestartet werden
&#35;>

############################################################################################################
</p></td>
</tr>
</table>
<br/>

## Installation
### Windows Security Policy: Um dieses PS-Script laufen zu lassen, muss es mit einem Zertifikat signiert werden.

Ausfuehrliche Information, wie man ein "self signed certificat" erstellt und sein Script signiert
<a href="https://www.powershelltips.com/powershell-sign-scripts/">https://www.powershelltips.com/powershell-sign-scripts/</a>

Aus dem Link in kurz, s. <a href="https://youtube.com">Video</a> bzw. in Textform folgend:

Starte eine Prowershell

<table>
<th colspan="2"  align= "left" >Powershell gestartet als</th>
<tr><td>normaler User<br/>Win+x | &#x229E;+x , Terminal  &crarr;</td>
<td>darf localhost nutzen (kein Kontakt von ausserhalb des eigenen System)</td>
</tr>
<tr>
<td>als Administrator<br/>Win+x | &#x229E;+x , Terminal(Administrator)  &crarr;</td>
<td>wenn man von einem Tablet oder Handy auf diesen Webserver zugreifen moechte<br/>Wenn extern(tablet) via Webbrowser muss das Script jedesmal als Admin gestartet werden.
</td>
</tr></table>


wechselt in der Powershell, in das Verzeichnis wo das Script liegt. (Adressezeile vom Dateiexplorer..)
\*setzt den Pfad aus dem Dateiexplorer anstatt folgendem Pfad (cd = change directory)
cd "Pfad"
enter



### 1. Erstellen eines "self signed certificate"
copy & paste nachfolgendes Statement in die geoeffnete Powershell 


```
$cert = New-SelfSignedCertificate `
-Subject 'CN=PowerShell Dev Signing' ` 
-CertStoreLocation Cert:\CurrentUser\My ` 
-KeyUsage DigitalSignature `
-Type CodeSigningCert `
-NotAfter (Get-Date).AddYears(2) `
Write-Host "Created certificate: $($cert.Thumbprint)"  # For the cert to be trusted locally during testing, add to Trusted Publishers `
$rootStore = New-Object [System.Security](http://System.Security).Cryptography.X509Certificates.X509Store('Root','CurrentUser') `
$[rootStore.Open](http://rootStore.Open)('ReadWrite') `
$rootStore.Add($cert) `
$rootStore.Close() 
```


### 2. Signieren aller Powershellfiles

```
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert | Select-Object -First 1
$files2sign=".\WSSrv.psm1",".\LiteWebServer.psm1",".\CSSConsoleFilter.ps1"
foreach ($file2sign in $files2sign) { Set-AuthenticodeSignature -FilePath $file2Sign -Certificate $cert -TimestampServer 'http://timestamp.digicert.com' }
```

** bei jeder Aenderung die man macht, signieren aller geaenderten Powershellfiles.
