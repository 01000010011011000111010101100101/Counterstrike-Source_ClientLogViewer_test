## Lightweight PowerShell WebSocket Server
# Send Messages to Website
# Helper for awaiting async tasks on powershell
# see https://blog.ironmansoftware.com/powershell-async-method/#:~:text=PowerShell%20does%20not%20provide%20an,when%20calling%20async%20methods%20in%20.
function Wait-Task {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Threading.Tasks.Task[]]$Task
    )
    Begin {
        $Tasks = @()
    }
    Process {
        $Tasks += $Task
    }
    End {
        While (-not [System.Threading.Tasks.Task]::WaitAll($Tasks, 200)) {}
        $Tasks.ForEach( { $_.GetAwaiter().GetResult() })
    }
}
Set-Alias -Name await -Value Wait-Task -Force

class SimpleWSS {
    hidden [string]$Prefix 
     [System.Net.HttpListener]$listener 
    hidden [System.Collections.Generic.List[System.Net.HttpListenerContext]]$context
    hidden  [System.Net.WebSockets.WebSocket]$webSocket
    hidden [int]$listenerStopEvent = 0
    hidden [int]$debug             = 0

    hidden init(){
        ##$this.Prefix= = "http://+:8081/",  # listen on any interface (matching netsh or running on admin console required)
        #$this.Prefix = "http://localhost:8081/"  # URL prefix        
        #$this.listener = [System.Net.HttpListener]::new()
    }
  

    SimpleWSS (){
        $this.init()
        Write-host "wrong intialized SimpleWSS"
        
    }
 
    SimpleWSS ([string]$URL){
        $this.Prefix = $URL # URL prefix
        $this.listener = [System.Net.HttpListener]::new()
        # Create and start the HTTP listener
        #$listener = New-Object System.Net.HttpListener
        $this.listener.Prefixes.Add($this.Prefix)
        try {
            $this.listener.Start()
            Write-Host "WebSocket running at $URL"
        } catch {
            Write-Error "Failed to start listener. Try running PowerShell as Administrator."
            exit
        }
    }

    [void] switchDebug(){
        if($this.debug -eq 1){
            $this.debug =0
        }else{
             $this.debug =1
        }
    }

    [int] debugStatus(){
        return $this.debug
    }

    [System.Net.WebSockets.WebSocket] getWebSocket(){
        return $this.webSocket
    }
    [void] setWebSocket([System.Net.WebSockets.WebSocket] $s){
        $this.webSocket=$s
    }    

    [System.Net.WebSockets.WebSocket] run(){
        if( $this.listener -ne $null){
 #           while($this.listener.IsListening -and $listenerStopEvent -eq 0){}
                
                $this.context =  await $this.listener.GetContextAsync()
#                $this.context =  $this.listener.GetContextAsync()                
                if ($this.context.Request.IsWebSocketRequest){
                    if($this.debug -eq 1){
                        write-host ("Received Websocket-Request on " + $this.listener.Prefixes )
                    }
                    $webSocketContext = await $this.context.AcceptWebSocketAsync(([NullString]::Value)) # # https://docs.microsoft.com/de-de/dotnet/api/system.net.httplistenercontext.acceptwebsocketasync?view=netframework-4.5
                    $this.webSocket = $webSocketContext.WebSocket;         
                }

  #              Start-Sleep -Seconds 5
  #          }
        }
        return  $this.webSocket
    }  

     [void] send([System.Net.WebSockets.WebSocket]$webSocket,[string]$s){
        if ($webSocket.State -eq [System.Net.WebSockets.WebSocketState]::Open -and !([console]::KeyAvailable))
        {
            $ct = New-Object Threading.CancellationToken($false)

            [ArraySegment[byte]]$msg = [Text.Encoding]::UTF8.GetBytes($s)
            try{
                $_ =  $webSocket.SendAsync(
                    $msg,
                    [System.Net.WebSockets.WebSocketMessageType]::Text, # Binary
                    $true,
                    $ct
                    );
            }catch{
                if($this.debug -eq 1){
                    write-host ("Client seems not active - restart Server, waiting for reconnect")
                }
                #$this.closeStream()
<#                
                $this.listener.Stop()
                $this.listener.Start()
                $this.run()
                #$this.send($this.webSocket,$s)
#>                
            }
         }else{
                if($this.debug -eq 1){
                    write-host ("Client seems not active - restart Server, waiting for reconnect")
                }
                #$this.closeStream()
<#                
                $this.listener.Stop()
                $this.listener.Start()
                $this.run()
                #$this.send($this.webSocket,$s)
#>                
            }
     }

    [void] send([string]$s){
        $this.send($this.webSocket,$s)
    }

    [void] start(){     
         $this.listener.Start()
    }
    [void] stop(){     
        $this.listener.Stop()
    }

    [void] closeStream(){
        $response = $this.context.Response
        if( $response -ne $null){
            $response.OutputStream.close()
            
        }        

    }
}
<#
### usage e.g. like
$s=""
$obj=([SimpleWSS]::new("http://localhost:5001/"))
$obj.run()
while(!$s.Contains(":exit:")){
    $s=Read-Host
    $obj.send($obj.webSocket,$s)
}
$obj.closeStream()
$obj.stop()
###
#>
