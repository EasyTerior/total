package kr.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import kr.spring.entity.Comment;

@Mapper
public interface CommentMapper {

	// 댓글 리스트 불러오기 기능
	public List<Comment> commentList();

	// 댓글 등록 기능
	public void comment(Comment comment);

}
