package com.learnify.config;



import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletRegistration;

public class AppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

	private final static long MAX_FILE_SIZE = 500L*1024*1024;
	// 500 * 1024 kilobytes (1mb) * 1024 bytes(1kb) = 500 mb
	private final static long MAX_REQUEST_SIZE = 520L*1024*1024;
	private final static int FILE_THRESHOLD = 1024*1024;
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{HibernateConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[]{AppConfig.class};
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }
 

    @Override
    protected String getServletName() {
        return "dispatcher";
    }
    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {

        MultipartConfigElement multipartConfig = new MultipartConfigElement(
                null,
                MAX_FILE_SIZE,
                MAX_REQUEST_SIZE,
                FILE_THRESHOLD
        );

        registration.setMultipartConfig(multipartConfig);
    }
}
