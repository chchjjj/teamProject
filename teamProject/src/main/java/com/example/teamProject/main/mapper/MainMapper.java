package com.example.teamProject.main.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.teamProject.main.model.Main;

@Mapper
public interface MainMapper {
	
	// 메인화면 상품목록
	List<Main> selectMainProList(HashMap<String, Object> map); 
	
	// 헤더 메뉴 중 QnA 접속 및 리스트
	List<Main> selectQnaList(HashMap<String, Object> map);
	
	// QnA 게시글 전체 개수 구하기 (페이징 위해)
	int selectQnaCnt(HashMap<String, Object> map);
}
