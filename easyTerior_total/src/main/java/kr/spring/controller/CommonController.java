package kr.spring.controller;


import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Collections;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.spring.entity.Member;
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
	
	
	// 객체 탐지 페이지 이동 페이지 이동
	@RequestMapping("/imageSelect.do")
	public String imageSelect(HttpServletRequest request, RedirectAttributes rttr, HttpSession session) {
		System.out.println("imageSelect called");
		// 파일 업로드 DB에 파일을 넣는 것은 업로드가 아니라 Mybatis로 넣는 것이지 서버의 특정 폴더에 넣는 것이 업로드
		// COS 의 multipartRequest 라는 객체를 생성하여 그 객체를 통해서 업로드.
		MultipartRequest multi = null;
		int fileMaxSize = 100 * 1024 * 1024; // 파일 최대 크기 제한 -> 100 MB == 100 * 1024 * 1024
		// 파일 저장될 위치 경로
		String savePath = request.getRealPath("resources/flask"); // resource/flask 에 저장하려는 저장경로 지정
		// webapp 이 contextPath 이므로 해당부터 들어가도록 처리.
		
		// 인코딩 타입
		String encType = "UTF-8"; // encoding

		// 중복제거 객체 -> 동일한 이름의 image 이름 처리.
		DefaultFileRenamePolicy dfrp = new DefaultFileRenamePolicy();
		
		// multipart 객체 - 매개변수 : 요청데이터, 저장경로, 최대크기, 인코딩 박식, 파일명중복제거 객체
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, encType, dfrp);
			
			// 회원 정보 가져오기 - 로그인 안 되어있을 경우 "temp"
			String memID = (String) session.getAttribute("memResult.memID") == null ? "_temp" : (String) session.getAttribute("memResult.memID");
			System.out.println("memID : "+memID);
			//Member memInfo = memberMapper.getMember(memID); // 사용자 정보를 가져오는 로직 작성
			//System.out.println("memInfo : "+memInfo);
			
			// memInfo에서 memIdx와 memID 가져오기
		    // Integer memberIdx = memInfo.getMemIdx();
		    // String memberID = memInfo.getMemID();
		    
		    String newImage = "";
			// 사용자가 업도르한 파일 가져오기
			File file = multi.getFile("imgUpload"); 
			System.out.println("file name : " + file.getName());
			// 파일명 수정
			String originalFilename = file.getName();
			String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
			String newFilename = memID + "_" + extension; // memberIdx + "_" + 

			// 파일 이동 및 저장
			String newFilePath = savePath + "\\" + newFilename;
			File newFile = new File(newFilePath);
			
			// 파일 이름이 중복될 경우 숫자를 추가하여 파일명 변경
			int count = 1;
			String newFilePathWithNumber = newFilePath; // 중복 처리된 파일 경로

			while (newFile.exists()) {
			    String fileNameWithoutExtension = newFilename.substring(0, newFilename.lastIndexOf("."));
			    String fileExtension = newFilename.substring(newFilename.lastIndexOf("."));
			    String incrementedFileName = fileNameWithoutExtension + count + fileExtension;
			    newFilePathWithNumber = savePath + "\\" + incrementedFileName;
			    newFile = new File(newFilePathWithNumber);
			    count++;
			}

			// 파일 이동 및 저장
			file.renameTo(new File(newFilePathWithNumber));

			// 중복 처리된 파일 경로를 newFilePath 변수에 저장
			newFilePath = newFilePathWithNumber;
			
			// 파일 저장 후 flask 처리하기
			// "http://127.0.0.1:5000/process_image" 에 newFilePath 경로 전달
			// CSRF 토큰 가져오기
			String csrfToken = multi.getParameter("_csrf");
			System.out.println("csrfToken : " + csrfToken);
			
			// 요청 헤더 설정
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
			headers.setAcceptCharset(Collections.singletonList(StandardCharsets.UTF_8)); // 한글로 주고 받도록

			// 요청 파라미터 설정
			MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
			body.add("newFilePath", newFilePath);
			body.add("csrfToken", csrfToken);

			// 요청 엔티티 생성
			HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);

			// RestTemplate 생성
			RestTemplate restTemplate = new RestTemplate();

			// POST 요청 실행
			ResponseEntity<String> responseEntity = restTemplate.exchange(
			        "http://127.0.0.1:5000/process_image",
			        HttpMethod.POST,
			        requestEntity,
			        String.class
			);
			System.out.println("responseEntity : \n"+responseEntity);
			// 응답 처리
			if (responseEntity.getStatusCode().is2xxSuccessful()) {
				// 성공적인 응답 처리
				String jsonResponse = responseEntity.getBody();
				// jsonResponse = jsonResponse.replace("\\","/");
			    // JSON 데이터를 세션에 저장
			    session.setAttribute("flaskResponse", jsonResponse);
			    System.out.println("\n\nflaskResponse : \n"+jsonResponse);

			    // 성공 후 colorSelect.do로 이동
			    return "redirect:/colorSelect.do";
			}else {
				System.out.println("Failed responseEntity : \n"+responseEntity);
				
				rttr.addFlashAttribute("msgType", "실패 메세지");
			    rttr.addFlashAttribute("msg", "flask에서 response가 오지 않았습니다.");
				return "redirect:/colorChange.do";
			}
		}catch(Exception e) {
			e.printStackTrace();
            System.out.println("colorSelect Exception e: " + e);
            rttr.addFlashAttribute("msgType", "실패 메세지");
            rttr.addFlashAttribute("msg", "이미지 업로드에 실패하셨습니다. 확장자 및 이미지 파일을 확인해주세요.");
            return "redirect:/colorChage.do";
		}
	}
	
	// 색 선택하기 페이지 이동
	@RequestMapping("/colorSelect.do")
	public String colorSelect() {
		return "style/colorSelect";
	}
	
	@RequestMapping("/colorChangeResult.do")
	public String colorChangeResult() {
		return "style/colorChangeResult";
	}
}

