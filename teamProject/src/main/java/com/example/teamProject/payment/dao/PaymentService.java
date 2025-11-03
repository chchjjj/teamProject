package com.example.teamProject.payment.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.payment.mapper.PaymentMapper;

@Service
public class PaymentService {

	@Autowired
	PaymentMapper paymentMapper;
	
	
	
}
