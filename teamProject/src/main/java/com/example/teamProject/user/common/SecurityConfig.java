package com.example.teamProject.user.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;


@Configuration
public class SecurityConfig {

	 @Bean
	 public PasswordEncoder passwordEncoder() {
	     return new BCryptPasswordEncoder();  // 비밀번호 해싱 기능만 사용
	 }
	
	 @Bean
	 public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
	     http
	        .authorizeHttpRequests(auth -> auth
	            .anyRequest().permitAll() // 모든 요청 허용 (로그인 필요 없음)
	         )
	        .csrf(csrf -> csrf.disable()) // CSRF 보호 비활성화 (필요 시 설정 가능)
	        .formLogin(form -> form.disable()) // 기본 로그인 페이지 비활성화
	        .httpBasic(basic -> basic.disable()) // HTTP Basic 인증 비활성화
	     	.headers(headers -> headers.cacheControl(cache -> cache.disable()))
	     	; // HTTP Basic 인증 비활성화
	
	     return http.build();
	 }
	 
	 //수업 시간에 배운대로만 코드를 작성하면 이중 슬래시 때문에 실행 안됀다는(?) 에러가 떠서
	 //이 줄 밑에 Bean 영역에 해당하는 코드는 ai가 제시한 해법대로 추가한 코드입니다.
	 @Bean
	 public HttpFirewall relaxedHttpFirewall() {
	     StrictHttpFirewall firewall = new StrictHttpFirewall();
	     // 💡 이중 슬래시 (//)를 허용하도록 설정합니다.
	     firewall.setAllowUrlEncodedDoubleSlash(true);
	     return firewall;
	 }
}