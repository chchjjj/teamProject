package com.example.teamProject.seller.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SellerController {

	@RequestMapping("/seller/list.do") 
    public String area(Model model) throws Exception{

        return "/seller/addComplete";
    }
}
