package com.example.teamProject.seller.dao;
import java.util.List;

import org.springframework.stereotype.Service; // ⭐ 반드시 추가해야 함
import org.springframework.web.multipart.MultipartFile;

@Service // ⭐ 이 어노테이션을 추가해야 @Autowired로 주입 가능
public class FileService {

    // 파일 업로드 관련 service 잘못만든 아님 삭제하면 안됨
    
    // registerProduct에서 호출됨
    public void uploadProductImages(int proNo, MultipartFile thumbnailFile, List<MultipartFile> detailFiles, MultipartFile longFile) {
       
        System.out.println("DEBUG: [FileService] 파일 업로드 및 DB 저장 처리 (proNo: " + proNo + ")");
      
    }

    // updateProduct에서 호출됨
    public void updateProductImages(int proNo, MultipartFile thumbnailFile, List<MultipartFile> detailFiles, MultipartFile longFile) {
         // 실제 파일 처리 및 DB 저장 로직 (기존 파일 삭제 및 새 파일 등록 등)
         System.out.println("DEBUG: [FileService] 파일 수정 및 DB 업데이트 처리 (proNo: " + proNo + ")");
    }
}