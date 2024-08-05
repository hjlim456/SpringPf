package kr.board.controller;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;



@Controller
public class BoardController {
	@Autowired
	BoardMapper boardMapper;
	
	@RequestMapping("/")
	public String main() {
		return "main";
	}
	
	@RequestMapping("/boardList.do")
	@ResponseBody
	public List<Board> boardList(){
		
		List<Board> list =boardMapper.getLists();
		return list; //객체를 리턴한다는것은 json형식으로 변환하여 데이터를 보내겠다는것.
	}
	
	@RequestMapping("/boardInsert.do")
	@ResponseBody //얘 안해주면 error로 떨어짐.
	public void boardInsert(Board vo) {
		boardMapper.boardInsert(vo);
	}
	
	
	@RequestMapping("/boardDelete.do")
	@ResponseBody //얘 안해주면 error로 떨어짐.
	public void boardInsert(@RequestParam("idx")int idx) {
		boardMapper.boardDelete(idx);
	}
	
	@RequestMapping("/boardUpdate.do")
	@ResponseBody
	public void boardUpdate(Board vo) {
		boardMapper.boardUpdate(vo);
	}
	
	@RequestMapping("/boardContent.do")
	@ResponseBody
	public Board boardContent(@RequestParam("idx") int idx) {
		Board vo = boardMapper.boardContent(idx);
		
		return vo;
	}
	
	@RequestMapping("/boardCount.do")
	@ResponseBody
	public Board boardCount(@RequestParam("idx") int idx) {
		boardMapper.boardCount(idx);
		Board vo = boardMapper.boardContent(idx);
		return vo;
		
	}
	
}
