package com.company.service;

import java.util.List;

import com.company.domain.BoardVO;  // BoardVO 클래스가 필요합니다.
import com.company.domain.Criteria;

public interface BoardService {

    // 매개변수 이름을 소문자로 변경
    public void register(BoardVO board);
    
    public BoardVO get(Long bno);
    
    public boolean modify(BoardVO board);
    
    public boolean remove(Long bno);

    public List<BoardVO> getList();
    
    public List<BoardVO> getList(Criteria criteria);

	public int getTotal(Criteria criteria);
}
