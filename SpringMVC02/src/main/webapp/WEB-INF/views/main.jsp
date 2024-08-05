<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>     
  
<!DOCTYPE html>
<html lang="en">
	<head>
	  <title>Spring MVC02dd</title>
	  <meta charset="utf-8">
	  <meta name="viewport" content="width=device-width, initial-scale=1">
	  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	  <script type="text/javascript">
	  	$(document).ready(function(){
	  		loadList();
	  	});
	  	function loadList(){
	  		//서버와 통신 : 게시판 리스트 가져오기
	  		$.ajax({
	  			url : "boardList.do",
	  			type : "get",
	  			dataType : "json",
	  			success : makeView,
	  			error : function(){alert("error!!")} 
	  		});
	  	}
	  	
	  	
	  	//boardList.do 요청받은 컨트롤러가 반환한 List<Board>타입인 list를 makeView가 받는다.
	  	function makeView(data){
	  		var listHtml ="<table class='table table-bordered'>"
	  		listHtml +="<tr>";
	  		listHtml +="<td>번호</td>";
  			listHtml +="<td>제목</td>";
			listHtml +="<td>작성자</td>";
  			listHtml +="<td>작성일</td>";
 			listHtml +="<td>조회수</td>";
 			listHtml +="</tr>";
 			$.each(data,function(index,obj){
			listHtml +="<tr>";
	  		listHtml +="<td>"+obj.idx+"</td>";
  			listHtml +="<td id='t"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</a></td>";
			listHtml +="<td>"+obj.writer+"</td>";
  			listHtml +="<td>"+obj.indate.split(' ')[0]+"</td>";
 			listHtml +="<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
 			listHtml +="</tr>";
 			
 			listHtml +="<tr id='c"+obj.idx+"' style='display : none'>";
 			listHtml +="<td>내용</td>";
 			listHtml +="<td colspan='4'>";
			listHtml +="<textarea id='txtArea"+obj.idx+"' readonly rows='7' class='form-control'></textarea>";
			listHtml +="<br/>";
			listHtml +="<span id='updatedBtn"+obj.idx+"'><button class='btn btn-primary btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정</button></span>&nbsp";
			listHtml +="<button class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";
			listHtml +="</td>";
 			listHtml +="</tr>";
 			
 			});
 			
 			listHtml +="<tr>"
			listHtml +="<td colspan='5'>"
 			listHtml +="<button class='btn btn-primary btn-sm' onclick='goForm()'>글쓰기</button>"
 			listHtml +="</td>"
 			listHtml +="</tr>"
  			listHtml += "</table>";
  			
  			$("#view").html(listHtml);
  			goList();
	  	}
	  	function goForm(){
	  		$("#view").css("display", "none");
	  		$("#writeform").css("display", "block");
	  	}
	  	function goList(){
	  		$("#view").css("display", "block");
	  		$("#writeform").css("display", "none");
	  	}
	  	function goInsert(){
	 /*  		
	 		var title = $("#title").val();
  			var content = $("#content").val();
  			var writer = $("#writer").val(); */
  			
	  		var formData = $("#form").serialize();
  			$.ajax({
  				url : "boardInsert.do",
  				type : "post", 
  				data : formData,
  				success : loadList,
  				error : function(){alert("error")}
  			});
	  	
  			//ajax로 데이터를 보내고나서 써져있는 폼데이터 초기화.
	  			//$("#title").val("");
	  			//$("#content").val("");
	  			//$("#writer").val(""); 
  			
  			$("#clear").trigger("click");
	  	}
	  	function goContent(idx){
	  		
	  		if($("#c"+idx).css("display")=="none"){
	  			
	  			$.ajax({
	  				url :"boardContent.do",
	  				type : "get",
	  				data : {"idx" :idx},
	  				dataType : "json",
	  				success: function(data){ //boardContent의 결과인 Board 객체를 json형식으로 넘겨줌.
	  					$("#txtArea"+idx).val(data.content)
	  				},
	  				error : function (){alert("Error!")}
	  			})
	  			
	  			$.ajax({
	  				url : "boardCount.do",
	  				type : "get",
	  				data : {"idx" : idx},
	  				dataType : "json",
	  				success : function(data){
	  					$("#cnt"+idx).text(data.count)
	  				}
	  			})
	  			
		  		$("#c"+idx).css("display", "table-row") //보이게
		  		$("#txtArea"+idx).attr("readonly", true)
	  		}else{
	  			$("#c"+idx).css("display", "none") //안보이게
	  		}
	  	}
	  	function goDelete(idx){
	  		$.ajax({
	  			url : "boardDelete.do",
	  			type : "get",
	  			data : {"idx" : idx},
	  			success : loadList,
	  			error : function(){alert("error")}
	  		})
	  	}
	  	function goUpdateForm(idx){
	  		$("#txtArea"+idx).attr("readonly", false);
	  		
	  		var title = $("#t"+idx).text();
	  		var newInput = "<input id='nt"+idx+"' type='text' class='form-control' value='"+title+"' />"
	  		$("#t"+idx).html(newInput);
	  		
	  	
	  		var newButton = "<button class='btn btn-success btn-sm' onclick='goUpdate("+idx+")'>완료</button>"
	  		$("#updatedBtn"+idx).html(newButton)
	  	}
	  	function goUpdate(idx){
	  		var title = $("#nt"+idx).val();
	  		var content = $("#txtArea"+idx).val();
	  		
	  		$.ajax({
	  			url : "boardUpdate.do",
	  			type : "post",
	  			data : {"idx":idx, "title":title, "content":content },
	  			success : loadList,
	  			error : function(){alert("Error")}
	  				
	  		})
	  	}
	
	  </script>
	</head>
	<body>
	 
	<div class="container">
	  <h2>Spring MVC02</h2>
	  <div class="panel panel-default">
	    <div class="panel-heading">BOARD</div>
	    <div class="panel-body" id="view">Panel Content</div>
	    
   	    <div class="panel-body" id="writeform" style="display :none">
		 <form id="form">
		  <table class="table table-bordered table-hover">
         	<tr>		        
              <td>제목</td>
              <td><input type="text" id="title" name ="title" class ="form-control" /></td>
		    </tr>	
		    <tr>		        
              <td>내용</td>
              <td><textarea rows="7" id="content" name ="content" class ="form-control"></textarea></td>
		    </tr> 
		    <tr>		        
              <td>작성자</td>
              <td><input type="text" id="writer" name ="writer" class ="form-control" /></td>
		    </tr>
		    <tr>
		      <td colspan ="2" align ="center">
		      	<button type="button" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
		      	<button type = "reset"  id ="clear"class="btn btn-warning btn-sm" style="display : none" >취소</button>
		      	<button type = "button" class="btn btn-info btn-sm" onclick="goList()">목록으로</button>

		      </td>
		    </tr>
		          
	      </table> 
	     </form>   
		</div>
		
	    <div class="panel-footer">made in korea</div>
	  </div>
	</div>
	
	</body>
</html>
