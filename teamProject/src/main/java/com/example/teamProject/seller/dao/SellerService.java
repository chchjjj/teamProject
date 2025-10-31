package com.example.teamProject.seller.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.example.teamProject.seller.mapper.SellerMapper;
import com.example.teamProject.seller.model.Seller;

@Service
public class SellerService {
	@Autowired
	SellerMapper sellerMapper;

	// 판매자 가게 리스트 불러오기
	public HashMap<String, Object> getStoreList(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			List<Seller> list = sellerMapper.selectStoreList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			System.out.println(resultMap);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}

		return resultMap;
	}

	// 월별 판매 리스트 불러오기
	public HashMap<String, Object> getSellesChart(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<>();
		try {
			// 입력값 콘솔 출력
			System.out.println("입력 map: " + map);

			// Mapper XML 호출
			List<HashMap<String, Object>> list = sellerMapper.selectMonthlySales(map);

			// 조회 결과 콘솔 출력
			System.out.println("조회 결과 list: " + list);

			resultMap.put("list", list);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("error", "월별 매출 조회 중 오류 발생");
		}
		return resultMap;
	}

	// 판매 내역
	public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> orders = new ArrayList<>();

		try {
			// 1. DB에서 주문 리스트 조회 (Mapper 호출)
			orders = sellerMapper.selectOrderList(map);
			
			// 2. null 체크
			if (orders == null) {
				orders = new ArrayList<>();
			}

			result.put("list", orders);

		} catch (Exception e) {
			// 에러 발생 시 로그 출력
			e.printStackTrace();

			// 빈 리스트 반환 + 에러 메시지 포함 가능
			result.put("list", new ArrayList<>());
			result.put("error", "판매 내역 조회 중 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}

	public HashMap<String, Object> getOrderDetail(HashMap<String, Object> map) {

		HashMap<String, Object> result = new HashMap<>();

		HashMap<String, Object> orderDetail = null;

		try {

			List<HashMap<String, Object>> orders = sellerMapper.selectOrderDetail(map);

			if (orders != null && !orders.isEmpty()) {
				orderDetail = orders.get(0);

				result.put("orderDetail", orderDetail);

				result.put("status", "success");

			} else {

				result.put("status", "not_found");
				result.put("message", "해당 주문 ID에 대한 상세 정보를 찾을 수 없습니다.");
			}

		} catch (Exception e) {

			e.printStackTrace();

			result.clear();
			result.put("status", "error");
			result.put("message", "주문 상세 정보 조회 중 시스템 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}



}
