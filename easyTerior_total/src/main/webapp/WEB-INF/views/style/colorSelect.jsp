<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%-- JSTL --%>
<%@ page import="java.util.*" %>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<%
    String contextPath = (String) pageContext.getAttribute("contextPath");  // contextPath 가져오기
    String imagePath = (String) session.getAttribute("imgPath");  // session에서 이미지 경로 가져오기

    // 파일명 추출
    String filename = imagePath.substring(imagePath.lastIndexOf("/") + 1);  // 파일명 추출

%>
<%-- EL을 사용하여 변수 출력 <p>객체 탐지 결과: /$/{detectionResult/}</p> --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"><!-- icons -->
<link href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css"
rel="stylesheet" /><!-- icons -->
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<style>
@font-face {
    font-family: 'SUITE-Regular';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-Regular.woff2') format('woff2');
    font-weight: 400;
    font-style: normal;
}
body, main, section {
position: relative;
font-family:'SUITE-Regular';
}
.objBtn.active {
background-color: #0d6efd;
border-color: #fff;
}
</style>
<script type="text/javascript">
	//RGB값 추출
	function extractRGB(hexValue) {	    
	    // HEX 값을 R, G, B로 변환
	    var r = parseInt(hexValue.slice(1, 3), 16);
	    var g = parseInt(hexValue.slice(3, 5), 16);
	    var b = parseInt(hexValue.slice(5, 7), 16);
	    
	    // 추출한 R, G, B 값을 출력
	    console.log("R: " + r);
	    console.log("G: " + g);
	    console.log("B: " + b);
	    $("#selectedColorValue").val("{\"R\":"+r+",\"G\":"+g+",\"B\":"+b+"}");
	    return "{\"R\":"+r+",\"G\":"+g+",\"B\":"+b+"}";
	}
	
	// 사용자가 선택한 색깔 저장 modal 안내
	function updateSelectedColor() {
        var colorHex = document.getElementById("colorValue").value;
        var colorRGB = extractRGB(colorHex);
        // document.getElementById("selectedColorValue").value = selectedColor;
        $(".modal-title").text("성공 메세지");
        $("#checkMessage").text("선택하신 색깔 값은 "+colorHex+" 이며 "+colorRGB+" 입니다. 색깔 저장에 성공하였습니다!");
        $("#myModal").modal("show");
    }
	
	// 선택된 버튼 객체 업데이트 함수
	var selectedObjects = [];
	function updateSelectedObjects(button) {
		console.log("button.value : "+button.value);
		// 선택된 객체 목록을 저장하는 배열
		var value = button.value;
		// 버튼이 active 상태인 경우
		if ($(button).hasClass("active")) {
	    	// 선택된 객체 목록에 추가
	    	selectedObjects.push(value);
    	} else {
		    // 버튼이 active 상태가 아닌 경우
		    // 선택된 객체 목록에서 제거
		    var index = selectedObjects.indexOf(value);
		    if (index > -1) { 
		    	selectedObjects.splice(index, 1); 
		    }
	    }
		// 선택된 객체 목록을 input hidden 필드에 설정
		$("#selectedObjectList").val(selectedObjects); 
  	  	// $("#selectedObjectList").val(selectedObjects.join(",")); // val("["+selectedObjects.join(",")+"]"); // error 404 : Required List parameter 'selectedObjectList' is not present
  	  	console.log("button.value : "+value+" | active : "+$(button).hasClass("active"));
  	  	console.log("selectedObjectList  value :", $("#selectedObjectList").val());
  	 	console.log("selectedObjectList 데이터 타입:", typeof $("#selectedObjectList").val());
	  	// 데이터 타입 출력
	  	//console.log("selectedObjectList 데이터 타입:", typeof $("#selectedObjectList").val()); // String 
    }
	
	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "성공 메세지"}){ // MemberController.java에서 rttr.addFlashAttribute("msgType", "성공 메세지");로 보냄
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
			}
			$("#myModal").modal("show");
		}
		
		// 폼 제출 시 이벤트 처리 - 색깔 저장 혹은 객체 선택 안 한 경우
        function submitFormClick() {
            // 선택된 색상값 가져오기
            var selectedColor = $("#selectedColorvalue").val();
            var selectedObjects = $("#selectedObjectList").val();

            if (selectedColor === "") { // 선택된 색상값이 비어있는 경우
                // 주의 메시지 모달 표시
                $(".modal-title").text("주의 메세지");
                $("#checkMessage").text("색깔을 저장하지 않으셨습니다. 색깔을 선택 후 저장해주세요!");
                $("#myModal").modal("show");
                
                // 폼 제출 중단
                e.preventDefault();
            }
            if (selectedObjects.length === 0 || selectedObjects === "") { // 선택된 객체가 없는 경우,
                // 주의 메시지 모달 표시
                $(".modal-title").text("주의 메세지");
                $("#checkMessage").text("객체를 선택하지 않으셨습니다. 최소 한 개의 객체를 선택해주세요!");
                $("#myModal").modal("show");
                
                // 폼 제출 중단
                e.preventDefault();
            }
            
            //$("#selectedColorvalue").val(""+selectedColor+"");
            //$("#selectedObjectList").val("{"++"}");
        }

	});
</script>
<title>EasyTerior</title>
</head>
<body>
<main class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	<section class="fixed-top container-fluid overflow-auto h-100" style="margin:137px 0 56px 0;padding:0 0 56px 100px;">
		<h1 class="text-center mt-4 mb-5">소품 색 변경하기</h1>
		<!-- 실질 컨텐츠 위치 -->
		<div class="container-fluid" style="min-height:100vh;margin-bottom:200px;">
			<div class="row m-auto card-group" style="width:80%">
				<div class="card border-0" style="min-width:385px">
		            <div class="card-body">
		                <h5 class="card-title text-center fw-bold">객체 확인된 이미지</h5>
		            </div>
		            <img src="${pageContext.request.contextPath}/resources/images/flask/<%= filename %>" id="resultImage" class="card-img-bottom" name="resultImage" alt="resultImage" />
		        </div>
			    <div class="card border-0" style="min-width:385px">
		            <div class="card-body">
		                <div class="row mb-5">
	                		<h5 class="card-title text-center mb-4 fw-bold">발견된 객체</h5>
	                		<div id="resultList" class="col text-center">
							    <%-- <p>실질적으로 탐지된 결과: ${detectionResult}</p> detectionResult를 세션에서 가져옴 --%>
							    <% Map<String, String> objectList = (Map<String, String>) session.getAttribute("objectList"); %>
							    <% List<Integer> resultList = (List<Integer>) session.getAttribute("resultList"); %>
							    <%-- resultList(실질 검출, 중복 제외)가 null이 아닌 경우에만 처리 --%>
							    <% if (resultList != null) { %>
							        <%-- resultList를 순회하면서 각각의 객체에 대한 checkbox 또는 button을 생성 --%>
							        <% for (Integer result : resultList) { %>
							            <%-- result에 해당하는 객체명을 objectList에서 찾아옴 --%>
							            <% String objectName = objectList.get(String.valueOf(result)); %>			            
							            <%-- button인 경우 --%>
							            <button type="button" id="obj<%= result %>" name="obj<%= result %>" value="<%= result %>" class="objBtn btn btn-outline-primary" onclick="updateSelectedObjects(this)" role="button" data-bs-toggle="button" aria-pressed="true"><%= objectName %></button>
							        <% } %>
							    <% } %>
							</div>
	                	</div>
	                	<div class="row">
	                		<h5 class="card-title text-center mb-4 fw-bold">색상을 선택해주세요!<p class="text-danger" style="font-size:13px;">색깔 저장을 눌러야 원하시는 색으로 반영이 됩니다.</p></h5>
	                		<div id="colorSelect" class="col text-center">
								<input type="color" id="colorValue" name="colorValue" />
								
						        <button type="button" class="btn btn-secondary d-block mt-3 m-auto ps-2 fw-bold" onclick="updateSelectedColor()" style="width:100px">색깔 저장</button>
	                		</div>
	                	</div>
			        </div>
			    </div>
			</div>
			<div class="row text-center" style="padding-top:50px;">
			<!--  action="http://127.0.0.1:5000/process_image" -->
				<form action="${ contextPath }/colorSelectForm.do?${_csrf.parameterName}=${ _csrf.token }" method="POST" enctype="application/x-www-form-urlencoded; charset=UTF-8" id="colorSubmitForm" class="text-center">
					<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" />
					<input type="hidden" id="selectedColorValue" name="selectedColorValue" onchange="extractRGB()" required />
					<input type="hidden" id="selectedObjectList" name="selectedObjectList" required />
			        <button type="submit" onclick="submitFormClick()" class="btn btn-primary d-block m-auto ps-2 fw-bold">가구 색깔 바꾸기</button>
				</form>
			</div>
		</div>
	</section>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</main>

<!-- The Modal -->
<div class="modal fade" id="myModal"><!-- animation : fade -->
    <div class="modal-dialog">
        <div id="checkType" class="card modal-content">
            <!-- Modal Header -->
            <div class="modal-header card-header">
                <h4 class="modal-title text-center">${ msgType }</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <!-- Modal body -->
            <div class="modal-body">
                <p id="checkMessage" class="text-center">${ msg }</p>
            </div>
            <!-- Modal footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

</script>
</body>
</html>