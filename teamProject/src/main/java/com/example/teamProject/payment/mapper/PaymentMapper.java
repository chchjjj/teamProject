package com.example.teamProject.payment.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.payment.model.Payment;

@Mapper
public interface PaymentMapper {
	Payment selectPayment(HashMap<String, Object> map);
}
