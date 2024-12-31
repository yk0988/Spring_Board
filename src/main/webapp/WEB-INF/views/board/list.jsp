<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<h1 class="page-header">Tables</h1>

<div class="panel panel-default">
  <div class="panel-heading">
    Board List
    <button id="regBtn" type="button" class="btn btn-xs pull-right btn-info">Register New Board</button>
  </div>
  <!-- 검색조건 -->
	<div class='row' style="margin-left: 5px; margin-top: 10px;">
        <div class="col-lg-12">
            <form id='searchForm' action="/board/list" method="get">
                <select name="type">
                    <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}" /> >--</option>
                    <option value="T" <c:out value="${pageMaker.cri.type == 'T' ? 'selected' : ''}" /> >제목</option>
                    <option value="C" <c:out value="${pageMaker.cri.type == 'C' ? 'selected' : ''}" /> >내용</option>
                    <option value="W" <c:out value="${pageMaker.cri.type == 'W' ? 'selected' : ''}" /> >작성자</option>
                    <option value="TC" <c:out value="${pageMaker.cri.type == 'TC' ? 'selected' : ''}" /> >제목 내용</option>
                    <option value="TW" <c:out value="${pageMaker.cri.type == 'TW' ? 'selected' : ''}" /> >제목 작성자</option>
                    <option value="TWC" <c:out value="${pageMaker.cri.type == 'TWC' ? 'selected' : ''}" /> >제목 내용 작성자</option>
                </select>            
                <input type="text" name="keyword" value="<c:out value='${pageMaker.cri.keyword}' />" style="padding: 2px; font-size: 10px; height: auto;" /> 
                <input type="hidden" name="pageNum" value="<c:out value='${pageMaker.cri.pageNum}' />" /> 
                <input type="hidden" name="amount" value="<c:out value='${pageMaker.cri.amount}' />" />
                <button class="btn btn-default btn-lg w-100" style="padding: 5px 10px; font-size: 10px; width: auto; height: auto;">Search</button>

            </form>    
        </div>
    </div>
  <div class="panel-body">
    <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">
      <thead>
        <tr>
          <th>번호</th>
          <th>제목</th>
          <th>작성자</th>
          <th>작성일</th>
          <th>수정일</th>
        </tr>
      </thead>
      <c:forEach items="${list}" var="board">
        <tr>
          <td><c:out value="${board.bno}" /></td>
          <td>
          	<a class='move' href='<c:out value="${board.bno}"/>'>
          		<c:out value="${board.title}"/>
          	</a>
          </td>
          <td>${board.writer}</td>
          <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}" /></td>
          <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" /></td>
        </tr>
      </c:forEach>
    </table>
    <div class='pull-right'>
		<ul class="pagination">
		    <c:if test="${pageMaker.prev}">
		        <li class="paginate_button previous">
		            <a href="${pageMaker.startPage-1}">previous</a>
		        </li>
		    </c:if>
		    
		    <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
		        <li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : ''}">
		            <a href="${num}">${num}</a>
		        </li>
		    </c:forEach>
		    
		    <c:if test="${pageMaker.next}">
		        <li class="paginate_button next">
		            <a href="${pageMaker.endPage+1}">next</a>
		        </li>
		    </c:if>
		</ul>
	</div>
    
    <form id='actionForm' action='/board/list' method='get'>
      <input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
      <input type='hidden' name="amount" value='${pageMaker.cri.amount}'>
      <input type='hidden' name='type' value='${pageMaker.cri.type}'>
      <input type='hidden' name='keyword' value='${pageMaker.cri.keyword}'>
    </form>
    
    <!-- The Modal -->
    <div class="modal" id="myModal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">Modal Heading</h4>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body">
	        <!-- 메시지를 JSTL로 표시 -->
	        <c:choose>
	          <c:when test="${result == 'success'}">성공!</c:when>
	          <c:when test="${result == 'failure'}">실패</c:when>
	          <c:otherwise>처리가 완료되었습니다.</c:otherwise>
	        </c:choose>
	      </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <!-- End Modal -->
  </div>
</div>

<!-- JavaScript -->
<script>
$(document).ready(function() {
    var result = '<c:out value="${result}"/>'; 

    checkModal(result);

    history.replaceState({}, null, null);

    function checkModal(result) {
        if (result === '' || history.state) {
            return;
        }
        if (parseInt(result) > 0) {
            $(".modal_body").html("게시글 " + parseInt(result) + "번 등록!");
        }
        $("#myModal").modal("show");
    }

    $("#regBtn").on("click", function() {
        self.location = "/board/register";
    });

    var actionForm = $("#actionForm");

    $(".paginate_button a").on("click", function(e) {
        e.preventDefault(); 

        actionForm.find("input[name='pageNum']").val($(this).attr("href")); 
        actionForm.submit();
    });
    
	var searchForm = $("#searchForm");
	
	$("#searchForm button").on("click", function(e){
		if(!searchForm.find("option:selected").val()){
			alert("검색종류를 선택하세요");
			return false;
		}
	
		if(!searchForm.find("input[name='keyword']").val()){
			alert("키워드를 입력하세요");
			return false;
		}
		searchForm.find("input[name='pageNum']").val("1");
		e.preventDefault();
		
		searchForm.submit();
		
	});
	
	$(".move").on("click", function(e) {
		e.preventDefault();  // 기본 동작을 방지
		actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr("href")+"'>");
		actionForm.attr("action","/board/get");
		actionForm.submit();
		
	});

});
</script>

<%@ include file="../include/footer.jsp"%>
