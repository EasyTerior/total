package kr.spring.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.spring.entity.Board;
import kr.spring.entity.Comment;
import kr.spring.mapper.BoardMapper;
import kr.spring.mapper.CommentMapper;

@RequestMapping("/board")
@RestController
public class BoardRestController {

	@Autowired
	private BoardMapper boardMapper;
	@Autowired
	private CommentMapper commentMapper;

	// 게시글 전체 리스트 보기 (비동기) 요청 URL - /boardList.do
	@GetMapping("/all")
	public List<Board> boardList() {
		List<Board> list = boardMapper.boardList();
		return list; // JSON Object → JSON Array로 return
	}

	// 댓글 리스트 보기
	@GetMapping("/allComment")
	public List<Comment> commentList() {
		List<Comment> list = commentMapper.commentList();
		System.out.println(list); //담겨져있음
		return list;
	}

	// 게시글 삭제 기능 : (비동기) 요청 URL - /boardDelete.do
	// @GetMapping("/boardDelete.do") // type을 GET 에서 DELETE로 바꿨으니 맞춰야 함.
	@DeleteMapping("/{idx}")
	// public void boardDelete(@RequestParam("idx") int idx) { // RestController 에서
	// @ResonseBody 삭제
	public void boardDelete(@PathVariable("idx") int idx) {
		boardMapper.boardDelete(idx);
	}

	// 게시글 수정하기 기능 : (비동기) 요청 URL - /boardUpdate.do
	// @PostMapping("/boardUpdate.do") // RestController 에서 @ResonseBody 삭제
	// public void boardUpdate(Board b) { // 기본 생성자가 있어야 하고 setter 있어야 함.
	@PutMapping("/update")
	public void boardUpdate(@RequestBody Board b) { // Board 객체로 묶기 위해 @RequestBody 필수
		boardMapper.boardUpdate(b);
	}

	// 게시글 조회수 올리는 기능 : (비동기) 요청 URL - /boardCount.do
	// @GetMapping("/boardCount.do") // RestController 에서 @ResonseBody 삭제
	// public void boardCount(@RequestParam("idx") int idx) {
	/*
	 * @PutMapping("/count/{idx}") public void boardCount(@PathVariable("idx") int
	 * idx) { boardMapper.boardCount(idx); }
	 */

	// 댓글 DB 등록
	@PostMapping("/comment")
	public String addComment(Comment comment) {

		try {
			commentMapper.comment(comment);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}

	@PutMapping("/count1")
	public void buttonCount1(int boardID) {
		 boardMapper.buttonCount1(boardID); 
	}

	@PutMapping("/count2")
	public void buttonCount2(int boardID) {
		boardMapper.buttonCount2(boardID);
	}

}
