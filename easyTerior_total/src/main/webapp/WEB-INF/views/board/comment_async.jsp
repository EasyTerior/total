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
<script type="text/javascript">
	//토큰 이름과 값 설정
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	//처음에 댓글 리스트 불러오기
	$(document).ready(function() {
		loadComment();
	});

	//댓글 db에 등록하기
	function fn_comment() {

		var data = $("#commentForm").serialize();
		console.log(data);

		$.ajax({
			//  경로를 이렇게 해야 DB 테이블에 접근 가능
			url : "/controller/board/comment",
			type : "post",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data : data,
			success : function(data) {
				if (data == "success") {
					loadComment();
					$("#commentContent").val("");
				}
			},
			error : function(request, status, error) {
				console.log("404");
			}

		});
	}

	//댓글 불러오기
	function loadComment() {

		$.ajax({
			url : "${contextPath}/board/allComment", //경로는 맞음
			type : "get",
			dataType : "json",
			//data : $("#commentForm").serialize(),
			//contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			success : makeComment,
				
			error : function() {
				alert("error..f.");
			}

		});
	}

	//댓글 리스트 불러오기
	function makeComment(data) {

		var html = "";
		var boardID = $("#boardID").val();

		if (data.length > 0) {
			for (var i = 0; i < data.length; i++) {
				var model = data[i];
				console.log(model);

				//boardID에 맞게 출력됨
				if (model.boardID == boardID) {
					html += "<div>";
					html += "<div><table class='table'><h6><strong>"
							+ data[i].memID + "</strong></h6>";
					html += data[i].commentContent + "<tr><td></td></tr>";
					html += "</table></div>";
					html += "</div>";
				}
			}
		} else {
			html += "<div>";
			html += "<div><table class='table'><h6><strong>등록된 댓글이 없습니다.</strong></h6>";
			html += "</table></div>";
			html += "</div>";

		}
		$("#commentList").html(html);
	}
</script>
</head>
<body>
	<div class="container">
		<div>
			<div>
				<span><strong>Comments</strong></span> <span id="cCnt"></span>
			</div>
			<div>
				<form id="commentForm" class="mt-5" method="post">
					<input type="hidden" id="boardID" name="boardID"
						value="${board.boardID}" /> <input type="hidden" id="memID"
						name="memID" value="${sessionScope.memResult.memID}" />

					<table class="table">
						<tr>
							<td><c:if test="${not empty sessionScope.memResult}">
									<textarea style="width: 1100px; margin-top: 0;" rows="3"
										cols="30" id="commentContent" name="commentContent"
										placeholder="댓글을 입력하세요"></textarea>

									<br>
									<div>


										<div class="text-center">
											<a href='#' onClick="fn_comment()"
												class="btn pull-right btn-success float-start">등록</a>
										</div>
								</c:if>

								</div></td>
						</tr>
					</table>
				</form>
			</div>


			<div class="container">
				<form id="commentListForm" name="commentListForm" method="post">
					<div id="commentList"></div>
				</form>
			</div>
		</div>

	</div>

	</div>



</body>

</html>
