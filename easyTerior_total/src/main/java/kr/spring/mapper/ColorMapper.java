package kr.spring.mapper;

import java.util.List;

import kr.spring.entity.Color;

public interface ColorMapper {
	void saveColor(Color color);

	List<Color> getColor(String memID);

	void deleteColor(int imgID); // 회원이 선택하여 부분 삭제

	void colorDelete(String memID); // 회원 탈퇴 시 전체 삭제

	String getColorfilename(int imgID);  //0615 추가

}
