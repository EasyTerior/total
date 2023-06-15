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
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<!-- icons -->
<link
	href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css"
	rel="stylesheet" />
<!-- icons -->
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<style>
body, main, section {
	position: relative;
}

.card img {
	max-width: 100%;
	max-height: 200px;
	object-fit: contain;
}

.image-container {
	width: 100%; /* Adjust the width of the container as needed */
	height: 200px; /* Adjust the height of the container as needed */
	overflow: hidden;
}

.image-container img {
	width: 100%;
	height: 300%;
	object-fit: contain;
}

.btn-custom {
	padding: 0.25rem 0.75rem;
	background-color: lightblue;
	border: none;
}

@font-face {
	font-family: 'SUITE-Regular';
	src:
		url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-Regular.woff2')
		format('woff2');
	font-weight: 400;
	font-style: normal;
}

body, main, section {
	position: relative;
	font-family: 'SUITE-Regular';
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
    // 회원가입 후 modal 표시
    if (${not empty msgType}) {
        if (${msgType eq "성공 메세지"}) {
            $("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-success");
        }
        $("#myModal").modal("show");
    }

    // 투표 항목 추가
    var itemCount = 1; // 초기 항목 수 설정

    $("#addItemBtn").click(function() {
        itemCount++; // 항목 수 증가
        var inputField = '<div class="offset-md-1 col-md-11 mb-2" style="display: block;">' +
            '<input type="text" class="form-control vote-item" name="voteContent'+ (itemCount+1) +'" placeholder="' + (itemCount+1) + '. 항목을 입력하세요">' +
            '</div>';
        var newInputField = $(inputField).clone(); // 새로운 input 요소 생성
        newInputField.find("input").attr("id", "vote-item-" + (itemCount+1)); // 증가된 id 적용 -> 이렇게 하면 input 태그 각각 id값이 달라짐
        $("input[type='text']:last").parent().after(newInputField); // 마지막 input 요소 바로 뒤에 동적으로 입력 필드를 생성하여 쭉쭉 추가됨
    });

    // 페이지 로드 시 checkbox 상태에 따라 입력 필드와 버튼 초기 상태 설정
    if ($("#vote_check").is(":checked")) {
        enableVoteItems();
    } else {
        disableVoteItems();
    }

    // 투표여부 checkbox 상태 변경 시
    $("#vote_check").change(function() {
        if ($(this).is(":checked")) {
            enableVoteItems();
        } else {
            disableVoteItems();
        }
    });

    // '+항목 추가' 버튼 클릭 시
    $("#addItemBtn").click(function() {
        if ($("#vote_check").is(":checked")) {
            enableLastVoteItem();
        }
    });

    function enableVoteItems() {
        // 입력 필드와 버튼을 활성화
        $(".vote-item").prop("disabled", false);
        $("#addItemBtn").prop("disabled", false);
    }

    function disableVoteItems() {
        // 입력 필드와 버튼을 비활성화
        $(".vote-item").prop("disabled", true);
        $("#addItemBtn").prop("disabled", true);
    }

    // 초기 '+항목 추가' 버튼 클릭 시 비활성화
    disableVoteItems();
});

//이미지 업로드
function readURL(input) {
    var file = input.files[0];
    console.log(file);
    if (file != '') {
        var reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = function (e) {
            console.log(e.target);
            console.log(e.target.result);
            $('#preview').attr('src', e.target.result);
        }
    }
} 

	//토큰 이름과 값 설정
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	//HTML이 다 로드되고 나서 작동하겠다 안에있는 코드를
	$(document).ready(function() {
		loadList();
	});

	function loadList() {
		// ajax 비동기 통신
		$.ajax({
			url : "board/all",
			type : "get",
			dataType : "json",
			success : makeView,
			error : function() {
				alert("error...")
			}

		});
	}
	
	function makeView(data) {
		var listHtml = "<div class='container px-4'>"; // Add container class for left and right margins
		listHtml += "<div class='row'>";
		  
		if (${not empty sessionScope.memResult}) {
		  // Write button HTML 
		  listHtml += "<div class='col-md-12' style='margin-bottom: 10px;'>"; // Add margin-bottom to create space below the button
		  listHtml += "<button onclick='goForm()' class='btn btn-sm btn-primary float-end'>글쓰기</button>";
		  listHtml += "</div>";
		}

		listHtml += "<div class='col-md-12'>"; // Start a new column for the post list

		var isRowOpen = false;
		var contextPath = "${contextPath}";

		for (var i = 0; i < data.length; i++) {
		  var model = data[i];
		  console.log(model);

		  if (i % 2 === 0 && !isRowOpen) {
		    listHtml += "<div class='row'>";
		    isRowOpen = true;
		  }

		  listHtml += "<div class='col-md-6'>";
		  listHtml += "<div class='card mb-3'>";
		  listHtml += "<div class='image-container'>";
		  //이미지 없을 때 예외처리
		  if (model.boardImage !== null && model.boardImage !== '') {
		    listHtml += '<img src="' + contextPath + '/resources/images/upload/' + model.boardImage + '" alt="image">';
		  }
		  listHtml += "</div>";
		  listHtml += "<div class='card-body'>";
		  listHtml += "<h5 class='card-title fw-bold'>";
		  listHtml += "<a href='boardContent/" + model.boardID + "' class='text-decoration-none text-dark'>";
		  listHtml += model.title;
		  listHtml += "</a>";
		  listHtml += "</h5>";
		  listHtml += "<p class='card-text'>";
		  listHtml += model.content;
		  if (model.voteContent1 !== null && model.voteContent2 !== null) {
		    listHtml += "<br> <a href='boardContent/" + model.boardID + "' class='btn btn-primary btn-sm text-decoration-none text-white btn-custom'>투표하기</a>";
		  }
		  listHtml += "</p>";
		  listHtml += "</div>";
		  listHtml += "</div>";
		  listHtml += "</div>";

		  if ((i % 2 === 1 || i === data.length - 1) && isRowOpen) {
		    listHtml += "</div>";
		    isRowOpen = false;
		  }
		}

		listHtml += "</div>"; // Close the column div for the post list
		listHtml += "</div>"; // Close the row div
		listHtml += "</div>"; // Close the container div // Close the row div
		  
		  $("#view").html(listHtml);
		  goList();
		}
	
	//글쓰기 페이지 입력 초기화
	function resetForm() {
        $("#frm")[0].reset();
        $(".vote-item").val('');
    }

	function goForm() {
		$("#view").css("display", "none");
		$("#wform").css("display", "block");
		getColorList();
	}

	function goList() {
		$("#view").css("display", "block");
		$("#wform").css("display", "none");
	}
	
	// 이미지 목록 불러오기(여기 이미지 경로 다 바꿔야해요)
	function getColorList(){
		$.ajax({
			url: "style/getColorList",
			type: "POST",
			beforeSend : function(xhr){ // xhr 에 담아서 보냄
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data: {"memID":"${memResult.memID}"},
			dataType: "json",
			success: function(response) {
				console.log("getColorList success");
				// console.log(response);
				// 서버에서 반환된 사용자 정보를 response 변수로 받아 처리
				// 목록을 가져와서 리스트로 구성
				var listItems = "<div class='row'>";
				var count = 0; // Initialize a count variable

				$.each(response, function(index, item) {
				  if (count % 2 === 0 && count !== 0) {
				    listItems += "</div><div class='row'>"; // Close the previous row and start a new row
				  }

				  listItems += "<div class='col-md-6'>"; // Use col-md-6 for two pictures per row
				  listItems += "<li class='form-check d-block mb-3'>";
				  listItems += "<input type='checkbox' class='form-check-input' name='selectedColor' id='img"+item.imgID+"' value='" + item.imgID + "' data-filename ='" + item.fileName + "'/>";
				  listItems += "<label class='form-check-label' for='img"+item.imgID+"'><img src='${pageContext.request.contextPath}/resources/images/upload/"+item.fileName+ "' value ='"+item.imgID+"' class='imgSelect' name='selectedColor' alt="+item.fileName+" style='width:420px;' /></label>";
				  listItems += "</li>";
				  listItems += "</div>"; // Close the column div

				  count++; // Increment the count variable
				});

				listItems += "</div>"; // Close the last row div

				$("#colorImg").html("<ul>" + listItems + "</ul>");


			},
			error: function(xhr, status, error) {
				console.log("getColorList Error - xhr : "+xhr+" | status : "+status+" | error : "+error);
				console.error(error);
			}
		});
	}
	
</script>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	<section class="fixed-top container-fluid overflow-auto"
		style="height: 100%; margin: 137px 0 0; padding: 56px 0 300px 100px;">

		<h1 class="text-center mb-3 fw-bold" style="margin-top: 30px;">커뮤니티</h1>
		<!-- 실질 컨텐츠 위치 -->

		<div class="panel-body" id="view"></div>

		</div>


		<!-- 글쓰기 폼 -->
		<div class="panel-body" id="wform" style="display: none;">
			<div class="container">
				<form action="board/new2?${_csrf.parameterName}=${_csrf.token}"
					method="post" enctype="multipart/form-data">
					<input type="hidden" name="memID"
						value="${sessionScope.memResult.memID}">
					<div class="col-12 mx-auto mt-3 mb-3 p-2"
						style="background-color: lightgray;">
						<div class="d-flex justify-content-center">
							<h5 class="text-dark">글쓰기</h5>
						</div>
					</div>
					<div class="row mb-4">
						<label for="title"
							class="col-form-label col-md-1 text-center fw-bold">제목</label>
						<div class="col-md-11">
							<input type="text" class="form-control" id="title" name="title"
								required="required">
						</div>
					</div>
					<hr>
					<div class="row mb-4">
						<label for="image"
							class="col-form-label col-md-1 text-center fw-bold">사진 추가</label>
						<div class="col-md-11">
							<input type="file" class="form-control" name="file" id="file">
						</div>
					</div>
					<div id="colorImg" class="row mb-4"></div>
					<div class="row mb-4">
						<label for="content"
							class="col-form-label col-md-1 text-Scenter fw-bold">내용</label>
						<div class="col-md-11">
							<textarea class="form-control" id="content" name="content"
								rows="5" required="required"></textarea>
						</div>
					</div>
					<hr>

					<div class="row">
						<label for="content"
							class="col-form-label col-md-1 text-center fw-bold">투표여부</label>
						<div class="col-md-11 d-flex align-items-center">
							<input type="checkbox" name="vote_check" id="vote_check">
						</div>
					</div>

					<div class="row mb-4">
						<div class="offset-md-1 col-md-11 mb-2">
							<span class="fw-bold fs-4">투표 항목</span>
						</div>
						<div class="offset-md-1 col-md-11 mb-2">
							<input type="text" class="form-control vote-item"
								id="vote-item-1" name="voteContent1" placeholder="1. 항목을 입력하세요">
						</div>
						<div class="offset-md-1 col-md-11 mb-2">
							<input type="text" class="form-control vote-item"
								id="vote-item-2" name="voteContent2" placeholder="2. 항목을 입력하세요">
						</div>
						<!-- 여기서 name 추가할 때 값 똑같이 해도 됨 배열로 다 가져갈 수 있음 -->
						<div class="offset-md-1 col-md-11 mb-2">
							<button id="addItemBtn" type="button" class="btn btn-primary">+항목추가</button>
						</div>
					</div>
					<button type="submit" class="btn btn-sm btn-success">등록하기</button>
				</form>
			</div>



		</div>
		<!-- div hide  -->




		</div>
		<!-- container div -->




		</div>
	</section>
	<jsp:include page="../common/footer.jsp"></jsp:include>



</body>
</html>