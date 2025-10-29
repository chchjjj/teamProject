package com.example.teamProject.product.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ProductController {

	@RequestMapping("/productDetail.do") 
    public String productDetail(Model model) throws Exception{

        return "/product/productDetail";
    }
}
