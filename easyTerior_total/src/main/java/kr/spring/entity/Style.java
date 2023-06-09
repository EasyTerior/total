package kr.spring.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor // 기본 생서자 없으면 mybatis 쓸 수 없으니 필수.
@ToString

public class Style {
    private String resultClass1;
    private String resultClass2;
    private String resultClass1_probability;
    private String resultClass2_probability;
    private String memID;
}