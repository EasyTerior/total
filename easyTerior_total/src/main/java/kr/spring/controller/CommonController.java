package kr.spring.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import kr.spring.mapper.MemberMapper;

@Controller
public class CommonController {
	
	@Autowired
	private MemberMapper memberMapper;

	// 	main - 요청 URL /
	@RequestMapping("/")
	public String main() {
		// return "main";
		return "index";
	}

}

