package com.example.teamProject.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.google.api.client.util.Value;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	@Value("${file.upload-dir}")
    private String uploadDir;
	
    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.setPathMatcher(new AntPathMatcher());
    }
    
    
}
