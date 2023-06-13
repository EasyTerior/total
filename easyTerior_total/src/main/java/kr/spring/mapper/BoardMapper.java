package kr.spring.mapper;

import java.io.File;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import kr.spring.entity.Board;

@Mapper
public interface BoardMapper {
	
	// 게시글 리스트 가져오는 기능
	public List<Board> boardList(); // 반환 타입 List<Board> 명시 하고 id로서 쓸 메서드명
	
	// 게시글 입력 기능
	public void boardInsert(Board board);
	
	// 게시글 상세 보기 기능
	public Board boardContent(int boardID);

	// 게시글 삭제 기능
	public void boardDelete(int boardID);

	// 게시글 업데이트 기능
	public void boardUpdate(Board board);
	
	// 버튼 조회수(실패)
	@Update("update Board set count1 = count1 + 1 where boardID = #{boardID}") 
	public void buttonCount1(int boardID);
	
	@Update("update Board set count2 = count2 + 1 where boardID = #{boardID}") 
	public void buttonCount2(int boardID);
	
	
}
