package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import kr.board.entity.Board;

@Mapper
public interface BoardMapper {
 
	List<Board> getLists();
	public void boardInsert(Board vo);
	Board boardContent(int idx);
	void boardDelete(int idx);
	void boardUpdate(Board vo);
	
	@Update("update myboard set count=count+1 where idx=#{idx}")
	void boardCount(int idx);
}
