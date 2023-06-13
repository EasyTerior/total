<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<%
    String contextPath = (String) pageContext.getAttribute("contextPath");  // contextPath 가져오기
    String imagePath = (String) session.getAttribute("final_img");  // session에서 이미지 경로 가져오기

    // 파일명 추출
    String filename = imagePath.substring(imagePath.lastIndexOf("/") + 1);  // 파일명 추출

%>
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
body, main, section {
position: relative;
}
</style>
<script type="text/javascript">
	// rgbToHex
	function rgbToHex(r, g, b) {
	  var red = r.toString(16).padStart(2, '0');
	  var green = g.toString(16).padStart(2, '0');
	  var blue = b.toString(16).padStart(2, '0');
	  return '#' + red + green + blue;
	}
	
	// 로그인 여부 체크
	function chkLoginUser(){
		// memID 값 확인
        var memID = $("#memID").val();
     // memID 값이 비어있는 경우 로그인이 되어있지 않으므로 로그인 창으로 이동하도록 안내
        if (memID === "") {
        	$(".modal-title").text("실패 메세지");
        	$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-danger");
        	$("#checkMessage").text("로그인이 되어있지 않아 사진을 저장할 수 없습니다. 로그인 한 사용자만이 사진을 저장할 수 있습니다!");
        	$("#myModal").modal("show");
        	event.preventDefault(); // form 제출 막기
        }else{
        	$(".modal-title").text("성공 메세지");
        	$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
        	$("#checkMessage").text("성공적으로 사진을 저장했습니다.");
        	$("#myModal").modal("show");
        	$("#saveColorResult").submit(); // form 제출
        }
	}

	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "성공 메세지"}){ // MemberController.java에서 rttr.addFlashAttribute("msgType", "성공 메세지");로 보냄
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
			}
			$("#myModal").modal("show");
		}
		bgr_color = JSON.parse("${img_data}");
		console.log("bgr_color : "+bgr_color+" | type : "+typeof(bgr_color)+" bgr_color[0] : "+bgr_color[0]+" | type : "+typeof(bgr_color[0]));
		// 각 값을 숫자로 변환하여 b, g, r 변수에 저장
		let b = parseInt(bgr_color[0]);
		let g = parseInt(bgr_color[1]);
		let r = parseInt(bgr_color[2]);
		
		$(".rgb_r").text(r);
		$(".rgb_g").text(g);
		$(".rgb_b").text(b);
		console.log("img_data : "+${img_data}+ " | type : "+typeof(${img_data}));
		console.log("r: "+r+" | g : "+g+" | b : "+b+" | type b : "+typeof(b)+" | type g : "+typeof(g)+" | type r : "+typeof(r));
		
		$(".hex_value").text(rgbToHex(r, g, b));
		$("#hexVal").val(rgbToHex(r, g, b));
	});
</script>
<title>EasyTerior</title>
</head>
<body>
<main class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	<section class="fixed-top container-fluid overflow-auto h-100" style="margin:137px 0 56px 0;padding:0 0 56px 100px;">
		<h1 class="text-center mt-4 mb-3">소품 색 변경 결과</h1>
		<!-- 실질 컨텐츠 위치 -->
		<div class="container-fluid" style="min-height:100vh;margin-bottom:200px;">
			<div class="row m-auto" style="width:80%">
			    <div class="col-sm-6 m-auto" style="min-width:385px">
			        <div class="card border-0">
			            <div class="card-body">
			                <h5 class="card-title text-center fw-bold">결과 이미지</h5>
			            </div>
			            <img src="${pageContext.request.contextPath}/resources/images/flask/<%= filename %>" id="resultImage" class="card-img-bottom" name="resultImage" alt="resultImage" />
			        </div>
			    </div>
			    <div class="col-sm-6 m-auto" style="min-width:385px">
			        <div class="card border-0">
			            <div class="card-body">
			                <h5 class="card-title text-center mb-4 fw-bold">선택하신 컬러값 정보</h5>
			                <p class="card-text text-center" style="padding:8vh 0 0 0;">선택하신 컬러 값의 R : <strong class="rgb_r"></strong>, G : <strong class="rgb_g"></strong>, B : <strong class="rgb_b"></strong> 값은 <span class="hex_value"></span> 입니다.</p>
			            </div>
			        </div>
			    </div>
			</div>
			<div class="row text-center" style="padding-top:50px;">
				<form action="saveColorResult.do" method="POST" id="saveColorResult" class="" enctype="application/x-www-form-urlencoded; charset=UTF-8" >
					<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" />
					<input type="hidden" id="fileName" name="fileName" value="<%= filename %>" />
					<input type="hidden" id="hexVal" name="hexVal" />
					<input type="hidden" id="memID" name="memID" value="${memResult.memID}" />
					<button type="button" onclick="chkLoginUser()" class="btn btn-primary d-block m-auto ps-2 fw-bold">변경된 사진 저장</button>
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