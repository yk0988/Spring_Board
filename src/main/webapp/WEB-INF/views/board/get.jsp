<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp" %>

<!-- Board Read Section -->
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Read</div>
            <div class="panel-body">
                <!-- Board Information -->
                <div class="form-group">
                    <label>Bno</label>
                    <input class="form-control" name="bno" value="${board.bno}" readonly="readonly">
                </div>

                <!-- Form for Modifying Board -->
                <form id="operForm" action="/board/modify" method="get">
                    <input type="hidden" id="bno" name="bno" value="${board.bno}">
                    <input type="hidden" name="pageNum" value="${cri.pageNum}">
                    <input type="hidden" name="amount" value="${cri.amount}">
                    <input type="hidden" name="type" value="${cri.type}">
                    <input type="hidden" name="keyword" value="${cri.keyword}">
                </form>

                <!-- Title and Content -->
                <div class="form-group">
                    <label>Title</label>
                    <input class="form-control" name="title" value="${board.title}" readonly="readonly">
                </div>

                <div class="form-group">
                    <label>Text area</label>
                    <textarea class="form-control" rows="3" name="content" readonly="readonly">${board.content}</textarea>
                </div>

                <!-- Writer Information -->
                <div class="form-group">
                    <label>Writer</label>
                    <input class="form-control" name="writer" value="${board.writer}" readonly="readonly">
                </div>

                <!-- Buttons for Modify and List -->
                <button data-oper="modify" class="btn btn-default btn-success">Modify</button>
                <button data-oper="list" class="btn btn-default btn-info">List</button>
            </div>
        </div>
    </div>
</div>

<!-- Reply Section -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i>Reply
                <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
            </div>
            <ul class="chat">
                <li class="left clearfix" data-rno="12">
                    <div>
                        <div class="header">
                            <strong class="primary-font">user00</strong>
                            <small class="pull-right text-muted">2024-02-05</small>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
        <div class="panel-footer"></div>
    </div>
</div>

<!-- Modal for Reply -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>Reply</label>
                    <input class="form-control" name="reply" value="New Reply!!!!">
                </div>
                <div class="form-group">
                    <label>Replyer</label>
                    <input class="form-control" name="replyer" value="replyer">
                </div>
                <div class="form-group">
                    <label>Reply Date</label>
                    <input class="form-control" name="replyDate" value="2018-01-01 13:13">
                </div>
            </div>
            <div class="modal-footer">
                <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
                <button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">
$(document).ready(function() {
    var bnoValue = '${board.bno}';
    var replyUL = $(".chat");

    // 댓글 목록을 가져오는 함수
    function showList(page) {
        replyService.getList({ bno: bnoValue, page: page || 1 }, function(list) {
            console.log(list);
            var str = "";

            if (list == null || list.length == 0) {
                replyUL.html("");
                return;
            }

            for (var i = 0, len = list.length || 0; i < len; i++) {
                str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
                str += "<div><div class='header'><strong class='primary-font'>[" + list[i].rno + "] " + list[i].replyer + "</strong>";
                str += "<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
                str += "<p>" + list[i].reply + "</p>";

            }

            replyUL.html(str);

            // 수정 버튼 클릭 이벤트 핸들러
            $(".editBtn").on("click", function() {
                var rno = $(this).closest("li").data("rno"); // 댓글 번호
                var replyText = $(this).closest("li").find("p").text(); // 댓글 내용
                var replyer = $(this).closest("li").find(".primary-font").text().replace(/^\[\d+\]\s/, '');  // 댓글 작성자

                // 모달에 댓글 정보 넣기
                modal.find("input[name='reply']").val(replyText);  // 댓글 내용
                modal.find("input[name='replyer']").val(replyer);  // 댓글 작성자
                modal.data("rno", rno);  // 모달에 rno 설정

                // 모달을 띄우기
                $(".modal").modal("show");
            });
        });
    }

    showList(1);

    // Modal 관련 변수
    var modal = $(".modal");
    var modalInputReply = modal.find("input[name='reply']");
    var modalInputReplyer = modal.find("input[name='replyer']");
    var modalInputReplyDate = modal.find("input[name='replyDate']");

    var modalModBtn = $("#modalModBtn");
    var modalRemoveBtn = $("#modalRemoveBtn");
    var modalRegisterBtn = $("#modalRegisterBtn");

    // 새 댓글 추가 버튼 클릭 시
    $("#addReplyBtn").on("click", function(e) {
        modal.find("input").val("");  // 모든 input 필드 초기화
        modalInputReplyDate.closest("div").hide();  // 날짜 필드 숨기기
        modal.find("button[id !='modalCloseBtn']").hide();  // 닫기 버튼을 제외한 버튼 숨기기
        modalRegisterBtn.show();  // 등록 버튼만 보이게 하기
        $(".modal").modal("show");  // 모달 창 열기
    });
    
    $(".chat").on("click", "li", function(e){
		var rno = $(this).data("rno");
		replyService.get(rno, function(reply){
	        modalInputReply.val(reply.reply);
	        modalInputReplyer
		        .val(reply.replyer)
		        .attr("readonly","readonly");;
	        modalInputReplyDate
		        .val(replyService.displayTime( reply.replyDate))
		        .attr("readonly","readonly");
	        modal.data("rno", reply.rno);
	        
	        modal.find("button[id !='modalCloseBtn']").hide();
	        modalModBtn.show();
	        modalRemoveBtn.show();
	        
	        $(".modal").modal("show");
	    });
  	});

    // 댓글 등록 버튼 클릭 시
    modalRegisterBtn.on("click", function(e) {
        var reply = {
            reply: modalInputReply.val(),
            replyer: modalInputReplyer.val(),
            bno: bnoValue
        };

        replyService.add(reply, function(result) {
            alert(result);
            modal.find("input").val("");  // 입력 필드 초기화
            modal.modal("hide");  // 모달 닫기
            showList(1);  // 댓글 목록 새로 고침
        });
    });

    // 댓글 수정 버튼 클릭 시
    modalModBtn.on("click", function() {
        var reply = { 
            rno: modal.data("rno"), // 댓글 번호
            reply: modalInputReply.val() // 댓글 내용
        };

        replyService.update(reply, function(result) {
            alert(result);  // 서버 응답 알림
            modal.modal("hide");  // 모달 닫기
            showList(1);  // 댓글 목록을 새로 고침
        });
    });

    // 댓글 삭제 버튼 클릭 시
    modalRemoveBtn.on("click", function() {
        var rno = modal.data("rno");

        replyService.remove(rno, function(result) {
            alert(result);
            modal.modal("hide");
            showList(1);  // 댓글 목록 새로 고침
        });
    });
    
    $('#modalCloseBtn').click(function() {
        $('#myModal').modal('hide');
    });

    // Modify 버튼 클릭 시
    var operForm = $("#operForm");
    $("button[data-oper='modify']").on("click", function(e) {
        e.preventDefault();  // 기본 폼 제출을 방지
        operForm.attr("action", "/board/modify");
        operForm.submit();  // 폼 제출
    });

    // List 버튼 클릭 시
    $("button[data-oper='list']").on("click", function(e) {
        operForm.find("#bno").remove();  // bno 필드를 제거
        operForm.attr("action", "/board/list");  // List 페이지로 이동
        operForm.submit();  // 폼 제출
    });
    
    
});
</script>

<%@ include file="../include/footer.jsp" %>
