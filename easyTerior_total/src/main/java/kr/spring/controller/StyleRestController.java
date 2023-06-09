package kr.spring.controller;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import kr.spring.entity.Style;
import kr.spring.mapper.MemberMapper;
import kr.spring.mapper.StyleMapper;

//controller 자체에다가 surfix를 추가해주는 셈
@RequestMapping("/style") // style 기능들이므로
@RestController // 비동기 요청을 받는 controller이고, 상태 서버의 고유한 리소스를 접근하는 대표 상태 전송 가능. @RestController만 가능
public class StyleRestController {
	
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
    private StyleMapper styleMapper;

	@PostMapping("/save")
    public ResponseEntity<Map<String, String>> saveStyle(@RequestBody Style style) {
        styleMapper.styleSave(style);
        Map<String, String> result = new HashMap<>();
        result.put("status", "success");
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
	
	// 개인정보 전체 가져오기 (비동기) 요청 URL - /updateForm.do
	// 비동기 메서드 -> js 작동
	@GetMapping("/colorSelect")
	public String colorSelect(HttpSession session) {
		String flaskResponse =  (String) session.getAttribute("flaskResponse");
		
		return null;
	}

	
}

