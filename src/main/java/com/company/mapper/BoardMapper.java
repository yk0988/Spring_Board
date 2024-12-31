package com.company.mapper;

import java.util.List;
import java.util.Map;

import com.company.domain.BoardVO;
import com.company.domain.Criteria;

public interface BoardMapper {

	//@Select("select * from tbl_board where bno > 0")
	public List<BoardVO> getList();
    
	public void insert(BoardVO board);
	
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVO board);
	
	public List<BoardVO> getListWithPaging(Criteria cri);

	public int getTotalCount(Criteria cri);

	public List<BoardVO> searchTest(Map<String,Map<String, String>>map);	
}
