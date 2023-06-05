package kr.spring.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

// import reactor.core.publisher.Mono; // Project Reactor 라이브러리에서 제공하는 클래스로, 0개 또는 1개의 결과를 발행하는 Publisher 이고 Project Reactor는 비동기 프로그래밍을 위한 리액티브 스트림 API를 제공하는 라이브러리이다.
// Spring WebFlux에서 WebClient를 사용하여 비동기 네트워크 요청을 수행할 때는 일반적으로 Mono 또는 Flux를 반환합니다. Mono는 0 또는 1개의 결과를 포함하고, Flux는 0개 이상의 결과를 포함할 수 있습니다. Mono의 메서드 중 block()는 비동기 작업이 완료될 때까지 현재 스레드를 블로킹합니다. 이는 비동기 작업의 결과를 동기 방식으로 처리해야 하는 경우에 사용됩니다.

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
	
	/*
	 // 색 변경하기 선택된 객체 선택하기 페이지 이동
	@RequestMapping("/colorSelect.do")
	public String colorSelect(@RequestParam("imgUpload") MultipartFile file, RedirectAttributes rttr) { // // MultipartFile을 File로 변환하여 처리
	    
	    // file.getBytes()로 바이트 배열을 얻음 -> Unhandled exception type IOException 방지 위해서 try-catch 사용
	    try {
	    	// 파일을 flask 서버에 전송
		    HttpHeaders headers = new HttpHeaders();
		    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		    
    		ByteArrayResource resource = new ByteArrayResource(file.getBytes()) {
	    		@Override
		        public String getFilename() {
		            return file.getOriginalFilename();
		        }
    		};
    		
    		// MultiValueMap은 하나의 키에 여러 값을 가질 수 있는 맵으로 이 맵을 사용하여 이미지 데이터를 담을 것ㅋㄷㅇㅊ 
		    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
		    body.add("image", resource); // resource (사용자가 업로드한 이미지 데이터)를 image라는 키로 맵에 추가
		    
		    // String jsonResponse = responseMono.block();
			
		    // Flask 서버로부터 받은 JSON 응답을 처리
		    // jsonResponse 변수에 JSON 문자열이 저장되어 있습니다.
		    // 이 문자열을 필요한 형태로 파싱하여 사용하세요.
		    rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "이미지 업로드에 성공하셨습니다.");
		    
		    return "style/colorSelect";
    		
	    }catch (IOException e){
	    	e.printStackTrace();
	        // 에러 처리 로직
	        System.out.println("IOException e : "+e);
	        rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "이미지 업로드에 실패하셨습니다. 확장자(jpg, jpeg, png, gif)를 확인 후 다시 시도해주세요.");
	        return "redirect:/colorChange.do";
	    }
	    
	} 
	*/
	
	
}
