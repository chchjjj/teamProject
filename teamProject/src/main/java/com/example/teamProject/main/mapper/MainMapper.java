package com.example.teamProject.main.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.teamProject.main.model.Main;

@Mapper
public interface MainMapper {
	
	// 메인화면 상품목록
	List<Main> selectMainProList(HashMap<String, Object> map); 
	
	
}
