package com.company.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class PageDTO {
	
	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private Criteria cri;
    private int total;
    
    public PageDTO(Criteria cri,int total) {
    	
    	this.cri = cri;
    	this.total = total;
    	
    	this.endPage = (int) (Math.ceil(cri.getPageNum()/10.0))*10;
    	this.startPage = this.endPage - 9;
    	
    	int realEnd = (int) (Math.ceil((double)total/cri.getAmount()));
    	
    	if(realEnd < this.endPage) {
    		this.endPage = realEnd;
    	}
    	
    	this.prev = this.startPage > 1;
    	this.next = this.endPage < realEnd;
    		
    }
}
