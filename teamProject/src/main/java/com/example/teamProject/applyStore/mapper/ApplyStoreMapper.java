package com.example.teamProject.applyStore.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ApplyStoreMapper {
	
	//가게 정보 입력
	int insertSellerInfo(HashMap<String, Object> params);
	
	//가게 정보 입력 후 이미지 입력
	int insertStoreImages(HashMap<String, Object> params);
	
	//가게 이미지 페이지에서 사용하는 가게번호,유저아이디 등을 가져올 때
	HashMap<String, Object>  getStoreInfo(int storeId);

	
	
	
}
