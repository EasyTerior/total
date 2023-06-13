package kr.spring.mapper;

import java.util.List;

import kr.spring.entity.Color;

public interface ColorMapper {
	void saveColor(Color color);

	List<Color> getColor(String memID);

	void deleteColor(int imgID);


}
