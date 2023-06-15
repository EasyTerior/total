package kr.spring.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.spring.entity.Color;
import kr.spring.entity.Style;
import kr.spring.mapper.ColorMapper;
import kr.spring.mapper.MemberMapper;
import kr.spring.mapper.StyleMapper;

@Controller
public class StyleController {
	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private ColorMapper colorMapper;
	
	@Autowired
	private StyleMapper styleMapper;
	
	// 스타일 분석 페이지 이동
	@RequestMapping("/styleRoom.do")
	public String styleRoom() {
		return "style/styleRoom";
	}
	
	// 스타일 분석 결과 페이지 이동
	@RequestMapping("/styleRoomResult/{styleIdx}")
	public String styleRoomResult(@PathVariable int styleIdx, Model model) {
	    try {
	    	System.out.println(styleIdx);
	        // 스타일 정보를 가져오는 로직 작성
	        Style style = styleMapper.getStyleByIdx(styleIdx);

	        // 가져온 스타일 정보를 모델에 추가
	        model.addAttribute("style", style);
	        System.out.println("리스폰 값은 "+style);

	        return "style/styleRoomResult"; // 상세보기 페이지로 이동할 뷰 이름 리턴
	    } catch (Exception e) {
	        System.out.println("styleRoomResult - Exception: " + e);
	        e.printStackTrace();
	        throw new RuntimeException("Failed to get style information");
	    }
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
		// 파일 저장될 위치 경로이자 가져온 파일
		String savePath = request.getRealPath("resources/images/flask"); // resource/images/flask 에 저장하려는 저장경로 지정
		// webapp 이 contextPath 이므로 해당부터 들어가도록 처리.
		System.out.println("savePath : "+savePath);
		
		// 인코딩 타입
		String encType = "UTF-8"; // encoding

		// 중복제거 객체 -> 동일한 이름의 image 이름 처리.
		DefaultFileRenamePolicy dfrp = new DefaultFileRenamePolicy();
		
		// multipart 객체 - 매개변수 : 요청데이터, 저장경로, 최대크기, 인코딩 박식, 파일명중복제거 객체
		try {
			// imageSelect 메서드에서 업로드된 파일은 MultipartRequest 객체를 사용하여 임시 디렉토리에 저장
			multi = new MultipartRequest(request, savePath, fileMaxSize, encType, dfrp);
			
			// 회원 정보 가져오기 - 로그인 안 되어있을 경우 "temp"
			String memID = (String) session.getAttribute("memResult.memID") == null ? "_temp" : (String) session.getAttribute("memResult.memID");
			System.out.println("imageSelect - memID : "+memID);

		    String newImage = "";
			// 사용자가 업도르한 파일 가져오기
			File file = multi.getFile("imgUpload"); 
			System.out.println("original file name : " + file.getName());
			// 파일명 수정
			String originalFilename = file.getName();
			String extension = originalFilename.substring(originalFilename.lastIndexOf(".")); // 확장자
			String newFilename = memID + "_" + originalFilename;  
			System.out.println("newFilename : " + newFilename);
			
			// 파일 이동 및 저장
			// String newSavePath = "";
			String newFilePath = savePath + "\\" + newFilename;
			System.out.println("newFilePath : " + newFilePath);
			File newFile = new File(newFilePath);
			
			// 파일 이름이 중복될 경우 숫자를 추가하여 파일명 변경
			int count = 0;
			String newFilePathWithNumber = newFilePath; // 중복 처리된 파일 경로

			while (newFile.exists()) {
				count++;
			    String fileNameWithoutExtension = newFilename.substring(0, newFilename.lastIndexOf("."));
			    String fileExtension = newFilename.substring(newFilename.lastIndexOf("."));
			    String incrementedFileName = fileNameWithoutExtension + "_" + count + fileExtension;
			    newFilePathWithNumber = savePath + "\\" + incrementedFileName;
			    newFile = new File(newFilePathWithNumber);
			    System.out.println("incrementedFileName :"+incrementedFileName);
			    System.out.println("newFilePathWithNumber : "+newFilePathWithNumber);
			    System.out.println("newFile path: " + newFile.getPath());
			}
			
			String originalImg = newFile.getPath();
			
			// 파일 이동 및 저장
			file.renameTo(new File(newFilePathWithNumber));

			// 중복 처리된 파일 경로를 newFilePath 변수에 저장
			newFilePath = newFilePathWithNumber;
			
			// 파일 저장 후 flask 처리하기
			// "http://127.0.0.1:5000/process_image" 에 newFilePath 경로 전달
			// CSRF 토큰 가져오기
			String csrfToken = multi.getParameter("_csrf");
			session.setAttribute("csrfToken", csrfToken); // session에 저장
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
			// System.out.println("responseEntity : \n"+responseEntity);
			// 응답 처리
			if (responseEntity.getStatusCode().is2xxSuccessful()) {
				// 성공적인 응답 처리
				String jsonResponse = responseEntity.getBody();
				// URL 디코딩 및 파싱하여 detection_result와 img_path 값을 추출
				String detectionResult = null;
				String imgPath = null;
				String imageDir = null;
				jsonResponse = URLDecoder.decode(jsonResponse, "UTF-8");
				String[] queryParams = jsonResponse.split("\\?")[1].split("&");
				for (String param : queryParams) {
			        String[] keyValue = param.split("=");
			        if (keyValue.length == 2) {
			            String key = keyValue[0];
			            String value = keyValue[1];
			            
			            if (key.equals("detection_result")) {
			                detectionResult = value;
			            } else if (key.equals("img_path")) {
			                imgPath = value;
			            }else { // image_folder
			            	imageDir = value;
			            }
			        }
			    }
				// 파일을 이클립스에서 인식하도록 옮기기
				// 파일 이름 추출
				String fileName = imgPath.substring(imgPath.lastIndexOf("/") + 1);
				// 실질적인 프로젝트 이미지 경로
				String realImagePath = "C:/eGovFrame-4.0.0/workspace.edu/.metadata/.plugins/org.eclipse.wst.server.core/tmp2/wtpwebapps/easyTerior_total/resources/images/flask/" + fileName;
 				// String realImagePath = "C:/eGovFrame-4.0.0/workspace.edu/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/easyTerior_total/resources/images/flask/" + fileName;
				// 파일 이동
				Path sourcePath = Paths.get(imgPath);
				Path targetPath = Paths.get(realImagePath);
				Files.move(sourcePath, targetPath, StandardCopyOption.REPLACE_EXISTING);
				
				// detectionResult 를 JSON 형태로 저장하기
				// 중복 제거
				ObjectMapper objectMapper = new ObjectMapper();
				int[] resultArray = objectMapper.readValue(detectionResult, int[].class);
				Set<Integer> uniqueResult = new HashSet<>();
				for (int num : resultArray) {
				    uniqueResult.add(num);
				}
				// 중복 제거된 결과를 리스트로 변환
				List<Integer> resultList = new ArrayList<>(uniqueResult);
				
				String totalObjects = "{\"0\" : \"침대\", \"1\" : \"이불\", \"2\" : \"카펫\", \"3\" : \"의자\", \"4\" : \"커튼\", \"5\" : \"문\", \"6\" : \"램프\", \"7\" : \"베개\", \"8\" : \"선반\", \"9\" : \"소파\", \"10\" : \"테이블\", \"default\" : \"알 수 없음\"}";
				// JSON 문자열을 맵으로 변환
				ObjectMapper objects = new ObjectMapper();
				TypeReference<HashMap<String, String>> typeRef = new TypeReference<HashMap<String, String>>() {};
				HashMap<String, String> objectList = objects.readValue(totalObjects, typeRef);

			    // JSON 데이터를 세션에 저장
				// 추출한 detection_result와 img_path 값을 세션에 저장
				if (detectionResult != null && imgPath != null) {
					session.setAttribute("detectionResult", detectionResult); // 검출된 전체 목록
				    session.setAttribute("resultList", resultList); // 실질 검출된 중복 제외 객체 종류
				    session.setAttribute("objectList", objectList); // 전체 객체 종류
				    session.setAttribute("imgPath", realImagePath); // flask에서 처리된 이미지
				    session.setAttribute("originalImg", originalImg); // 사용자가 업로드 한 원본 이미지 경로
				    session.setAttribute("imageDir", imageDir); // flask에서 작업한 exp 디렉토리
				}
			    session.setAttribute("flaskFullResponse", jsonResponse);
			    System.out.println("\n\nresponseEntity Success - flaskResponse : \n"+jsonResponse);
			    System.out.println("detectionResult : "+detectionResult);
			    session.setAttribute("resultList", resultList); // 실질 검출된 중복 제외 객체 종류
			    System.out.println("imgPath : "+realImagePath);
			    System.out.println("originalImg : "+originalImg);
			    System.out.println("imageDir : "+imageDir);

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
            return "redirect:/colorChange.do";
		}
	}
	
	@RequestMapping("/colorSelect.do")
	public String colorSelect(HttpSession session) { // @RequestParam("detection_result") String detectionResult, @RequestParam("img_path") String imgPath, HttpSession session
//		System.out.println("colorSelect called");
//	    System.out.println("detectionResult : "+session.getAttribute("detectionResult"));
//	    System.out.println("imgPath : "+session.getAttribute("imgPath"));
	    return "style/colorSelect";
	}
	
	@RequestMapping("/colorSelectForm.do")
	public String colorSelectForm(@RequestParam("selectedObjectList") List<String> selectedObjectList, @RequestParam("selectedColorValue") String selectedColorValue, HttpSession session, RedirectAttributes rttr) {
		System.out.println("\n\ncolorSelectForm called");
//		System.out.println("selectedObjectList : "+selectedObjectList);
//		System.out.println("selectedColorValue : "+selectedColorValue);
		try {
			// CSRF 토큰 가져오기
			String csrfToken = (String) session.getAttribute("csrfToken");
			System.out.println("csrfToken : " + csrfToken);

		    // 사용자가 업로드한 이미지 경로 가져오기
		    String originalImg = (String) session.getAttribute("originalImg");
		    System.out.println("originalImg : " + originalImg);

		    // flask에서 작업했던 exp 폴더 경로 가져오기
		    String imageDir = (String) session.getAttribute("imageDir");
		    
		    // 검출되었던 전체 목록 가져오기
		    Object detectionResult = session.getAttribute("detectionResult");
		    
		    // RestTemplate를 통해 flask의 "http://127.0.0.1:5000/color_change"로 request를 보내기
		    HttpHeaders headers = new HttpHeaders();
		    // headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		    // MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
		    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
		    body.add("csrfToken", csrfToken);
	        body.add("originalImg", originalImg);
	        body.addAll("selectedObjectList", selectedObjectList);
	        body.add("selectedColorValue", selectedColorValue);
	        body.add("imageDir", imageDir);
	        body.add("detectionResult", detectionResult);

		    //HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);
	        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
	        System.out.println("requestEntity : "+requestEntity);
		    
		    // RestTemplate 생성
		    RestTemplate restTemplate = new RestTemplate();

		    ResponseEntity<String> responseEntity = restTemplate.postForEntity(
		    	    "http://127.0.0.1:5000/color_change",
		    	    requestEntity,
		    	    String.class
		    );
		    
		    System.out.println("\n\nresponseEntity : "+responseEntity);
		    
		    // 4. response가 성공적이면 "colorChangeResult.do"로 redirect하기
		    if (responseEntity.getStatusCode().is2xxSuccessful()) {
		    	// 성공적인 응답 처리
				String jsonResponse = responseEntity.getBody();
				// URL 디코딩 및 파싱하여 detection_result와 img_path 값을 추출
				try {
					jsonResponse = URLDecoder.decode(jsonResponse, "UTF-8");
					String[] ResponseSplit = jsonResponse.split("\\?");
					jsonResponse = ResponseSplit[1];
					System.out.println("\n\njsonResponse : "+jsonResponse+"\n\n");
					// 분리된 파라미터들을 저장할 Map 생성
					Map<String, String> params = new HashMap<>();

					// "&"로 분리
					String[] paramPairs = jsonResponse.split("&");
					System.out.println("\n\nparamPairs : "+paramPairs);
					// 각 파라미터에 대해 "="로 분리하여 Map에 저장
					for (String paramPair : paramPairs) {
					    String[] keyValue = paramPair.split("=");
					    System.out.println("\n\nparamPair : "+paramPair);
					    if (keyValue.length == 2) {
					        String key = keyValue[0];
					        String value = keyValue[1];
					        params.put(key, value);
					    }
					}
					
					String img_data = params.get("img_data");
					String naver_urls = params.get("naver_urls");
					String final_img = params.get("final_img");
					String original_img = params.get("original_img");
					String real_color = params.get("real_color");

					System.out.println("\n\nSuccessful jsonResponse");
//					System.out.println("img_data : "+img_data);
					System.out.println("naver_urls : "+naver_urls);
//					System.out.println("final_img : "+final_img);
//					System.out.println("original_img : "+original_img);
//					System.out.println("real_color : "+real_color);

					if (jsonResponse != null) {
					    session.setAttribute("img_data", img_data); // 색깔 정보
					    session.setAttribute("naver_urls", naver_urls); // 네이버 쇼핑 API 결과
					    session.setAttribute("final_img", final_img); // flask에서 처리된 이미지
					    session.setAttribute("original_img", original_img); // 사용자가 업로드 한 원본 이미지 경로
					    session.setAttribute("real_color", real_color); // 처리한 색깔
					}
					
			    	return "redirect:/colorChangeResult.do";
				} catch (Exception e) {
					System.out.println("colorSelectForm jsonResponse Exception called : "+e);
					e.printStackTrace();
					rttr.addFlashAttribute("msgType", "실패 메세지");
		            rttr.addFlashAttribute("msg", "이미지 변화에 실패하였습니다. jsonResponse 에서 문제가 있습니다."); 
			        return "redirect:/colorSelect.do";
				}
		    } else {
		    	rttr.addFlashAttribute("msgType", "실패 메세지");
	            rttr.addFlashAttribute("msg", "이미지 변화에 실패하였습니다. flask에서 문제가 있습니다."); 
		        return "redirect:/colorSelect.do";
		    }
		}catch(Exception e) {
			System.out.println("colorSelectForm Exception called");
			e.printStackTrace();
			rttr.addFlashAttribute("msgType", "실패 메세지");
            rttr.addFlashAttribute("msg", "이미지 변화에 실패하였습니다. flask에 보내지 못했습니다."); 
	        return "redirect:/colorSelect.do";
		}
	}
	
	
	@RequestMapping("/colorChangeResult.do")
	public String colorChangeResult() {
		System.out.println("\n\ncolorChangeResult called");
		return "style/colorChangeResult";
	}
	
	// saveColorResult.do 결과에 대해 저장하기. colorMapper
	@RequestMapping("/saveColorResult.do")
	public String saveColorResult(Color color, RedirectAttributes rttr) {
		colorMapper.saveColor(color);
		rttr.addFlashAttribute("msgType", "성공 메세지");
        rttr.addFlashAttribute("msg", "성공적으로 저장되었습니다. 마이페이지에서 저장된 사진을 확인할 수 있습니다!");
		return "redirect:/";
	}
	
}
