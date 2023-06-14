package kr.spring.mapper;

import java.util.List;

import kr.spring.entity.Style;

public interface StyleMapper {
	void styleSave(Style style);

	List<Style> getStyle(String memID);

	void deleteSelectedStyles(int styleIdx); // 회원이 선택하여 삭제

	Style getStyleByIdx(int styleIdx);

	void styleDelete(String memID); // 회원 탈퇴 시 삭제
}
