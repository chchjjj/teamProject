package com.example.teamProject.seller.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.seller.model.Seller;

@Mapper
public interface SellerMapper {

	

	// 가게 이름 수정
	int updateStoreNameMap(Map<String,Object> storeMap);

	// 가게 소개글 수정
	int updateStoreIntroMap(Map<String,Object> storeMap);


	// 채팅 가능 여부 및 시간 정보 수정
	int updateChatInfoMap(Map<String,Object> storeMap);
	//가게 정보 에서 가게 리스트 가져오는 
	List<Seller> selectStoreList(HashMap<String, Object> map);
	//월별 매월 가져오는 리스트
	List<HashMap<String, Object>> selectMonthlySales(HashMap<String, Object> map);
	
	//판매 내역 가져오는 리스트
	List<HashMap<String, Object>> selectOrderList(HashMap<String, Object> map);
	//주문 번호로 상세 보여주기
	List<HashMap<String, Object>> selectOrderDetail(HashMap<String, Object> map);
}
