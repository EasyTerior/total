package kr.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.spring.entity.Board;
import kr.spring.entity.Style;
import kr.spring.mapper.BoardMapper;
import kr.spring.mapper.StyleMapper;

// controller 자체에다가 surfix를 추가해주는 셈
@RestController
@RequestMapping("/style")
public class StyleRestController {

    @Autowired
    private StyleMapper styleMapper;

    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> saveStyle(@RequestBody Style style) {
    	
        styleMapper.styleSave(style);
        Map<String, String> result = new HashMap<>();
        result.put("status", "success");
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
