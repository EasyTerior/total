<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"><!-- icons -->
<link href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css"
rel="stylesheet" /><!-- icons -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<style>
body, main, section {
position: relative;
}
</style>
<script type="text/javascript">

//CSRF 토큰의 이름과 값 설정 -> 비동기 방식은 csrfHeaderName으로 넣음
var csrfHeaderName = "${ _csrf.headerName }"; // 문자열 형태로
var csrfTokenValue = "${ _csrf.token }";

//서버 메세지 전달
function serverMsg(){
	// 회원가입 실패 후 modal 표시
	if(${ not empty msgType}){
		if(${msgType eq "실패 메세지"}){
			$("#checkType .modal-header.card-header").attr("class","modal-header card-header bg-warning");
		}
		$("#myModal").modal("show");
	}
}

//사용자 정보 가져오기
function getUserInfo() {
	$.ajax({
		url: "member/getUserInfo",
		type: "POST",
		beforeSend : function(xhr){ // xhr 에 담아서 보냄
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		},
		data: {"memID":"${memResult.memID}"},
		dataType: "json",
		success: function(response) {
			// 서버에서 반환된 사용자 정보를 response 변수로 받아 처리
			// JSON 형태의 사용자 정보를 JavaScript 객체로 변환
			console.log("success - "+response);
			$("#memID").val(response.memID);
			$("#memNickname").val(response.memNickname);
			$("#memPhone").val(response.memPhone);
			$("#memEmail").val(response.memEmail);
			$("#oldAddress").val(response.memAddress);
		},
		error: function(xhr, status, error) {
			alert("Error - xhr : "+xhr+" | status : "+status+" | error : "+error);
			console.error(error);
		}
	});
}

// 화면 방문 시 목록 중에서 처음만 보여주기.
function resetForm(){
	// 모든 formContainer 숨기기
    $(".formContainer").hide();
	// 첫 번째 li에 on 클래스 추가 및 첫 번째 formContainer 보여주기
    $(".updateList li:first").addClass("on");
    $("#formContainer1").show();
    $(".updateList .on").addClass("fw-bold");
    
 	// 페이지 로드 시 사용자 정보 가져오기
    getUserInfo();
 	
}

// 주소 채우기
function addressFill(){
	let add1 = $("#address").val();
	let add2 = $("#detailAddress").val();
	let add3 = $("#extraAddress").val();
	let fullAddress = add1+ " " + add2 + " " + add3;
	$("#memAddress").val(fullAddress);
	
}

// 정보 수정 비동기
function updateInfo(event){
    // 1. 클릭된 버튼이 속한 form에서 정보 가져오기
    var formID = $(event.target).closest('form').attr('id');
    var formData = $('#' + formID).serializeArray();

 	// formData를 객체로 변환하기
    var dataObj = {};
    $.each(formData, function(index, obj){ dataObj[obj.name] = obj.value; });

    // 2. 세션에서 가져온 정보를 dataObj에 추가하기
    dataObj["memID"] = "${memResult.memID}";
    dataObj["memName"] = "${memResult.memName}";
    
    $.ajax({ // js에서 객체 표현 방식 -> json
    	url: "member/"+formID, // personal : 개인정보, password : 비밀번호
    	type: "POST",
		beforeSend : function(xhr){ // xhr 에 담아서 보냄
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		},
		contentType: 'application/json',
		data: JSON.stringify(dataObj),
		dataType: "json",
		success: function(response) {
            console.log("update success");
            resetForm()
        },
        error: function(xhr, status, error) {
			alert("Error - xhr : "+xhr+" | status : "+status+" | error : "+error);
			console.error(error);
		}
    });
    
}

$(document).ready(function() {
	// 서버 메세지 전달 : msgType
	serverMsg();
	resetForm();
	// getUserInfo();
	
	// li 클릭 시 해당하는 formContainer 표시
	$("ul.updateList li").click(function() {
		var idxNum = $(this).index() + 1;
		$(".formContainer").hide();
		$("#formContainer" + idxNum).show();
	});

	alert('document ready');
	
});
</script>
<title>updateForm.do</title>
</head>
<body>
<main class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	<section class="fixed-top container-fluid overflow-auto" style="height:100%;margin:137px 0 0;padding:56px 0 0 100px;">
	<div class="container-fluid" style="min-height:100vh;margin-bottom: 200px;">
		<div class="container-fluid">
			<div class="mb-5"><h2 class="text-center">마이 페이지</h2></div>
			<div class="row">
				<div class="col-4 bg-white">
					<div class="">
						<img class="img d-block m-auto" style="width:150px;" src="${ contextPath }/resources/images/common/person.png" alt="profile default">
						<a href="${ contextPath }/imageForm.do" class="nav-link link-dark"><i class="bi bi-camera-fill align-middle"></i></a>
					</div>
					<p class="mt-3 mb-4 text-center fs-4 fw-bold ">${memResult.memName}님 환영합니다.</p>
					<ul class="updateList m-auto" style="width:200px;">
						<li class="mb-3 ps-2 on"><span role="button" class="link-dark text-decoration-none">개인정보 수정</span></li>
						<li class="mb-3 ps-2"><span role="button" class="link-dark text-decoration-none">비밀번호 변경</span></li>
						<li class="mb-3 ps-2"><span role="button" class="link-dark text-decoration-none">저장한 이미지 확인</span></li>
						<li class="mb-3 ps-2"><span role="button" class="link-dark text-decoration-none">취향 결과 확인</span></li>
					</ul>
				</div>
				<div class="col-7 bg-secondary">
					<div id="formContainer1" class="container m-auto formContainer" style="width:90%;">
						<form id="personal" name="personal">
						<legend class="mt-4 mb-3 text-center fw-bold">개인정보 수정 하기</legend>	
							<div class="row mt-4 mb-3">
							    <label for="memNickname" class="col-sm-3 col-form-label">닉네임</label>
							    <div class="col-sm-9">
							        <input type="text" placeholder="공백 없이 한글, 영어, 숫자로 10자 미만의 닉네임만 가능합니다." pattern="^[ㄱ-ㅎ가-힣a-zA-Z0-9]+" maxlength=10 class="form-control" id="memNickname" name="memNickname" required />
							    </div>
							</div>
							<div class="row mb-3">
							    <label for="memPhone" class="col-sm-3 col-form-label">휴대폰 번호</label>
							    <div class="col-sm-9">
							        <input type="text" placeholder="000-0000-0000" pattern="^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$" class="form-control" id="memPhone" name="memPhone" required />
							    </div>
							</div>
							<div class="row mb-3">
							    <label for="memEmail" class="col-sm-3 col-form-label">이메일</label>
							    <div class="col-sm-9">
							        <input type="email" placeholder="email@email.com" pattern="^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$" class="form-control" id="memEmail" name="memEmail" required />
							    </div>
							</div>
							<div class="row mb-3">
								<label for="memAddress" class="col-sm-3 col-form-label">현재 주소</label>
								<div class="col-sm-9">
									<input type="text" name="oldAddress" id="oldAddress" class="form-control" readonly />
								</div>
							</div>
							<div class="row mb-3">
							    <label for="memAddress" class="col-sm-3 col-form-label">수정할 주소</label>
							    <input type="hidden" name="memAddress" id="memAddress" />
							    <div class="col-sm-9">
							    	<div class="row mb-2">
							    		<div class="col-12">
							    			<input type="text" onchange="addressFill()" id="address" class="form-control" style="min-width: 300px;" placeholder="주소" required />
							    		</div>
							    	</div>
							    	<div class="row mb-2">
							    		<div class="col-auto">
							    			<input type="text" onchange="addressFill()" id="detailAddress" class="form-control" placeholder="상세주소" />
							    		</div>
							    		<div class="col-auto">
							    			<input type="text" onchange="addressFill()" style="width: 150px;" id="extraAddress" class="form-control" placeholder="참고항목" />
							    		</div>
							    		<div class="col-auto">
							    			<button type="button" class="btn btn-info align-top" onclick="addressFullFill()">주소찾기</button>
							    		</div>
							    	</div>
							    </div>
							</div>
							<div class="row mb-3">
								<div class="col-sm-9 offset-sm-2 text-center">
							        <button type="button" onclick='updateInfo(event)' class="btn btn-primary">수정하기</button>
							        <button type="reset" class="btn btn-warning">취소하기</button>
							    </div>
							</div>
						</form>
					</div>
					<div id="formContainer2" class="container m-auto formContainer" style="width:90%;">
						<form id="password" name="password">
						<legend class="mt-4 mb-3 text-center fw-bold">비밀번호 변경 하기</legend>	
							<div class="row mb-3 position-relative">
							    <label for="memPassword1" class="col-sm-3 col-form-label">비밀번호</label>
							    <div class="col-sm-9">
							        <input type="password" placeholder="비밀번호 현재 패턴 적용 안 함" name="memPassword1" id="memPassword1" class="form-control" onkeyup="passwordCheck()" />
							    </div>
							</div>
							<div class="row mb-3 position-relative">
							    <label for="memPassword2" class="col-sm-3 col-form-label">비밀번호 확인</label>
							    <div class="col-sm-9">
							        <input type="password" placeholder="비밀번호 현재 패턴 적용 안 함" name="memPassword2" id="memPassword2" class="form-control" onkeyup="passwordCheck()" />
							        <div class="valid-tooltip"></div>
							    </div>
							</div>
							<div class="row mb-3">
								<div class="col-sm-9 offset-sm-2 text-center">
							        <button type="button" onclick='updateInfo(event)' class="btn btn-primary">수정하기</button>
							        <button type="reset" class="btn btn-warning">취소하기</button>
							    </div>
							</div>
						</form>
					</div>
				    <div id="formContainer3" class="container m-auto formContainer" style="width:90%;">
				    	<form id="savedImages" name="savedImages">
				    	<legend class="mt-4 mb-3 text-center fw-bold">저장한 이미지 수정하기</legend>
				    	
				    		<div class="row mb-3">
								<div class="col-sm-9 offset-sm-2 text-center">
							        <button type="button" onclick='updateInfo(event)' class="btn btn-primary">수정하기</button>
							        <button type="reset" class="btn btn-warning">취소하기</button>
							    </div>
							</div>
						</form>
				    </div>
				    <div id="formContainer4" class="container m-auto formContainer" style="width:90%;">
				    	<form id="savedStyle" name="savedStyle">
				    	<legend class="mt-4 mb-3 text-center fw-bold">저장한 스타일 확인하기</legend>
				    		<div class="row mb-3">
								<div class="col-sm-9 offset-sm-2 text-center">
							        <button type="button" onclick='updateInfo(event)' class="btn btn-primary">수정하기</button>
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
<div class="modal fade" id="myModal"><!-- animation : fade -->
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
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
      </div>

    </div>
  </div>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
    function addressFullFill() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                // document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // memAddress 에 추가
                document.getElementById("memAddress").value = addr;
                
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
</script>
</body>
</html>