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

<!-- bxSlider Javascript file -->
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<!-- bxSlider CSS file -->
<link href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css" rel="stylesheet" />
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
/* hec */
.pline{
font-size: 20px;  /* 글자 크기 설정 */
font-weight:bold;
text-align:center;
margin-top:20px;
margin-bottom:20px;
}
</style>
<script type="text/javascript">
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	var slider;
	var memID = "${memResult.memID}"
	var styleImg;

	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "성공 메세지"}){ // MemberController.java에서 rttr.addFlashAttribute("msgType", "성공 메세지");로 보냄
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
			}
			$("#myModal").modal("show");
		}
		
		// 이미지 파일 선택 시
	    $("#imageFile").change(function() {
			var file = $("#imageFile")[0].files[0];
			var formData = new FormData();
			formData.append("file", file);
			formData.append("memID", memID);
	      	// Ajax 통신
	      	$.ajax({
		        url: "http://localhost:5000/upload",
		        type: "POST",
		        data: formData,
		        beforeSend: function(xhr) {
	                xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	            },
		        contentType: false,
		        processData: false,
		        success: function(result) {
		        	// 결과 처리
		        	resultData = result;
		        	displayResult(result);
		        	// 쇼핑 API 호출
		        	callShoppingAPI(result);
	        	},
	        	error: function(error) {
	        		console.log(error);
	        	}
        	});
	    });
		
	});
	
	
	// 결과 표시 함수
    function displayResult(result) {
		// 결과 값을 표시하는 로직 작성
      	console.log(result);
		var uploadedImage = document.getElementById("uploadedImage");
		uploadedImage.src = URL.createObjectURL($("#imageFile")[0].files[0]);
		$("#resultType").text(result[0].class+" 스타일");

		// 쇼핑API 함수 호출
		callShoppingAPI(result);
		$("#resultText1-class").text(result[0].class);
		$("#resultText1-probability").text((result[0].probability * 100).toFixed(2) + "% 일치");
		$("#resultText2-class").text(result[1].class);
		$("#resultText2-probability").text((result[1].probability * 100).toFixed(2) + "% 일치");
		$("#resultType-Explanation").text(result[0].explanation);

		$("#result").css("display", "block");
		$("#base").css("display", "none");
      	if(memID!=""){
	      	styleImg=result[3].img_path;
	    }
    }
	
	// 
	function callShoppingAPI(result) {
		var style = result[0].class;
		var image_urls = result[2].image_urls;
		console.log(image_urls);
		var image_src = result[2].image_src;
		console.log(image_src);
		$('#bxslider').empty();
		for(var i = 0; i < image_urls.length; i++) {
			$('#bxslider').append('<a href="'+image_urls[i]+'"><img src="'+image_src[i]+'" width="220px" height="220px"></a>');
		}
		// 이미지 로딩을 위해 약간의 시간을 기다립니다.
		setTimeout(function() {

			if (slider) {
				slider.destroySlider(); // 기존 슬라이더가 존재하는 경우 파괴합니다.
			}
	        // 새로운 슬라이더를 생성하고 인스턴스를 저장합니다.
	        slider = $('#bxslider').bxSlider({
	        	minSlides: 2,
	        	maxSlides: 100,
	        	moveSlides: 1,
	        	slideWidth: 300,
	        	slideMargin: 2,
	        	mode: 'horizontal',
	        	auto: true,
	        	pause: 3000,
	        	speed: 1000
	       	});
	        console.log(slider);
        }, 500);
	}
	
	// 결과 숨기고 다시 분석 테스트 div 열기
    function showBase() {
        $("#result").css("display", "none");
        $("#base").css("display", "block");
    }
	
	// 
	function saveStyle() {
	    var memID = "${memResult.memID}";
	    console.log(memID);
        if (memID == "") {
            // alert("로그인 해주세요.");
        	$(".modal-title").text("실패 메세지");
        	$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-danger");
        	$("#checkMessage").text("로그인이 되어있지 않아 사진을 저장할 수 없습니다. 로그인 한 사용자만이 사진을 저장할 수 있습니다!");
        	$("#myModal").modal("show");
        }
        else{
	        var resultClass1 = $("#resultText1-class").text();
	        //console.log(resultClass1);
	        var resultClass2 = $("#resultText2-class").text();
	        //console.log(resultClass2);
	        var resultClass1_probability = $("#resultText1-probability").text();
	        //console.log(resultClass1_probability);
	        var resultClass2_probability = $("#resultText2-probability").text();
	        //console.log(resultClass2_probability);
	        console.log(styleImg);
	        // else 중괄호 닫기 체크
	
			var data = {
			    resultClass1: resultClass1,
			    resultClass2: resultClass2,
			    resultClass1_probability: resultClass1_probability,
			    resultClass2_probability: resultClass2_probability,
			    styleImg:styleImg, //체크
			    memID: memID
			};
        	console.log(data);

        	// ajax 비동기 통신
	        $.ajax({
	            url: "style/save",
	            type: "post",
	            beforeSend: function(xhr) {
	                xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	            },
	            data: JSON.stringify(data),
	            contentType: "application/json",
	            dataType: "json",
	            success: function(response) {
	                //console.log(response); // 서버 응답 확인
	                alert("성공적으로 저장되었습니다.");
	                //showBase();
	            },
	            error: function(xhr, status, error) {
	                console.log(xhr); // 에러 상세 정보 확인
	                console.log(status);
	                console.log(error);
	                alert("저장에 실패했습니다.");
	            }
        	});
        }
    }
	
</script>
<title>EasyTerior</title>
</head>
<body>
<main class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	<section id="base" class="fixed-top container-fluid overflow-auto h-100" style="margin:137px 0 56px 0;padding:0 0 56px 100px; display:block;">
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
				<input type="file" id="imageFile" accept="image/*" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width: 260px; opacity: 0; position: absolute;">
				<label for="imageFile" class="btn btn-primary d-block m-auto ps-2 fw-bold" style="width: 260px;">사진 업로드</label>
			</div>
		</div>
	</section>
	<section id="result" class="fixed-top container-fluid overflow-auto h-100" style="margin:137px 0 56px 0;padding:0 0 56px 100px; display:none;">
		<h1 class="text-center mt-4 mb-3">스타일 분석 결과</h1>
		<!-- 실질 컨텐츠 위치 -->
		<div class="container-fluid" style="min-height:100vh; margin-bottom:200px;">
			<h3>
				<span class="d-block mt-5 mb-3 fs-6 text-center">당신의 대표 인테리어는?</span>
				<strong id="resultType" class="d-block mb-5 fw-bold fs-2 text-center"></strong>
			</h3>
			<div class="row m-auto text-center">
				<div class="col">
						<img id="uploadedImage" src="${ contextPath }/resources/images/common/styleRoom_Result_image_1.png"
							alt="Interior Image" class="img-fluid" style="width:80%;">
				</div>
				<div class="col-sm-3">
					<h5 class="fw-bold fs-6 text-center">&lt;대표 스타일&gt;</h5>
					<strong class="d-block mt-3 mb-4 fs-5">
						<span id="resultText1-class" class="bg-primary d-block"></span><span id="resultText1-probability"></span>
					</strong>
					<strong class="d-block mt-3 mb-4 fs-6">
						<span id="resultText2-class" class="bg-info d-block"></span>
						<span id="resultText2-probability"></span>
					</strong>
				</div>
			</div>
			<div id="resultType-Explanation" class="row mt-4 mb-4 ps-2 text-center" style="width:60%; margin:auto;"></div>
			<div class="row mt-4 mb-4">
				<div class="col text-center">
				<button onclick="showBase()" class="btn btn-success ps-2 fw-bold" style="width: 260px;">다시 해보기</button>
				<button onclick="saveStyle()" class="btn btn-primary ps-2 fw-bold" style="width: 260px;">스타일 저장하기</button>
				</div>
			</div>
			<div class="row mb-4">
				<div class="col text-center">
					<p class="pline">이 스타일과 관련된 인테리어 아이템을 추천해드릴게요!</p>
					<div>
						<div id="bxslider"></div>
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