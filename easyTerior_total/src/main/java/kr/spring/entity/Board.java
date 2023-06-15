package kr.spring.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data // 롬복이라는 API가 알아서 getter/setter를 만들도록.
@NoArgsConstructor // 기본 생성자 없으면 에러 나므로 만들어줘야 함. 필수
@AllArgsConstructor // 전체 argument를 받는 constructor 만들어줌 -> 필요에 의해
@ToString // 값을 빠르게 확인하는 메서드 -> printInfo 같은 느낌
public class Board {
	private int boardID;
	private String title;
	private String content;
	private String uniqueName;  // 추가(boardImage에 값을 할당하기 위해 만듦)
	private String boardImage;
	private String boardImage2;
	private String boardImage3;
	private String boardImage4;
	private Date createdAt;
	private int views;
	private String memID;
	private int voteCount;    // 투표 기능으로 인해 아래 세개 추가
	private String voteContent1;
	private String voteContent2;
	private String voteContent3;
	private String voteContent4;
	private int count1;
	private int count2;
	private int count3;
	private int count4;
	
}

