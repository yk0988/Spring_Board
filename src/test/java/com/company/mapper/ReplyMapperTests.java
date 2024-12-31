package com.company.mapper;

import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.company.domain.ReplyVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {

	@Autowired
	private ReplyMapper mapper;


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
	public void testInsert2() {
		IntStream.rangeClosed(1, 20).forEach(i->{
			ReplyVO vo = new ReplyVO();
			vo.setBno(bnoArr[0]);  //i%5 => 0,1,2,3,4
			vo.setReply("페이징 테스트"+i);
			vo.setReplyer("페이징");
			mapper.insert(vo);
			
		});
	}
}