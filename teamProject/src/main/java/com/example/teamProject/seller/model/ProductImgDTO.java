package com.example.teamProject.seller.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter // Lombok 사용 시 DTO 필드에 대한 Getter/Setter 자동 생성
public class ProductImgDTO {
    // DB 컬럼과 매핑되는 필드
	private int imgNo;           // 이미지 번호 (PK)
    private int proNo;           // 상품 번호 (FK)
    private String imgPath;      // 이미지 저장 경로 
    private String imgFilename;  // 서버에 저장된 파일명 (UUID)
    private String imgOrgFilename; // 원본 파일명
    private String imgFormat;    // 파일 형식 (JPG, PNG 등)
    private String imgType;      // 이미지 타입 (M:썸네일, I:하위, B:상세)
    // Getter 및 Setter 메서드, B:상세설명)
    
    private Long productImgNum;   // 시퀀스 자동 생성
    
}