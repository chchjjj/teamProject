package com.example.teamProject.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;

import com.google.api.client.util.Value;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	@Value("${file.upload-dir}")
    private String uploadDir;
	
    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.setPathMatcher(new AntPathMatcher());
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
       
        String projectPath = System.getProperty("user.dir").replace("\\", "/");
        
        
        registry.addResourceHandler("/img-product/**")
                .addResourceLocations("file:///" + projectPath + "/src/main/webapp/img-product/");
        
        System.out.println("📢 [매핑 완료] " + projectPath + "/src/main/webapp/img-product/ 경로가 연결됨");
    }
    }  
    



