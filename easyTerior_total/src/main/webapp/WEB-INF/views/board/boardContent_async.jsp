<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%-- JSTL --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	
</script>
<script>
	//토큰 이름과 값 설정
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
</script>
<style>
.image-container {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
}

.image-container img {
	max-width: 80%;
	max-height: 80%;
	object-fit: contain;
}

.custom-btn {
	padding: 12px 24px; /* Adjust the padding to change the button size */
	margin: 10px;
	margin-right: 50px;
	font-size: 18px;
	width: 200px;
	height: 75px;
	border: none;
	color: white;
}

.custom-btn:nth-child(1) {
	background-color: skyblue;
	/* Set background color for the first button */
}

.custom-btn:nth-child(2) {
	background-color: skyblue;
	/* Set background color for the second button */
}

.custom-btn:nth-of-type(3) {
	background-color: skyblue;
}

.custom-btn:nth-of-type(4) {
	background-color: skyblue;
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

.image-container img {
	width: 100%;
	height: auto;
	max-width: 650px; /* Adjust the max-width as needed */
}

.text-color {
	color: white;
}
</style>
</head>
<body>
	<main class="main">
		<jsp:include page="../common/header.jsp"></jsp:include>
		<jsp:include page="../common/submenu.jsp"></jsp:include>
		<section class="fixed-top container-fluid overflow-auto h-100"
			style="margin: 137px 0 56px 0; padding: 0 0 400px 0;">
			<h1 class="text-center mb-3 fw-bold" style="margin-top: 30px;">글
				상세</h1>
			<!-- 실질 컨텐츠 위치 -->
			<input type="hidden" name="boardID" value="${board.boardID }">
			<input type="hidden" name="memID" value="${board.memID }">
			<div class="container px-5">
				<br>
				<div class="row">
					<div class="col-md-12 text-end">
						<div class="d-flex justify-content-end align-items-center">
							<p class="me-3">
								<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss"
									value="${board.createdAt}" />
							</p>
							<p>작성자 : ${board.memID}</p>

						</div>
					</div>
				</div>




				<div class="d-flex justify-content-end align-items-center">
					<a href="${contextPath }/boardList.do"><button
							class="btn btn-primary">목록으로</button></a>
				</div>
				<h3 class="fw-bold">${board.title}</h3>
				<hr>
				<!-- 이미지 없을 때 예외처리 -->
				<c:if test="${not empty board.boardImage}">
					<div class="row">
						<c:choose>
							<c:when test="${not empty board.boardImage2}">
								<div class="col-md-6">
									<div class="image-container">
										<img
											src="${pageContext.request.contextPath}/resources/images/upload/${board.boardImage}"
											alt="image">
									</div>
								</div>
								<div class="col-md-6">
									<div class="image-container">
										<img
											src="${pageContext.request.contextPath}/resources/images/upload/${board.boardImage2}"
											alt="image">
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="col-md-6 offset-md-3">
									<div class="image-container">
										<img
											src="${pageContext.request.contextPath}/resources/images/upload/${board.boardImage}"
											alt="image">
									</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</c:if>
				<c:if test="${not empty board.boardImage3}">
					<div class="row">
						<c:choose>
							<c:when test="${not empty board.boardImage4}">
								<div class="col-md-6">
									<div class="image-container">
										<img
											src="${pageContext.request.contextPath}/resources/images/upload/${board.boardImage3}"
											alt="image">
									</div>
								</div>
								<div class="col-md-6">
									<div class="image-container">
										<img
											src="${pageContext.request.contextPath}/resources/images/upload/${board.boardImage4}"
											alt="image">
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="col-md-6 offset-md-3">
									<div class="image-container">
										<img
											src="${pageContext.request.contextPath}/resources/images/upload/${board.boardImage3}"
											alt="image">
									</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</c:if>



				<h5>${board.content}</h5>


				<!-- 투표 항목 없으면 출력 안함 -->
				<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

				<div class="d-flex justify-content-center align-items-center mt-5">
					<c:if test="${not empty board.voteContent1}">
						<a href="/controller/buttonCount.do/${board.boardID}"
							class="btn custom-btn"> <span
							class="btn-text-resize text-color" style="font-size: 20px;">
								${board.voteContent1}<br> <c:set var="totalCount"
									value="${board.count1 + board.count2 + board.count3 + board.count4}" />
								<c:set var="percentage1"
									value="${totalCount == 0 ? 0 : (board.count1 / totalCount) * 100}" />
								<c:choose>
									<c:when test="${percentage1 eq 0}">
                        0.00%
                    </c:when>
									<c:otherwise>
										<fmt:formatNumber value="${percentage1}" pattern="0.00" />
									</c:otherwise>
								</c:choose> <c:if test="${percentage1 ne 0}">
                    (%)
                </c:if>
						</span>
						</a>
					</c:if>
					<c:if test="${not empty board.voteContent2}">
						<a href="/controller/buttonCount2.do/${board.boardID}"
							class="btn custom-btn"> <span
							class="btn-text-resize text-color" style="font-size: 20px;">
								${board.voteContent2}<br> <c:set var="percentage2"
									value="${totalCount == 0 ? 0 : (board.count2 / totalCount) * 100}" />
								<c:choose>
									<c:when test="${percentage2 eq 0}">
                        0.00%
                    </c:when>
									<c:otherwise>
										<fmt:formatNumber value="${percentage2}" pattern="0.00" />
									</c:otherwise>
								</c:choose> <c:if test="${percentage2 ne 0}">
                    (%)
                </c:if>
						</span>
						</a>
					</c:if>
					<c:if test="${not empty board.voteContent3}">
						<a href="/controller/buttonCount3.do/${board.boardID}"
							class="btn custom-btn"> <span
							class="btn-text-resize text-color" style="font-size: 20px;">
								${board.voteContent3}<br> <c:set var="percentage3"
									value="${totalCount == 0 ? 0 : (board.count3 / totalCount) * 100}" />
								<c:choose>
									<c:when test="${percentage3 eq 0}">
                        0.00%
                    </c:when>
									<c:otherwise>
										<fmt:formatNumber value="${percentage3}" pattern="0.00" />
									</c:otherwise>
								</c:choose> <c:if test="${percentage3 ne 0}">
                    (%)
                </c:if>
						</span>
						</a>
					</c:if>
					<c:if test="${not empty board.voteContent4}">
						<a href="/controller/buttonCount4.do/${board.boardID}"
							class="btn custom-btn"> <span
							class="btn-text-resize text-color" style="font-size: 20px;">
								${board.voteContent4}<br> <c:set var="percentage4"
									value="${totalCount == 0 ? 0 : (board.count4 / totalCount) * 100}" />
								<c:choose>
									<c:when test="${percentage4 eq 0}">
                        0.00%
                    </c:when>
									<c:otherwise>
										<fmt:formatNumber value="${percentage4}" pattern="0.00" />
									</c:otherwise>
								</c:choose> <c:if test="${percentage4 ne 0}">
                    (%)
                </c:if>
						</span>
						</a>
					</c:if>
				</div>




				<hr>
				<!-- 수정,삭제 -->
				<c:set var="sessionMemID" value="${sessionScope.memResult.memID}" />
				<c:set var="boardID" value="${board.memID}" />

				<c:if test="${sessionMemID eq boardID}">
					<div class="d-flex justify-content-end">
						<a href="/controller/boardDelete.do/${board.boardID}"
							class="btn btn-danger">삭제</a>
					</div>

				</c:if>
				<jsp:include page="../board/comment_async.jsp"></jsp:include>
			</div>
		</section>
		<jsp:include page="../common/footer.jsp"></jsp:include>
	</main>
</body>
</html>