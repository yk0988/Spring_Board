package com.company.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;  // MediaType 임포트
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.company.domain.Criteria;
import com.company.domain.ReplyVO;
import com.company.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.extern.log4j.Log4j;

@RestController  // RESTful API 컨트롤러로 지정
@RequestMapping("/replies/*")  // '/replies' URL 경로로 시작하는 요청을 처리
@AllArgsConstructor  // 모든 필드를 포함하는 생성자 자동 생성
@NoArgsConstructor   // 기본 생성자 자동 생성
@Log4j  // Log4j 로깅 기능 활성화
public class ReplyController {

	@Autowired  // Spring이 ReplyService 객체를 자동으로 주입하도록 지정
	private ReplyService service;

	@RequestMapping(
			method = RequestMethod.PUT,
			value = "/{rno}",
			consumes = "application/json", produces = {
			MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> update(
			@RequestBody ReplyVO vo) {
		log.info("ReplyVO: " + vo);  // 로그에 요청받은 댓글 객체 정보 출력

		int insertCount = service.modify(vo);
		return insertCount == 1 ?
			new ResponseEntity<String>("success", HttpStatus.OK) :
			new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping("/test")  // '/replies/test' 경로로 GET 요청을 처리
	public String testReply() {
		return "test";  // 요청에 대한 응답으로 "test" 문자열을 반환
	}

	
	// 새 댓글을 등록하는 POST 메소드
	@PostMapping(value = "/new", consumes = "application/json", produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		log.info("ReplyVO: " + vo);  // 로그에 요청받은 댓글 객체 정보 출력

		int insertCount = service.register(vo);
		return insertCount == 1 ?
				new ResponseEntity<String>("success", HttpStatus.OK) :
				new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 댓글 목록을 페이징 처리하여 가져오는 GET 메소드
	@GetMapping(value = "/pages/{bno}/{page}", produces = {MediaType.APPLICATION_JSON_VALUE})  // 수정된 부분
	public ResponseEntity<List<ReplyVO>> getList(
			@PathVariable("bno") Long bno,  // URL 경로에서 bno 값 추출
			@PathVariable("page") int page){  // URL 경로에서 page 값 추출
		
		log.info("getList..........");
		Criteria cri =  new Criteria(page, 10);  // 페이지 번호와 페이지당 댓글 수 설정
		
		// 서비스 계층에서 댓글 목록을 가져와서 HTTP 200 OK 응답으로 반환
		var replies = service.getList(cri, bno);
		return new ResponseEntity<List<ReplyVO>>(replies, HttpStatus.OK);
	}
	
	@GetMapping(value = "/{rno}", 
			produces = { MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {

		log.info("get: " + rno);
		ReplyVO reply = service.get(rno);
		if(reply != null) {
			return new ResponseEntity<>(reply, HttpStatus.OK);	
		}
		return new ResponseEntity<>(HttpStatus.NOT_FOUND);
	}
			
	@DeleteMapping(value = "/{rno}", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {

		log.info("remove: " + rno);

		return service.remove(rno) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);

	
		
		
	}
	

	
	
}
