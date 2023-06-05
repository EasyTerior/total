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
		<h1 class="text-center mt-4 mb-3">스타일 분석 결과</h1>
		<!-- 실질 컨텐츠 위치 -->
		<div class="container-fluid" style="min-height:100vh; margin-bottom:200px;">
			<h3>
				<span class="d-block mt-5 mb-3 fs-6 text-center">당신의 대표 인테리어는?</span>
				<strong id="styleResult" class="d-block mb-5 fw-bold fs-2 text-center">스칸디나비아 스타일</strong>
			</h3>
			<form>
				<div class="row m-auto text-center">
					<div class="col">
						<img src="${ contextPath }/resources/images/common/styleRoom_Result_image_1.png"
							alt="Interior Image" class="img-fluid">
					</div>
					<div class="col-sm-3">
						<h5 class="fw-bold fs-6 text-center">&lt;대표 스타일&gt;</h5>
						<strong class="d-block mt-3 mb-4 fs-5"><span class="bg-primary d-block">스칸디나비아</span> 96% 일치</strong>
						<strong class="d-block mt-3 mb-4 fs-6"><span class="bg-info d-block">모던</span> 72% 일치</strong>
					</div>
				</div>
				<div class="row mt-4 mb-4 ps-2 text-center">스칸디나비아 스타일은 스칸디나비아 지역의 디자인 철학으로, 간결하고 심플한 디자인 원칙을 따릅니다. 밝고 넓은 공간을 선호하며, 자연 소재인 목재와 플랜트를 활용하여 자연스러운 분위기를 조성합니다. 중립적인 색상과 자연광을 즐기며, 기능성과 실용성을 중시하여 실용적이면서도 아름다운 공간을 만들어냅니다.</div>
				<div class="row mt-4 mb-4">
					<div class="col text-center">
						<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" />
					<label for="styleSave" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width:260px">스타일 저장하기</label>
					<input type="file" id="styleSave" class="invisible" />
					</div>
				</div>
			</form>
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