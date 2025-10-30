package com.example.teamProject.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.main.model.Main;
import com.example.teamProject.product.model.Product;

@Mapper
public interface ProductMapper {
	
	Product proInfo(HashMap<String, Object> map);
	
	// 상위옵션
	List<Product> topOptList(HashMap<String, Object> map); 
	
	// 상위옵션+하위옵션
	List<Product> allOptList(HashMap<String, Object> map); 
}
