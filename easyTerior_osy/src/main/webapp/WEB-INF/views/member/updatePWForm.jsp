<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<script type="text/javascript">
	// 비밀번호 동일 여부 확인
	function passwordCheck(){
		let memPassword1 = $("#memPassword1").val();
		let memPassword2 = $("#memPassword2").val();
		if (memPassword1 != memPassword2){
			$("#passMessage").text("비밀번호가 서로 일치하지 않습니다. 비밀번호를 확인해주세요.");
			$("#passMessage").css("color","red");
		}else{
			$("#passMessage").text("비밀번호가 서로 일치합니다.");
			$("#passMessage").css("color","green");
			$("#memPassword").val(memPassword1);
		}
		
	}
	
	$(document).ready(function(){
		// 회원가입 실패 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "실패 메세지"}){
				$("#checkType .modal-header.card-header").attr("class","modal-header card-header bg-warning");
			}
			$("#myModal").modal("show");
		}
		
		$(".updateList .on").addClass("fw-bold");
	});
	
</script>
<title>updatePWForm.do</title>
</head>
<body>
	<main class="main">
		<jsp:include page="../common/header.jsp"></jsp:include>
		<jsp:include page="../common/submenu.jsp"></jsp:include>
		<section class="fixed-top container-fluid overflow-auto"
			style="height: 100%; margin: 137px 0 0; padding: 56px 0 0 100px;">
			<div class="container-fluid"
				style="min-height: 100vh; margin-bottom: 200px;">
				<div class="container-fluid">
					<div class="mb-5">
						<h2 class="text-center">마이 페이지</h2>
					</div>
					<div class="row">
						<div class="col-4 bg-white">
							<input type="hidden" name=memName id="memName"
								value="${ memResult.memName }" /> <img
								class="img d-block m-auto" style="width: 150px;"
								src="${ contextPath }/resources/images/common/person.png"
								alt="profile default">
							<p class="mt-3 mb-4 text-center fs-4 fw-bold ">${memResult.memName}님
								환영합니다.</p>
							<ul class="updateList m-auto" style="width: 200px;">
								<li class="mb-3 ps-2"><a href="updateForm.do"
									class="link-dark text-decoration-none">개인정보 수정</a></li>
								<li class="mb-3 ps-2 on"><a href="updatePWForm.do"
									class="link-dark text-decoration-none">비밀번호 변경</a></li>
								<li class="mb-3 ps-2"><a href="updateImg.do"
									class="link-dark text-decoration-none">저장한 이미지 확인</a></li>
								<li class="mb-3 ps-2"><a href="updateResult.do"
									class="link-dark text-decoration-none">취향 결과 확인</a></li>
							</ul>
						</div>
						<div class="col-7" style="background-color: rgb(241, 241, 241);">
							<div class="container m-auto" style="width: 70%;">
								<form action="updatePW.do" method="POST"
									class="form container needs-validation mt-4">

									<legend class="mb-4 fs-4 text-center">비밀번호 변경</legend>
									<!-- CSRF token -->
									<input type="hidden" name="${ _csrf.parameterName }"
										value="${ _csrf.token }" /> <input type="hidden" id="memID"
										name="memID" value="${ memResult.memID }" /> <input
										type="hidden" id="memID" name="memName"
										value="${ memResult.memName }" /> <input type="hidden"
										id="memPassword" name="memPassword" />
									<!-- memPassword1와 memPassword2가 일치해야만이 memPassword가 될 것 -->

									<div class="row mb-3 position-relative">
										<label for="memPassword1" class="col-sm-3 col-form-label">비밀번호</label>
										<div class="col-sm-9">
											<input type="password" placeholder="비밀번호 현재 패턴 적용 안 함"
												name="memPassword1" id="memPassword1" class="form-control"
												onkeyup="passwordCheck()" />
										</div>
										<div class="valid-tooltip"></div>
									</div>
									<div class="row mb-3 position-relative">
										<label for="memPassword2" class="col-sm-3 col-form-label">비밀번호
											확인</label>
										<div class="col-sm-9">
											<input type="password" placeholder="비밀번호 현재 패턴 적용 안 함"
												name="memPassword2" id="memPassword2" class="form-control"
												onkeyup="passwordCheck()" />
											<div class="valid-tooltip"></div>
											
										</div>
										<br>
											<span id="passMessage"></span>
									</div>

									<div class="row mb-3">
										<div class="col-sm-10 offset-sm-2 text-center">
											
											<button type="submit" class="btn btn-primary">수정하기</button>
											<button type="reset" class="btn btn-warning">취소하기</button>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<jsp:include page="../common/footer.jsp"></jsp:include>
	</main>
	<!-- The Modal -->
	<div class="modal fade" id="myModal">
		<!-- animation : fade -->
		<div class="modal-dialog">
			<div id="checkType" class="card modal-content">

				<!-- Modal Header -->
				<div class="modal-header card-header">
					<h4 id="titleMsg" class="modal-title text-center">${ msgType }</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">
					<p id="checkMessage" class="text-center">${ msg }</p>
				</div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger"
						data-bs-dismiss="modal">닫기</button>
				</div>

			</div>
		</div>
	</div>
</body>
</html>