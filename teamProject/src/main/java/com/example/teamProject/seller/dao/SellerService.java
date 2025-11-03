package com.example.teamProject.seller.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

	// 판매자 가게 리스트 불러오기
		public HashMap<String, Object> getChat(String orderId) {
			HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List<HashMap<String, Object>> list = sellerMapper.selectChatPass(orderId);
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
		
		
	  

	    public List<Seller> selectChatHistoryByOrderId(Long orderId) {
	        try {
	            System.out.println("DEBUG: [ChatService] 채팅 기록 조회 시도. Order ID: " + orderId);
	            List<Seller> history = sellerMapper.selectChatHistoryByOrderId(orderId);
	            System.out.println("DEBUG: [ChatService] 채팅 기록 조회 성공. 결과 개수: " + history.size());
	            return history;
	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 채팅 기록 조회 중 오류 발생 - Order ID: " + orderId);
	            e.printStackTrace();
	            return List.of(); 
	        }
	    }

	    @Transactional
	    public void sendMessage(Seller message) {
	        try {
	            System.out.println("DEBUG: [ChatService] 메시지 전송 트랜잭션 시작. Order ID: " + message.getOrderId());
	            
	            sellerMapper.insertChatMessage(message);
	            System.out.println("DEBUG: [ChatService] 1. 새 메시지 DB 저장 성공.");

	            sellerMapper.updateChatRoomLastMessage(message); 
	            System.out.println("DEBUG: [ChatService] 2. 채팅방 정보 업데이트 성공.");

	            System.out.println("DEBUG: [ChatService] 메시지 전송 트랜잭션 성공적으로 완료.");

	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 메시지 전송 및 채팅방 업데이트 트랜잭션 실패 - Order ID: " + message.getOrderId());
	            e.printStackTrace();
	            
	            // 🚨 중요: @Transactional이 Exception 발생 시 롤백하려면 RuntimeException을 다시 던져야 합니다.
	            throw new RuntimeException("메시지 전송 처리 실패", e);
	        }
	    }

	    public void updateMessageReadStatus(Long orderId, String readerId) {
	        try {
	            System.out.println("DEBUG: [ChatService] 메시지 읽음 처리 시도. Order ID: " + orderId + ", Reader ID: " + readerId);
	            sellerMapper.updateMessageReadStatus(orderId, readerId);
	            System.out.println("DEBUG: [ChatService] 메시지 읽음 처리 성공.");
	        } catch (Exception e) {
	            System.err.println("ERROR: [ChatService] 메시지 읽음 처리 중 오류 발생 - Order ID: " + orderId);
	            e.printStackTrace();
	        }
	    }
	    
	    public HashMap<String, Object> selectReviewList(HashMap<String, Object> param) {
	        
	        HashMap<String, Object> resultMap = new HashMap<>();
	        
	        try {
	            // MyBatis Mapper의 selectReviewList를 호출합니다.
	            // 쿼리 결과는 List<HashMap<String, Object>> 형태입니다.
	            resultMap.put("list", sellerMapper.selectReviewList(param));
	            
	        } catch (Exception e) {
	            System.err.println("리뷰 목록 조회 서비스 에러: " + e.getMessage());
	            // 에러 발생 시 빈 목록을 반환하거나, 에러 처리를 할 수 있습니다.
	            resultMap.put("list", null); 
	            resultMap.put("result", "error");
	        }
	        
	        return resultMap;
	    }
	    
	    
}
