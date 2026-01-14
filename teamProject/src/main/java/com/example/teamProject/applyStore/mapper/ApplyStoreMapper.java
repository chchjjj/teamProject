package com.example.teamProject.applyStore.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ApplyStoreMapper {
	
	//가게 정보 입력
	int insertSellerInfo(HashMap<String, Object> params);
	
	//가게 정보 입력 후 이미지 입력
	int insertStoreImage(HashMap<String, Object> params);
	
	//가게 이미지 페이지
	Long getStoreIdByUserId(@Param("userId") String userId);
	
	//가게 번호 조회
	Integer selectStoreIdByStoreNameAndUserId(
	        @Param("storeName") String storeName,
	        @Param("userId") String userId
	    );
	
	// 사업자등록번호 중복 확인
	int checkBusinessNo(HashMap<String, Object> params);
	
	
	
}
