package kr.spring.mapper;

import java.util.List;

import kr.spring.entity.Style;

public interface StyleMapper {
	void styleSave(Style style);

	List<Style> getStyle(String memID);

	void deleteSelectedStyles(int styleIdx);

	Style getStyleByIdx(int styleIdx);
}
