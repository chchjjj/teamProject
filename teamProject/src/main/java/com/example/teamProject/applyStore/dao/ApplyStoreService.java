package com.example.teamProject.applyStore.dao;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.teamProject.applyStore.mapper.ApplyStoreMapper;

@Service
public class ApplyStoreService {
    
    @Autowired
    private ApplyStoreMapper applyStoreMapper;

    // 가게 정보 입력
    public HashMap<String, Object> insertStoreInfo(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            
            int rowsAffected = applyStoreMapper.insertSellerInfo(map);  

            if (rowsAffected > 0) {
                resultMap.put("success", true);
                resultMap.put("message", "입점 신청이 성공적으로 완료되었습니다.");
            } else {
                resultMap.put("success", false);
                resultMap.put("message", "입점 신청이 실패했습니다.");
            }
        } catch (Exception e) {
            resultMap.put("success", false);
            resultMap.put("message", "서버 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }

        return resultMap;
    }

    // 가게 정보 조회
public Integer getStoreIdByStoreNameAndUserId(String storeName, String userId) {
        
        System.out.println("Service: getStoreIdByStoreNameAndUserId 호출 - Store Name: " + storeName + ", User ID: " + userId);

        // ⭐ Mapper 호출: DB에서 storeName과 userId가 일치하는 storeId를 조회
        // 이 메서드는 정리된 Mapper의 selectStoreIdByStoreNameAndUserId를 호출합니다.
        try {
            Integer storeId = applyStoreMapper.selectStoreIdByStoreNameAndUserId(storeName, userId);
            
            if (storeId == null) {
                System.out.println("Service: 조회된 가게 번호 없음.");
            } else {
                System.out.println("Service: 조회된 가게 번호: " + storeId);
            }
            return storeId;
            
        } catch (Exception e) {
            System.err.println("Service: 가게 번호 조회 중 DB 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return null; // 오류 발생 시 null 반환
        }
    }
  
    
    
}
