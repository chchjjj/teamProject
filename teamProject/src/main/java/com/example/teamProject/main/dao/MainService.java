package com.example.teamProject.main.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.main.mapper.MainMapper;

@Service
public class MainService {
	
	@Autowired
	MainMapper mainMapper;

}
