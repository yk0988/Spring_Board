package com.company.mapper;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.company.domain.Criteria;
import com.company.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO vo);
    public ReplyVO read(Long rno);
	public int delete(Long rno);//확인요망
	public int update(ReplyVO reply);
	
	public List<ReplyVO> getListWithPaging(
									@Param("cri") Criteria cri,
									@Param("bno") Long bno);
}
