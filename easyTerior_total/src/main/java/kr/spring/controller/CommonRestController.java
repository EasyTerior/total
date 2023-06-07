package kr.spring.controller;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.spring.entity.Member;
import kr.spring.mapper.MemberMapper;

//controller 자체에다가 surfix를 추가해주는 셈
@RequestMapping("/style") // style 기능들이므로
@RestController // 비동기 요청을 받는 controller이고, 상태 서버의 고유한 리소스를 접근하는 대표 상태 전송 가능. @RestController만 가능
public class CommonRestController {
	
	@Autowired
	private MemberMapper memberMapper;
	
	
	// 개인정보 전체 가져오기 (비동기) 요청 URL - /updateForm.do
	// 비동기 메서드 -> js 작동
	@GetMapping("/colorSelect")
	public String colorSelect(HttpSession session) {
		String flaskResponse =  (String) session.getAttribute("flaskResponse");
		
		return null;
	}

	
}

