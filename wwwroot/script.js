  var output;
  var oddeven=1;

  function webSocketDReport(wsUriDReport) {
    websocket = new WebSocket(wsUriDReport);
    websocket.onopen = function (evt) { onOpenDReport(evt) };
    websocket.onclose = function (evt) { onCloseDReport(evt) };
    websocket.onmessage = function (evt) { onMessageDReport(evt) };
    websocket.onerror = function (evt) { onErrorDReport(evt) };
  }
  
  function webSocketChat(wsUriChat) {
    websocket = new WebSocket(wsUriChat);
    websocket.onopen = function (evt) { onOpenChat(evt) };
    websocket.onclose = function (evt) { onCloseChat(evt) };
    websocket.onmessage = function (evt) { onMessageChat(evt) };
    websocket.onerror = function (evt) { onErrorChat(evt) };
  }  

<!-- ############################################################ -->
<!-- DReport -->
  function onOpenDReport(evt) {
    addDamageRMessageDisconnned("CONNECTED");
  };

  function onCloseDReport(evt) {
	addDamageRMessageDisconnned("Damage Report DISCONNECTED - Try to reconnect.");
  };

  function onMessageDReport(evt) {
    <!--writeToScreen('<span style="color: blue;">Received: ' + evt.data + '</span>');-->
		addDamageRMessage(evt.data);
  };

  function onErrorDReport(evt) {
    writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
  };

  function doSendDReport(message) {
    writeToScreen("SENT: " + message);
    websocket.send(message);
  };

function addDamageRMessageDisconnned(t){
		
		var p = document.createElement("p");
		var output = document.getElementById('damageM');
		p.appendChild(document.createTextNode(t+"\n"));
			
		output.appendChild(p);

		
		output.scrollTo(0, output.scrollHeight);

};


function addDamageRMessage(t){
		
		var p = document.createElement("p");
		var output = document.getElementById('damageM');
		
		if(t.includes("<EndRound>")){		
			output.appendChild(document.createElement('hr'));	
		}else{
			p.style.color="white";
			
			if(t.includes("<IWasKilled>")){	
				
				m=t.replace("<IWasKilled>","");
				p.style.color="red";
				p.style.paddingRight ="40vw";
			}
			if(t.includes("<IKilled>")){	
				m=t.replace("<IKilled>","");
				p.style.color="#2CFF05";
				p.style.paddingLeft="40vw";
			}		
			
			if(t.includes("<DTaken>")){
				m=t.replace("<DTaken>","");
				p.style.color="white";	
				p.style.paddingRight ="40vw";
			}
			if(t.includes("<DGiven>")){		
				m=t.replace("<DGiven>","");
				p.style.color="white";	
				p.style.paddingLeft ="40vw";
			}

			p.appendChild(document.createTextNode(m+"\n"));
			
			output.appendChild(p);
		}

		
		output.scrollTo(0, output.scrollHeight);

};
<!-- ############################################################ -->
<!-- Chat -->
 function onOpenChat(evt) {
    addChatAdminMessage("CONNECTED.");
  };

  function onCloseChat(evt) {
   addChatAdminMessage("DISCONNECTED - Try to reconnect.");
  };

  function onMessageChat(evt) {	
	if(evt.data.includes(" ADMIN:")){
		addChatAdminMessage(evt.data);
	}else if(evt.data.includes("nimmt teil")){ 
    addJoinedMessage(evt.data)
  }else if(oddeven % 2 == 1)
		addChatOddMessage(evt.data);
	else
		addChatEvenMessage(evt.data);
	oddeven=oddeven+1;
  };

  function onErrorChat(evt) {
    writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
  };

  function doSendChat(message) {
    websocket.send(message);
  };


function addChatAdminMessage(t){
	
  var p = document.createElement("p");
	p.style.color="yellow";
  var output = document.getElementById('chatM');
  p.appendChild(document.createTextNode(t+"\n"));
	output.appendChild(document.createElement('hr'));
  output.appendChild(p);
	output.appendChild(document.createElement('hr'));
	output.scrollTo(0, output.scrollHeight);
	
};
function addJoinedMessage(t){
	
  var p = document.createElement("p");
	p.style.color="yellow";
  var output = document.getElementById('joinM');
  p.appendChild(document.createTextNode(t+"\n"));
	output.appendChild(p);
	output.scrollTo(0, output.scrollHeight);
	
};
function addChatEvenMessage(t){
	
    var p = document.createElement("p");
	p.style.color="white";
    var output = document.getElementById('chatM');
    p.appendChild(document.createTextNode(t+"\n"));
    output.appendChild(p);
	output.scrollTo(0, output.scrollHeight);
	
};
function addChatOddMessage(t){
	
    var p = document.createElement("p");
	p.style.color="cyan";
    var output = document.getElementById('chatM');
    p.appendChild(document.createTextNode(t+"\n"));
    output.appendChild(p);
	output.scrollTo(0, output.scrollHeight);
	
};
<!-- ############################################################ -->
function setTime(){
var d = new Date();
var n = d.toLocaleTimeString();
var oTimer = document.getElementById('displayTimer');
      oTimer.innerHTML = n;
}
<!-- ############################################################ -->