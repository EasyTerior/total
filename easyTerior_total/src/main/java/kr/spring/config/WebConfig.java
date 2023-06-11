package kr.spring.config;

import javax.servlet.Filter;

import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

// web.xml을 대신할 클래스가 됨.
public class WebConfig extends AbstractAnnotationConfigDispatcherServletInitializer {

	@Override
	protected Class<?>[] getRootConfigClasses() {
		return new Class[] { RootConfig.class, SecurityConfig.class };
	}

	@Override
	protected Class<?>[] getServletConfigClasses() {
		return new Class[] { ServletConfig.class };
	}

	@Override
	protected String[] getServletMappings() { // controller/ 라는 식의 contextPath 설정
		return new String[] {"/"};
	}

	// 필수는 아니라서 @Override 자동처리 안 되긴 했지만 추가로 한국어로서 인코딩 설정 filters 처리 해주기
	@Override
	protected Filter[] getServletFilters() {
		// return super.getServletFilters(); // super == 방금 상속받은 바로 위 클래스
		CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
		encodingFilter.setEncoding("UTF-8");
		encodingFilter.setForceEncoding(true);
		return new Filter[] { encodingFilter };
	}

}
