package kr.spring.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // public String boardList (Model model)
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping; // @RequestMapping("/boardList.do")
import org.springframework.web.bind.annotation.RequestParam; // @RequestParam 을 통해서 Board 의 하나 혹은 해당에 없는 걸 받을 때 request로 받아서 매개변수 처리
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.spring.entity.Board;
import kr.spring.mapper.BoardMapper;

@Controller
public class BoardController { // 서버 기능들

	@Autowired
	private BoardMapper boardMapper;

	// 게시판 이동
	@RequestMapping("/boardList.do")
	public String boardList(Model model) {

		List<Board> list = boardMapper.boardList();

		model.addAttribute("list", list);

		return "board/board_async";
	}

	// 게시글 상세보기 : (비동기) 요청 URL - /boardContent.do
	// @GetMapping("/boardContent.do")
	@GetMapping("boardContent/{boardID}")
	public String boardContent(@PathVariable("boardID") int boardID, Model model) { // BoardRestController
		Board board = boardMapper.boardContent(boardID);
		model.addAttribute("board", board);
		return "board/boardContent_async";
	}

	// 게시판 업로드

	// 게시판 업로드
	@PostMapping("board/new2")
	public String boardInsert2(@RequestParam(value = "file", required = false) MultipartFile file, Board board,
			HttpServletRequest request) { // RestController

		if (file != null && !file.isEmpty()) {
			String fileRealName = file.getOriginalFilename(); // 파일명을 얻어낼 수 있는 메서드!
			long size = file.getSize(); // 파일 사이즈

			System.out.println("파일명 : " + fileRealName);
			System.out.println("용량크기(byte) : " + size);

			// 서버에 저장할 파일이름 file extension으로 .asp이런식의 확장자 명을 구함
			String fileExtension = fileRealName.substring(fileRealName.lastIndexOf("."), fileRealName.length());
			// 이고관PC 로컬 주소 - 수정해야합니다.
			String uploadFolder = "D:\\total\\easyTerior_total\\src\\main\\webapp\\resources\\images\\upload";

			// 파일 이름 중복 방지
			UUID uuid = UUID.randomUUID();
			System.out.println(uuid.toString());
			String[] uuids = uuid.toString().split("-");

			String uniqueName = uuids[0];
			System.out.println("생성된 고유문자열 : " + uniqueName);
			System.out.println("확장자명 : " + fileExtension);

			String fileName = uniqueName + fileExtension; // 확장자까지 그냥 하나의 변수로 묶음

			File saveFile = new File(uploadFolder + "\\" + uniqueName + fileExtension); // 적용 후
			try {
				file.transferTo(saveFile);
				board.setUniqueName(fileName);
				// 실제 파일 저장메서드(file writer 작업을 손쉽게 한방에 처리해준다.)
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		boardMapper.boardInsert(board);
		return "redirect:/boardList.do";

	}
	

	// 게시글 삭제
	@GetMapping("/boardDelete.do/{boardID}")
	public String boardDelete(@PathVariable("boardID") int boardID, Board board) {

		boardMapper.boardDelete(boardID);
		return "redirect:/boardList.do";
	}

	// 버튼1 카운트
	@GetMapping("/buttonCount.do/{boardID}")
	public String buttonCount(@PathVariable("boardID") int boardID, Board board) {
		boardMapper.buttonCount1(boardID);
		return "redirect:/boardContent/{boardID}";

	}

	// 버튼2 카운트
	@GetMapping("/buttonCount2.do/{boardID}")
	public String buttonCount2(@PathVariable("boardID") int boardID, Board board) {

		boardMapper.buttonCount2(boardID);
		return "redirect:/boardContent/{boardID}";
	}

}
