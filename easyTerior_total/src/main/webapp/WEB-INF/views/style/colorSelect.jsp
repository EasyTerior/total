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
		
		// Ajax 요청
		  $.ajax({
		    url: "style/colorSelect", // URL
		    type: "GET",
		    dataType: "json",
		    success: function(flaskResponse) {
		      // 이미지 경로 수정
		      var imagePath = flaskResponse.data.origin_img.replaceAll("\\\\", "/");
		      var startIndex = imagePath.indexOf("/resources/flask/");
		      imagePath = imagePath.substring(startIndex);

		      // originalImage의 src 속성 설정
		      $("#originalImage").attr("src", "${contextPath}" + imagePath);

		      // 발견된 객체 정보 가져오기
		      var objects = flaskResponse.data.objects;

		      // 객체 정보 확인
		      if (objects.length === 0) {
		        // 객체가 발견되지 않았을 경우
		        $("#objectList").text("객체가 발견되지 않았습니다.");
		      } else {
		        // 객체가 발견된 경우
		        var uniqueObjects = Array.from(new Set(objects)); // 중복 제거된 객체 ID 목록
		        var objectInfoArray = []; // 객체 정보를 담을 배열

		        // 객체 정보 생성
		        for (var i = 0; i < uniqueObjects.length; i++) {
		          var objectID = uniqueObjects[i].id;
		          var objectInfo = {
		            id: objectID,
		            // ... 추가적인 객체 정보 필드들
		          };
		          objectInfoArray.push(objectInfo);
		        }

		        // 객체 정보를 이름순으로 정렬
		        objectInfoArray.sort(function(a, b) {
		          return a.id.localeCompare(b.id);
		        });

		        // 버튼 생성
		        for (var j = 0; j < objectInfoArray.length; j++) {
		          var objectID = objectInfoArray[j].id;
		          // ... 버튼 생성 및 추가 로직 작성
		          var button = '<button type="button" class="btn btn-primary">' + objectID + '</button>';
		          $("#objectList").append(button);
		        }
		      }
		    },
		    error: function() {
		      console.log("FlaskResponse 가져오기 실패");
		    }
		  });
		
		
		// flaskResponse 가져오기
		var imagePath = ${flaskResponse}.data.origin_img.replaceAll("\\","/");
		var startIndex = imagePath.indexOf("/resources/flask/");
		var imagePath = imagePath.substring(startIndex);
		
		// originalImage의 src 속성 설정
		$("#originalImage").attr("src", "${contextPath}" + imagePath);
		
		// 발견된 객체 
		var objects = ${flaskResponse}.data.objects;
		console.log(objects);
		
		console.log($("#selectedColor").val());
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
		                <h5 class="card-title text-center fw-bold">업로드한 이미지</h5>
		            </div>
		            <img id="originalImage" class="card-img-bottom" name="originalImage" alt="originalImage" />
		        </div>
			    <div class="card border-0" style="min-width:385px">
		            <div class="card-body">
		                <div class="row">
	                		<h5 class="card-title text-center mb-4 fw-bold">발견된 객체</h5>
	                		<div id="objectList" class="col"></div>
	                	</div>
	                	<div class="row">
	                		<h5 class="card-title text-center mb-4 fw-bold">색상을 선택해주세요</h5>
	                		<div id="colorSelect" class="col">
	                			<input type="color" id="selectedColor" name="selectedColor" />
	                		</div>
	                	</div>
			        </div>
			    </div>
			</div>
			<div class="row text-center" style="padding-top:50px;">
			<!--  action="http://127.0.0.1:5000/process_image" -->
				<form action="${ contextPath }/imageSelect.do?${_csrf.parameterName}=${ _csrf.token }" method="POST" enctype="multipart/form-data" id="uploadForm" class="text-center">
					<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" />
					<input type="hidden" name="memID" value="${ memResult.memID }" />
					<label for="imgUpload" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width:260px">사진 업로드</label>
					<input type="file" id="imgUpload" name="imgUpload" class="invisible" onchange="document.getElementById('uploadForm').submit();" />
			        <input type="submit" style="display:none" />
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