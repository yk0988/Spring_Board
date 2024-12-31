package com.company.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.company.domain.BoardVO;
import com.company.domain.Criteria;
import com.company.domain.PageDTO;
import com.company.service.BoardService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/")
public class BoardController {

    @Autowired
    private BoardService service;

    @GetMapping("/list")
    public void list(Criteria criteria, Model model) {
        log.info("list: " + criteria);
        model.addAttribute("list", service.getList(criteria));
        //model.addAttribute("pageMaker", new PageDTO(criteria, 50));
        
        int total = service.getTotal(criteria);
        
        log.info("total: " + total);
        model.addAttribute("pageMaker", new PageDTO(criteria,total));
    }


    @GetMapping("/register")
    public void register() {
        // 게시글 등록 페이지
    }

    @PostMapping("/register")
    public String register(BoardVO board, RedirectAttributes rttr) {
        log.info("register: " + board);
        service.register(board);
        rttr.addFlashAttribute("result", board.getBno());
        return "redirect:/board/list";
    }
    @GetMapping({"/get", "/modify"})
    public String getOrModify(
            @RequestParam("bno") Long bno,
            @ModelAttribute("cri") Criteria criteria,
            Model model,
            RedirectAttributes rttr, 
            HttpServletRequest request) {
        log.info("/get or modify");

        // 보드가 없으면 /board로 리다이렉트
        BoardVO board = service.get(bno);
        if (board == null) {
        	rttr.addFlashAttribute("result", "failure");
            return "redirect:/board/list"; // /board로 리다이렉트
        }
        model.addAttribute("board", board);
        String uri = request.getRequestURI();
        if (uri.contains("modify")) {
            return "board/modify";  // /modify 뷰 반환
        } else {
            return "board/get";     // /get 뷰 반환
        }
        
    }

    

    @PostMapping("/modify")
    public String modify(BoardVO board, RedirectAttributes rttr, Criteria criteria) {
        log.info("modify" + board);

        // 수정된 게시글이 정상적으로 처리되면
        if (service.modify(board)) {
            rttr.addFlashAttribute("result", "success");
        }

//        // Criteria 객체에서 pageNum, amount, type, keyword를 받아서 추가
        rttr.addFlashAttribute("pageNum", criteria.getPageNum());
        rttr.addFlashAttribute("amount", criteria.getAmount());
        rttr.addFlashAttribute("type", criteria.getType());
        rttr.addFlashAttribute("keyword", criteria.getKeyword());

        // 게시판 목록으로 리다이렉트
        return "redirect:/board/list" + criteria.getListLink();
    }


    @PostMapping("/remove")
    public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria criteria, RedirectAttributes rttr) {
        log.info("remove" + bno);
        if (service.remove(bno)) {
            rttr.addFlashAttribute("result", "success");
             
        }
        
        rttr.addFlashAttribute("pageNum", criteria.getPageNum());
        rttr.addFlashAttribute("amount", criteria.getAmount());
        rttr.addFlashAttribute("type", criteria.getType());
        rttr.addFlashAttribute("keyword", criteria.getKeyword());
        
        return "redirect:/board/list";
    }

}
