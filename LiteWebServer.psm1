## Lightweight PowerShell Web Server
# Serves static HTML/CSS/JS files from a folder
class LiteWebServer {
    hidden [string]$Prefix 
    hidden [string]$WebRoot
    hidden [System.Net.HttpListener]$listener 

    hidden init(){
        ##$this.Prefix= = "http://+:8081/",  # listen on ony interface (matching netsh or running on admin console required)
        #$this.Prefix = "http://localhost:8081/"  # URL prefix
        #$this.WebRoot = ".\wwwroot\"               # Folder with website files
        #$this.listener = [System.Net.HttpListener]::new()
    }
  

    LiteWebServer (){
        $this.init()
        Write-host "wrong intialized LiteWebServer"
        
    }
 
    LiteWebServer ([string]$URL,[string]$WebRoot){
        $this.Prefix = $URL # URL prefix
        $this.WebRoot = $WebRoot               # Folder with website files
        $this.listener = [System.Net.HttpListener]::new()

        # Create and start the HTTP listener
        #$listener = New-Object System.Net.HttpListener
        $this.listener.Prefixes.Add($this.Prefix)
        try {
            $this.listener.Start()
            Write-Host "Web server running at $URL"
            Write-Host "Serving files from: $WebRoot"
        } catch {
            Write-Error "Failed to start listener. Try running PowerShell as Administrator."
            exit
        }
    }

    
 
   # Function to get MIME type based on file extension
    static [void] GetMimeType([string]$filePath) {
        switch ([IO.Path]::GetExtension($filePath).ToLower()) {
            ".html" { "text/html" }
            ".htm"  { "text/html" }
            ".css"  { "text/css" }
            ".js"   { "application/javascript" }
            ".json" { "application/json" }
            ".png"  { "image/png" }
            ".jpg"  { "image/jpeg" }
            ".jpeg" { "image/jpeg" }
            ".gif"  { "image/gif" }
            default { "application/octet-stream" }
        }
    }   

    [void] run(){
        if( $this.listener -ne $null){
            # Main loop
            #Start-Process "http://${env:COMPUTERNAME}:8081/"
            [console]::TreatControlCAsInput = $true
            Write-host "Press any key to Stop (requires client to be connected, yet)"

            while (!([console]::KeyAvailable)) {
                try {
                        #$context = $this.listener.GetContextAsync() 
                        $context = $this.listener.GetContext()
                        #if ($context.Request.IsWebSocketRequest){
                        
                            $request = $context.Request
                            #write-host $request
                            $response = $context.Response

                            # Map URL to file path
                            $localPath = $request.Url.LocalPath.TrimStart("/")
                            if ([string]::IsNullOrWhiteSpace($localPath)) { $localPath = "index.html" }
                            $filePath = Join-Path $this.WebRoot $localPath

                            if (Test-Path $filePath) {
                                $bytes = [System.IO.File]::ReadAllBytes($filePath)
                                $response.ContentType = [LiteWebServer]::GetMimeType($filePath)
                                $response.ContentLength64 = $bytes.Length
                                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                            } else {
                                $response.StatusCode = 404
                                $errorMsg = "404 - File Not Found"
                                $bytes = [System.Text.Encoding]::UTF8.GetBytes($errorMsg)
                                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                            }

                            $response.OutputStream.Close()
                    # }
                } catch {
                    Write-Warning "Error handling request: $_"
                }
                
            }

            # Cleanup on exit
            $this.listener.Stop()
            $this.listener.Close()
        }
    }  
}
<#
### usage e.g. like
([LiteWebServer]::new("http://localhost:8081/",".\wwwroot\")).run()
###
#>
#([LiteWebServer]::new("http://localhost:5000/",".\wwwroot\")).run()
