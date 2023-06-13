package kr.spring.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor // 기본 생성자 없으면 mybatis 쓸 수 없으니 필수.
@ToString

public class Color {
	private int id;
	private String fileName;
	private String hexVal;
	private String memID;
}
