package kr.spring.controller; // 해당 controller 아래서만 사용한다고 servlet-context.xml에 명시함

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.spring.entity.Board;
import kr.spring.entity.Member;
import kr.spring.mapper.MemberMapper;

//controller 자체에다가 surfix를 추가해주는 셈
@RequestMapping("/member") // member 기능들이므로
@RestController // 비동기 요청을 받는 controller이고, 상태 서버의 고유한 리소스를 접근하는 대표 상태 전송 가능. @RestController만 가능
public class MemberRestController {
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private PasswordEncoder pwEncoder; // 비밀번호 인코딩
	
	// 개인정보 전체 가져오기 (비동기) 요청 URL - /updateForm.do
	// 비동기 메서드 -> js 작동
	@PostMapping("/getUserInfo")
	public Member getUserInfo(@RequestParam("memID") String memID) {
	    // 필요한 로직을 수행하여 사용자 정보를 가져옴
	    // Member memberInfo = memberMapper.getMember(memID);// 사용자 정보를 가져오는 로직 작성
		try {
			Member memberInfo = memberMapper.getMember(memID); // 사용자 정보를 가져오는 로직 작성
			System.out.println("getUserInfo - " + memID);
			System.out.println(memberInfo);
			return memberInfo;
		} catch (Exception e) {
			System.out.println("getUserInfo - Exception : "+e);
			e.printStackTrace();
			throw new RuntimeException("Failed to get user information");			
			
		} 
	    // return memberInfo;
	}


	

}
