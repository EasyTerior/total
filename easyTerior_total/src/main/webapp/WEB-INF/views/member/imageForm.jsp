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
rel="stylesheet" /><!-- icons --><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		// 프로필 이미지 업로드 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "실패 메세지"}){ 
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-warning");
			}
			$("#myModal").modal("show");
		}
	});
	
</script>

<title>imageForm.do</title>
</head>
<body>
<section class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	
	<section class="fixed-top container-fluid overflow-auto" style="height:100%;margin:137px 0 0;padding:56px 0 0 100px;">
	<div class="container-fluid" style="min-height:100vh;margin-bottom: 200px;">
	
	<div class="container-fluid">
		<div class="mb-5"><h2 class="text-center">프로필 이미지 수정</h2></div>
			<div class="row">
				<div class="py-5 bg-light">
					<form action="${ contextPath }/imageUpload.do?${_csrf.parameterName}=${ _csrf.token }" method="POST" class="form container" enctype="multipart/form-data">
						<!-- CSRF token -->
						<input type="hidden" name="${ _csrf.parameterName }" value="${ _csrf.token }" />
						<input type="hidden" name="memID" value="${ memResult.memID }" />
						<table class="table table-bordered text-center">
						<div class="mb-3 row justify-content-md-center">
							<c:if test="${ memResult.memProfile ne ''}">
					      		<img alt="${memResult.memProfile}" src="${ contextPath }/resources/profile/${memResult.memProfile}" class="rounded-circle align-middle" style="width:200px; height:200px;border:1px solid #d6d6d6; " />
					      	</c:if>
					      	<c:if test="${ memResult.memProfile eq ''}">
					      		<img alt="${memResult.memProfile}" src="${ contextPath }/resources/images/common/person.png" class="rounded-circle align-middle" style="width:200px;height:200px;border:1px solid #d6d6d6; " />
					      	</c:if>
					      	<p class="fs-5 fw-bold text-center">${ memResult.memID }님 환영합니다.</p>
					      	
						</div>
							<tbody>
								<tr>
									<th class="align-middle" style="width:150px;"><label for="memProfile">사진 업로드</label></th>
									<td class="align-middle">
										<input type="file" name="memProfile" id="memProfile" class="form-control" />
									</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="2" class="pull-right">
										<p id="passMessage" class="text-center fw-bold"></p>
										<button type="submit" class="btn btn-sm btn-primary">저장하기</button>
										<button type="reset" class="btn btn-sm btn-warning">취소하기</button>
									</td>
								</tr>
							</tfoot>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>


	</section>
	<jsp:include page="../common/footer.jsp"></jsp:include>
	
</section>
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
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div>
</body>
</html>