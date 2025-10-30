package com.example.teamProject.applyStore.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ApplyStoreMapper {
	
	//가게 정보 입력
	int insertSellerInfo(HashMap<String, Object> params);
	
	//가게 정보 입력 후 이미지 입력
	int insertStoreImages(HashMap<String, Object> params);
	
	//가게 이미지 페이지에서 사용하는 유저아이디를 가져올 때
	Long getStoreIdByUserId(@Param("userId") String userId);
	

	
	
	
}
