<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Index</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet"
	href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css"
	integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p"
	crossorigin="anonymous" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<style>

   
</style>
</head>
<body>

<%@include file="../layout/header.jsp" %>

<div class="container">
<section class="">
<div id="ala"></div>
<button id="btnSend">asdf</button>
${binfo.id }
     </section>
    </div>

	<%-- <div class="container p-2 shadow bg-white rounded">
	
	</div> --%>
	
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="/resources/js/header.js"></script>
<script>
$(function(){
	$.ajax({
		
	url:"/noti/alarmCounts",
	 data:{userId:'${binfo.name}'}

	}).done(function(resp){
		console.log(resp)
		$("#ala").append(resp)
	})
})
$("#btnSend").on('click',function(){
	let bno = 1
	let sender = '${binfo.name}'
	let getter = "스티브"
	
	
	let data ={userId:getter,content:sender+" 님이 좋아요를 눌렀습니다."}
	$.ajax({
		url:"/noti/alarm",
		type:"post",
		data:JSON.stringify(data),
		contentType:"application/json;charset=utf-8"
		
	}).done(function(resp){
		console.log(resp)
		if(socket){
			let scktMsg = "like,"+sender+","+getter+","+bno+","+"1";
			console.log(scktMsg);
			socket.send(scktMsg);
		}
	})
})

$('#btnSend2').on('click', function(evt) {
 	  evt.preventDefault();
  if (socket.readyState !== 1) return;
    	  let msg = "like";
    	  ws.send(msg);
    });
</script>
 <script>
 let socket = null;  //전역변수 어디서든 메시지 써야 되기 때문에
 $(document).ready(function(){
 	connectWS();
 })

 function connectWS(){
 	var ws = new WebSocket("ws://192.168.219.110:8080/replyEcho");
 	socket = ws;
 	ws.onopen = function () { //커넥션 연결되었을떄
 	    console.log('Info: connection opened.');
 	   
 }
     ws.onmessage = function (event) {
    	 console.log(event)
         console.log("받은 메시지: "+ event.data+'\n');
    	 let getMsg = event.data.split(",")
    	 let toMsg = getMsg[0];
    	 let toAla = getMsg[1]
         toastr.success("알림", toMsg);
    	
    		
    		 let gs = $("#ala").text();
    		let total = parseInt(gs)
    		
    		  $("#ala").text(total+1)
    	
        
     };
     
     ws.onclose = function (event) { 
     	console.log('Info: connection closed.');
     	//setTimeout( function(){ connect(); }, 1000); // retry connection!!
     	};
     ws.onerror = function (error) { console.log('Info: connection error.'); };
   
 };
 

  
 </script>
</body>
</html>