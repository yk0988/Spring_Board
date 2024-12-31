<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class='page-header'>Board Modify</h1>
    </div>
</div>

<!-- row -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Modify</div>
            <!-- panel-heading -->
            <div class="panel-body">
                <form role="form" action="/board/modify" method="post">
                    <input type="hidden" name="pageNum" value="${cri.pageNum}">
                    <input type="hidden" name="amount" value="${cri.amount}">
                    <input type="hidden" name="type" value="${cri.type}">
                    <input type="hidden" name="keyword" value="${cri.keyword}">

                    <div class="form-group">
                        <label>Bno</label>
                        <input class="form-control" name="bno" value="${board.bno}" readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name="title" value="${board.title}">
                    </div>

                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name="content">${board.content}</textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name="writer" value="${board.writer}" readonly="readonly">
                    </div>

                    <button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                    <button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
                    <button type="submit" data-oper="list" class="btn btn-info">List</button>
                </form>
            </div>
            <!-- panel-body -->
        </div>
        <!-- panel -->
    </div>
</div>
<!-- row -->

<script type="text/javascript">
    $(document).ready(function() {
        var formObj = $("form");

        $('button').on("click", function(e) {
            e.preventDefault();  // 기본 폼 제출 방지

            var operation = $(this).data("oper");
            
            console.log(operation);
            
            if (operation === 'remove') {
                formObj.attr("action", "/board/remove");  // Remove 작업 처리
            } else if (operation === 'list') {
            	
            	 var currentPage = $("input[name='pageNum']").val();  // 현재 페이지 번호
            	    
            	 
            	//move list
            	  
                formObj.attr("action", "/board/list").attr("method", "get");  // List 페이지로 이동
                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTag = $("input[name='type']").clone();

                formObj.empty();  // 폼 내용 비우기

                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTag);
            }

            formObj.submit();  // 폼 제출
        });
    });
</script>

<%@ include file="../include/footer.jsp" %>
