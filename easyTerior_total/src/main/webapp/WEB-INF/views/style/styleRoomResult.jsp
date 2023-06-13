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
	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "성공 메세지"}){ // MemberController.java에서 rttr.addFlashAttribute("msgType", "성공 메세지");로 보냄
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
			}
			$("#myModal").modal("show");
		}
		
	});
	$(document).ready(function() {
	    // styleIdx 값을 활용하여 작업 수행
   	    
	    var styleIdx = ${style.styleIdx}; // style 객체에서 styleIdx 값 추출
	    var resultClass1 = "${style.resultClass1}";
	    var resultClass2 = "${style.resultClass2}";
	    var resultClass1_probability = "${style.resultClass1_probability}";
	    var resultClass2_probability = "${style.resultClass2_probability}";
	    //var resultType-Explanation = 
	    var styleImg = "${style.styleImg}";
	    console.log(styleImg)
	    var setimgpath="${ contextPath }/resources/images/style/"+styleImg;
	    console.log(setimgpath)
	    uploadedImage.src=setimgpath;
	    Result_callShoppingAPI(resultClass1)
		$("#resultType").text(resultClass1+" 스타일");
		
		// 쇼핑API 함수 호출
		$("#resultText1-class").text(resultClass1);
		$("#resultText1-probability").text(resultClass1_probability);
		$("#resultText2-class").text(resultClass2);
		$("#resultText2-probability").text(resultClass2_probability);
		
		//$("#resultType-Explanation").text(result[0].explanation);
	    // 여기에서 필요한 작업을 수행하고 styleIdx 값을 활용할 수 있습니다.
	    // 예를 들어, AJAX 요청을 보내거나 화면에 표시하는 등의 작업을 수행할 수 있습니다.
	});
	var slider;
    function Result_callShoppingAPI(resultClass1) {
    	console.log(resultClass1);
      	// Ajax 통신
      	$.ajax({
	        url: "http://localhost:5000/call_api",
	        type: "POST",
	        data: JSON.stringify({ "style" : resultClass1 }),
	        contentType: "application/json",
	        processData: false,
	        success: function(result) {
	        	console.log(result)
	        	// 결과 처리
	        	
        	$("#resultType-Explanation").text(result[0].explanation);
	            var image_urls = result[1].image_urls;
	            console.log(image_urls);
	            var image_src = result[1].image_src;
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

        	},
        	error: function(error) {
        		console.log(error);
        	}
    	});
    }


        
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
				<strong id="resultType" class="d-block mb-5 fw-bold fs-2 text-center">스칸디나비아 스타일</strong>
			</h3>
			<form>
				<div class="row m-auto text-center">
					<div class="col">
						<img id="uploadedImage" src="${ contextPath }/resources/images/common/styleRoom_Result_image_1.png"
							alt="Interior Image" class="img-fluid" style="width:80%;">
					</div>
					<div class="col-sm-3">
						<h5 class="fw-bold fs-6 text-center">&lt;대표 스타일&gt;</h5>
						<strong class="d-block mt-3 mb-4 fs-5"><span id="resultText1-class" class="bg-primary d-block"></span><span id="resultText1-probability"></span></strong>
						<strong class="d-block mt-3 mb-4 fs-6"><span id="resultText2-class" class="bg-info d-block"></span><span id="resultText2-probability"></span></strong>
					</div>
				</div>
				<div id="resultType-Explanation" class="row mt-4 mb-4 ps-2 text-center" style="width:60%; margin:auto;"></div>
				<div class="row mt-4 mb-4">
					
				</div>
			</form>
			<div class="row">
				<div calss="col">
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