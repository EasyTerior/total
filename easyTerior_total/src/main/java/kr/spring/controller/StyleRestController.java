package kr.spring.controller;


import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.spring.entity.Color;
import kr.spring.entity.Member;
import kr.spring.entity.Style;
import kr.spring.mapper.ColorMapper;
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
	
	@Autowired
    private ColorMapper colorMapper;

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
	
	@PostMapping("/getStyleInfo")
	public List<Style> getStyleList(@RequestParam("memID") String memID) {
	    // 필요한 로직을 수행하여 사용자 정보를 가져옴
	    // Member memberInfo = memberMapper.getMember(memID);// 사용자 정보를 가져오는 로직 작성
		try {
			List<Style> style = styleMapper.getStyle(memID);
			//System.out.println("Style DB 리턴 "+style.toString());
			return style;
		} catch (Exception e) {
			System.out.println("getStyleList - Exception : "+e);
			e.printStackTrace();
			throw new RuntimeException("Failed to get StyleList information");			
			
		} 
	}
	
	@PostMapping("/deleteSelectedStyles")
	public List<Style> deleteSelectedStyles(@RequestBody int[] styleIdx, HttpSession session) {
	    try {
	        List<Style> deletedStyles = new ArrayList<>();
	        System.out.println("받아온 idx 값은 " + Arrays.toString(styleIdx));
	        for (int idx : styleIdx) {
	            Style deletedStyle = styleMapper.getStyleByIdx(idx); // 삭제된 스타일 가져오기
	            deletedStyles.add(deletedStyle); // 삭제된 스타일 목록에 추가
	            styleMapper.deleteSelectedStyles(idx);
	            System.out.println("삭제 된 idx는 " + idx);
	        }
	        Member m  = (Member) session.getAttribute("memResult");
            List<Style> getStyle = styleMapper.getStyle(m.getMemID());
	        //System.out.println("삭제된 Style DB 리턴 " + deletedStyles.toString());
	        //System.out.println("리턴할 Style DB " + getStyle.toString());
	        
	        return getStyle;
	    } catch (Exception e) {
	        System.out.println("deleteSelectedStyles - Exception: " + e);
	        e.printStackTrace();
	        throw new RuntimeException("Failed to delete selected styles");
	    }
	}
	
	// 색 리스트 가져오기
	@PostMapping("/getColorList")
	public List<Color> getColorList(@RequestParam("memID") String memID){
		Member memberInfo = memberMapper.getMember(memID);
		List<Color> color = colorMapper.getColor(memID);
		System.out.println("\n\ncolor : "+color);
		return color;
	}

	// 이미지 삭제
	@PostMapping("/deleteColors")
	public List<Color> deleteColors(@RequestBody Map<String, int[]> request, HttpSession session) {
	    try {
	        // List<Style> deletedColor = new ArrayList<>();
	    	int[] selectedColors = request.get("selectedColors");
	        for (int imgID : selectedColors) {
	        	colorMapper.deleteColor(imgID); // 삭제
	        }
	        Member m  = (Member) session.getAttribute("memResult");
	        List<Color> color = colorMapper.getColor(m.getMemID());
	        //System.out.println("삭제된 Style DB 리턴 " + deletedStyles.toString());
	        //System.out.println("리턴할 Style DB " + getStyle.toString());
	        
	        return color;
	    } catch (Exception e) {
	        System.out.println("deleteSelectedStyles - Exception: " + e);
	        e.printStackTrace();
	        throw new RuntimeException("Failed to delete selected styles");
	    }
	}
	
	
}
