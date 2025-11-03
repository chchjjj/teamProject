package com.example.teamProject.payment.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.teamProject.payment.dao.PaymentService;

@Controller
public class PaymentController {

	@Autowired
	PaymentService paymentService;
	
	@RequestMapping("/payment/payment.do")
	public String login(Model model) throws Exception {
		
		return "/payment/payment"; 
	}
}
