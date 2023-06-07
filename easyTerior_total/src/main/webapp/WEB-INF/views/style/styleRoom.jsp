<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
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
	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "성공 메세지"}){ // MemberController.java에서 rttr.addFlashAttribute("msgType", "성공 메세지");로 보냄
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
			}
			$("#myModal").modal("show");
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
		<h1 class="text-center mt-4 mb-5">스타일 분석하기</h1>
		<!-- 실질 컨텐츠 위치 -->
		<div class="container-fluid" style="min-height:100vh; margin-bottom:200px;">
			<div class="row m-auto card-group" style="width:80%">
				<div class="card border-0" style="min-width:385px">
		            <div class="card-body">
						<h5 class="text-center fw-bold">예시 이미지</h5>
					</div>
					<img class="card-img-bottom img-fluid" src="${ contextPath }/resources/images/common/StyleRoom_image_1.jpg" style="max-width:500px; max-height: 300px;" alt="StyleRoom_image_1.jpg">
				</div>
				<div class="card border-0" style="min-width:385px">
		            <div class="card-body">
						<h5 class="text-center fw-bold">이미지 가이드라인</h5>
					</div>
					<h7 class="text-center fw-bold">예시이미지처럼 방 전체가 다 보이도록 찍은 사진을
					업로드해주세요.<br /><br />다음은 적절하지 않은 사진 예시 입니다.<br />소품만
					보이는 사진은 인식이 어려워요!</h7>
					<div class="row" style="margin-top: 20px">
						<div class="col-sm-6">
							<img class="img-fluid" src="${ contextPath }/resources/images/common/StyleRoom_image_2.png" style="max-width:200px; max-height: 200px;" alt="myImage">
							<h4 class="text-center fw-bold">(x)</h4>
						</div>
						<div class="col-sm-6">
							<img class="img-fluid" src="${ contextPath }/resources/images/common/StyleRoom_image_3.png"
								style="max-width:200px; max-height: 200px;" alt="myImage">
							<h4 class="text-center fw-bold">(x)</h4>
						</div>
					</div>
				</div>
			</div>
			<div class="row text-center" style="padding-top:50px;">
				<form action="" method="POST" enctype="multipart/form-data" class="text-center">
					<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" />
					<label for="imgUpload" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width:260px">사진 업로드</label>
					<input type="file" id="imgUpload" class="invisible" />
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