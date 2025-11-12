<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 (판매자) - 상품 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
    /* ---------------------------------------------------- */
    /* 1. Color Variables & Global Styles (Espresso Theme) */
    /* ---------------------------------------------------- */
    :root {
        --espresso: #3E2723; /* 주요 색상: 짙은 갈색 */
        --peony: #F4C9D6; /* 보조 색상: 분홍색 */
        --butter: #FFEDAC; /* 배경 및 하이라이트: 버터색 */
        --light-bg: #F4F4F4; /* 밝은 배경 */
        --white: #FFFFFF;
        --primary-color: var(--espresso); /* 주요 버튼 색상 */
        --secondary-color: var(--peony); /* 보조 버튼/강조 색상 */
    }

    body {
        margin: 0;
        font-family: 'Malgun Gothic', sans-serif;
        background-color: var(--light-bg);
    }

    /* ---------------------------------------------------- */
    /* 2. Layout (Wrapper & Sidebar & Content) */
    /* ---------------------------------------------------- */
    .main-wrapper {
        display: flex;
        min-height: 100vh; /* 전체 높이 사용 */
    }

    /* 사이드바 스타일 (고정) */
    .sidebar {
        width: 220px;
        background-color: var(--butter);
        flex-shrink: 0;
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        padding-top: 20px;
    }

    .sidebar-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar-menu a {
        display: block;
        padding: 15px 20px;
        text-decoration: none;
        color: var(--espresso);
        font-weight: bold;
        transition: background-color 0.2s, color 0.2s;
    }

    .sidebar-menu a:hover {
        background-color: var(--espresso);
        color: var(--white);
    }

    .sidebar-menu .active a {
        background-color: var(--espresso);
        color: var(--white);
        border-left: 5px solid var(--peony);
        padding-left: 15px;
    }

    /* 콘텐츠 영역 */
    .content-area {
        flex-grow: 1;
        padding: 30px;
        background-color: var(--light-bg);
        margin-left: 220px; /* 사이드바 너비만큼 공간 확보 */
    }

    .page-title {
        font-size: 24px;
        font-weight: 300;
        margin-bottom: 20px;
        color: var(--primary-color);
        padding-bottom: 10px;
        border-bottom: 2px solid var(--primary-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* ---------------------------------------------------- */
    /* 3. Product Card & Buttons (New Design 적용) */
    /* ---------------------------------------------------- */
    .product-card {
        /* 상품 카드 디자인 업데이트 */
        border: 1px solid #e0e0e0;
        padding: 15px;
        margin-bottom: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: var(--white); /* 흰색 배경 */
        transition: all 0.3s ease;
    }

    .product-card:hover {
        box-shadow: 0 3px 15px rgba(62, 39, 35, 0.1);
        border-color: var(--peony);
    }

    .product-info {
        flex-grow: 1;
    }

    .product-info h4 {
        margin: 0 0 5px 0;
        font-size: 17px;
        color: var(--primary-color); /* 에스프레소 색상 */
        font-weight: 600;
    }

    .product-details {
        font-size: 13px;
        color: #777;
    }

    .product-details span {
        margin-right: 15px;
    }
    
    .product-details strong {
        color: var(--espresso);
    }

    /* 일반 버튼 스타일 (공통) */
    .product-actions button,
    button {
        padding: 8px 15px;
        border: 1px solid var(--primary-color);
        background-color: var(--white);
        color: var(--primary-color);
        cursor: pointer;
        margin-left: 5px;
        border-radius: 6px;
        font-weight: 600;
        transition: all 0.2s ease;
    }
    
    .product-actions button:hover,
    button:hover {
        background-color: var(--primary-color);
        color: var(--white);
        transform: translateY(-1px);
    }

    /* 수정/강조 버튼 스타일 (Peony 사용) */
    .product-actions .modify-btn {
        background-color: var(--secondary-color); /* 피오니 배경색 */
        color: var(--primary-color); /* 에스프레소 글자색 */
        border: 1px solid var(--secondary-color);
    }

    .product-actions .modify-btn:hover {
        background-color: #f0b8ca; /* 약간 어두운 피오니 */
        color: var(--primary-color);
    }

    /* 상품 등록 버튼 (Page Title 옆) */
    .add-product-btn {
        padding: 10px 20px;
        background-color: var(--primary-color); /* 에스프레소 배경색 */
        color: var(--white);
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
    }

    .add-product-btn:hover {
        background-color: #5d4037; /* 약간 어두운 에스프레소 */
    }
    
    /* ---------------------------------------------------- */
    /* 4. Responsive adjustments */
    /* ---------------------------------------------------- */
    @media (max-width: 768px) {
        .sidebar {
            position: static;
            width: 100%;
            height: auto;
            padding-top: 10px;
        }

        .sidebar-menu {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            padding: 0 10px;
        }

        .sidebar-menu a {
            padding: 10px 15px;
            text-align: center;
            border-left: none !important;
            border-bottom: 3px solid transparent;
        }

        .sidebar-menu .active a {
            border-left: none;
            border-bottom: 3px solid var(--peony);
            padding-left: 15px;
        }

        .content-area {
            margin-left: 0;
            padding: 20px 15px;
        }
        
        .product-card {
            flex-direction: column;
            align-items: stretch;
            gap: 10px;
        }
        
        .product-actions {
            display: flex;
            gap: 8px;
            width: 100%;
        }
        
        .product-actions button {
            flex: 1;
            margin-left: 0;
        }
    }
</style>
</head>

<body>
    <div id="app">
        <div class="main-wrapper">
            <div class="content-area">
                <h1 class="page-title">
                    상품 관리
                    <button class="add-product-btn" @click="fnGoProductAdd(storeId)">
                        + 새 상품 등록
                    </button>
                </h1>

                <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 20px;">

                <div v-if="productList.length === 0" style="text-align: center; padding: 50px; color: #999;">
                    등록된 상품이 없습니다. '새 상품 등록' 버튼을 이용해 상품을 등록해주세요.
                </div>

                <div v-for="product in productList" :key="product.proNo" class="product-card">
                    <div class="product-info">
                        <h4>{{ product.proName }} (No. {{ product.proNo }})</h4>
                        <div class="product-details">
                            <span>가격: **{{ product.price.toLocaleString() }}**원</span>
                            <span>재고: {{ product.stockQty }}개</span>
                            <span>판매 상태: **{{ product.status === 'Y' ? '판매 중' : '판매 중지' }}**</span>
                            <span>등록일: {{ product.createdAt.substring(0, 10) }}</span>
                        </div>
                    </div>
                    <div class="product-actions">
                        <button class="modify-btn"
                            :onclick="'location.href=\'/seller/productinfo.do?proNo=' + product.proNo + '\''">
                            알르레기 표시 추가
                        </button>
                        <button class="modify-btn"
                            :onclick="'location.href=\'/seller/productUpdate.do?proNo=' + product.proNo + '\''">
                            수정
                        </button>
                        <button @click="fnDeleteProduct(product.proNo)">
                            삭제
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                productList: [], // 상품 목록 데이터를 저장할 배열
                // 🌟 중요: Controller에서 Model에 담아 전달한 storeId 값으로 초기화해야 합니다.
                // 이 값이 없다면, Controller에서 이 페이지를 로드하기 전에 storeId를 DB에서 조회해 Model에 담아주어야 합니다.
                storeId: "${storeId}", // 예: Controller에서 ${storeId}에 45가 담겨 넘어왔다고 가정
                userId: "${sessionId}",
            };
        },
        methods: {
            /** 상품 목록 조회 (AJAX 통신) */
            fnProductList: function () {
                let self = this;
                
                // storeId가 유효한지 확인
                if (!self.storeId || self.storeId === 'null' || self.storeId === 'undefined') {
                    console.error("storeId가 유효하지 않습니다. 상품 목록 조회를 중단합니다.");
                    return;
                }
                
                let param = {
                    storeId: self.storeId
                };

                // TODO: 실제 상품 목록 조회 URL로 변경해야 합니다.
                $.ajax({
                    url: "/seller/productlist.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // Mybatis에서 resultType이 Seller Model이므로, 리스트 내부는 객체 형태일 것입니다.
                        self.productList = data.list;
                        console.log("상품 목록 조회 성공:", data.list);
                    },
                    error: function (xhr, status, error) {
                        console.error("상품 목록 조회 실패:", error);
                        alert("상품 목록 조회에 실패했습니다.");
                    }
                });
            },
            
            /** 🌟 상품 등록 페이지로 이동 (GET 방식 + 쿼리 파라미터) */
            fnGoProductAdd: function (storeId) {
                const targetStoreId = storeId; 

                if (!targetStoreId || targetStoreId === 'null') {
                    alert("가게 ID를 찾을 수 없습니다. (storeId가 설정되지 않았습니다.)");
                    return;
                }

                // location.href를 사용하여 GET 방식으로 페이지 이동 및 쿼리 파라미터 전송
                location.href = '/seller/productAdd.do?storeId=' + targetStoreId;
            },

            // fnDeleteProduct 함수는 proNo(상품 번호)만 사용하므로 storeId 관련 수정은 필요 없습니다.
            fnDeleteProduct: function (proNo) {
                let self = this;

                if (confirm(proNo + "번 상품을 정말로 삭제하시겠습니까?")) {
                    alert("아직 준비중입니다.");
                    // let param = { proNo: proNo };

                    // $.ajax({
                    //     // 상품 삭제를 위한 백엔드 URL
                    //     url: "/seller/productDelete.dox",
                    //     dataType: "json",
                    //     type: "POST", // DELETE 또는 POST 방식 사용
                    //     data: param,
                    //     success: function (data) {
                    //         // 백엔드에서 성공 (1 또는 'success'와 같은 값)을 리턴했다고 가정
                    //         if (data.result === 'success' || data.result > 0) {
                    //             alert("상품이 성공적으로 삭제되었습니다.");
                    //             // 삭제 후 목록을 새로고침
                    //             self.fnProductList();
                    //         } else {
                    //             // DB에서 삭제 실패 (예: 외래 키 제약 조건 등)
                    //             alert("상품 삭제에 실패했습니다. (DB 오류)");
                    //         }
                    //     },
                    //     error: function (xhr, status, error) {
                    //         console.error("상품 삭제 통신 실패:", error);
                    //         alert("상품 삭제 통신에 실패했습니다. 서버 로그를 확인하세요.");
                    //     }
                    // });
                }
            },
        },
        mounted() {
            // 페이지 로드 시 상품 목록을 바로 조회
            this.fnProductList();
        }
    });

    app.mount('#app');
</script>

</html>