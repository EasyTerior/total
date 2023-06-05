package kr.spring.controller;


import javax.servlet.http.HttpServletRequest;

import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class CommonController {

	// 	main - 요청 URL /
	@RequestMapping("/")
	public String main() {
		// return "main";
		return "index";
	}
	
	// 스타일 분석 페이지 이동
	@RequestMapping("/styleRoom.do")
	public String styleRoom() {
		return "style/styleRoom";
	}
	
	// 스타일 분석 결과 페이지 이동
	@RequestMapping("/styleRoomResult.do")
	public String styleRoomResult() {
		return "style/styleRoomResult";
	}
	
	// 색 변경하기 페이지 이동
	@RequestMapping("/colorChange.do")
	public String colorChange() {
		return "style/colorChange";
	}
	
	// 색 갹체 탐지 페이지 이동 페이지 이동
	@RequestMapping(value = "/colorSelect.do", method = RequestMethod.POST)
	public String colorSelect(HttpServletRequest request) {
		System.out.println("\n\request : "+request);
		 // CSRF 토큰 가져오기
	    CsrfToken csrfToken = (CsrfToken) request.getAttribute("_csrf");
	    System.out.println("\n\ncsrfToken : "+csrfToken);
	    
		return "style/colorSelect";
	}
	
}
