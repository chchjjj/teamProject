package com.example.teamProject.seller.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.teamProject.seller.model.ProductImgDTO;

@Mapper // MyBatis Mapper임을 명시
public interface ProductImgMapper {
    
    // 1. [등록/수정] 이미지 정보 목록을 받아 PRODUCT_IMG_TBL에 일괄 삽입
	int insertProductImages(ProductImgDTO img);

    // 2. [수정] PRO_NO를 기준으로 기존 파일 목록(주로 파일명)을 조회
    // 물리 파일 삭제를 위해 사용됩니다.
    List<ProductImgDTO> selectImagesByProNo(int proNo);

    // 3. [수정] PRO_NO를 기준으로 DB의 이미지 정보를 일괄 삭제
    // 새로운 이미지 정보를 넣기 전에 기존 정보를 지웁니다.
    int deleteImagesByProNo(int proNo);
}