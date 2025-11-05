package com.example.teamProject.payment.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.payment.model.Payment;

@Mapper
public interface PaymentMapper {
	
	//장바구니에서 선택한 목록 가져오기
	//List<Payment> selectCartList(HashMap<String, Object> map);

	//결제 전 주문 테이블의 배송 관련 정보를 업데이트
	int updateDelivery(HashMap<String, Object> map);

	//주문 리스트 가져오기
	List<Payment> selectOrderList(HashMap<String, Object> map);

	//사용한 장바구니 삭제
	int deleteCartList(HashMap<String, Object> map);
	
	//결제를 하면 결제 테이블에 내역 추가
	int insertPayment(HashMap<String, Object> map);

	


}
