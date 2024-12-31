package com.company.controller;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;  // @Autowired 추가
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.company.domain.Criteria;
import com.company.domain.ReplyVO;
import com.company.mapper.ReplyMapper;

import lombok.extern.log4j.Log4j;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {

	@Autowired
	private ReplyMapper mapper;

	// 내가 가지고있는 tbl_board있는 bno값 5개 저장
	private Long[] bnoArr = { 3323L, 3322L, 3316L, 3313L, 3312L };

	@Test
	public void testInsert() {
		IntStream.rangeClosed(1, 10).forEach(i -> {
			ReplyVO vo = new ReplyVO();
			vo.setBno(bnoArr[i % 5]); // i%5 => 0,1,2,3,4
			vo.setReply("댓글 테스트" + i);
			vo.setReplyer("replyer");
			mapper.insert(vo);

		});
	}


	@Test
	public void testRead() {
		
		ReplyVO vo = mapper.read(6L);  //6번만 가져와
		log.info(vo);
	}
	
	@Test
	public void testDelete() {
		
		int result = mapper.delete(3L);  //3번만 삭제
		log.info(result);
	}


	@Test
	public void testUpdate() {
		
		ReplyVO vo = new ReplyVO();
		
		vo.setRno(1L);
		vo.setReply("1번만수정");
		
		mapper.update(vo);
	}
	@Test
	
	public void testList() {
	    // 1. Criteria 객체 생성
	    Criteria cri = new Criteria(2, 5);

	    // 2. 페이징된 댓글 목록 가져오기
	    List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);

	    // 3. 가져온 댓글 목록 출력
	    replies.forEach(reply -> log.info(reply));
	}

}