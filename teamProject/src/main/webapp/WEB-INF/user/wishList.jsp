<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/main/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <style>
       .container {
    max-width: 900px;
    margin: 50px auto;
    padding: 20px;
}


.wishlist-controls {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid #ddd;
}
.wishlist-controls label {
    margin-right: 20px;
    font-size: 1em;
}
.delete-btn {
    background-color: #888;
    color: white;
    border: none;
    padding: 8px 15px;
    cursor: pointer;
    border-radius: 4px;
    font-size: 0.9em;
}


.wishlist-item {
    display: flex;
    align-items: center;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    transition: box-shadow 0.2s;
}
.wishlist-item:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}

.item-checkbox {
    margin-right: 20px;
    transform: scale(1.2); /* 체크박스 크기 약간 키우기 */
}

.item-image {
    width: 100px;
    height: 100px;
    background-color: #f0f0f0; /* 이미지 플레이스홀더 색상 */
    border-radius: 4px;
    margin-right: 20px;
}

.item-details {
    flex-grow: 1; /* 남은 공간 차지 */
    text-align: left;
}
.store-name {
    font-size: 0.9em;
    color: #555;
    margin-bottom: 5px;
    display: flex;
    align-items: center;
}
.heart-icon {
    color: red;
    margin-left: 5px;
}
.product-name {
    font-weight: bold;
    font-size: 1.1em;
}
.item-price {
    font-weight: bold;
    font-size: 1.3em;
    color: #333;
    margin-left: 30px;
}


.empty-wishlist-message {
    text-align: center;
    padding: 100px 0;
    font-size: 1.2em;
    color: #777;
    border: 1px solid #eee;
    border-radius: 8px;
    margin-top: 50px;
}


.page-title {
    font-size: 1.8em;
    font-weight: bold;
    border-bottom: 2px solid #eee;
    padding-bottom: 15px;
    margin-bottom: 20px;
}

    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <div class="container">
            <h2 class="page-title">위시 리스트</h2>

            <div v-if="wishlist.length > 0">
                <div class="wishlist-controls">
                    <label>
                        <input type="checkbox" @change="toggleAllCheckboxes" v-model="selectAll"> 전체선택
                    </label>
                    <button class="delete-btn" @click="deleteSelectedItems">선택삭제</button>
                </div>
                
                <div class="wishlist-item" v-for="item in wishlist" :key="item.id">
                    <input type="checkbox" name="selectedItem" class="item-checkbox" :value="item.id" v-model="selectedItems">
                    
                    <div class="item-image"></div>
                    <div class="item-details">
                        <div class="store-name">
                            {{ item.storeName }}
                            <span class="heart-icon">♥</span>
                        </div>
                        <div class="product-name">{{ item.productName }}</div>
                    </div>
                    <div class="item-price">{{ item.price }}</div>
                </div>
            </div>

            <div v-else class="empty-wishlist-message">
                위시 제품이 없습니다.
            </div>
            
        </div>
         
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                wishlist: [],
                selectedItems: [],
                selectAll: false,
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "/user/wishlist",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.wishlist = data.list;
                        self.wishlist = self.dummyWishlist;
                    },
                    error : function(xhr,status,error){
                        console.error("AJAX 통신 실패:", status, error);
                        self.wishlist = self.dummyWishlist; // 통신 실패 시에도 더미 데이터 사용
                    }
                
                });
            },// 전체 선택/해제 기능
            toggleAllCheckboxes: function() {
                this.selectedItems = this.selectAll 
                    ? this.wishlist.map(item => item.id) 
                    : []; 
            },
            // 선택 삭제 기능
            deleteSelectedItems: function() {
                if (this.selectedItems.length === 0) {
                    alert('삭제할 위시 제품을 선택해주세요.');
                    return;
                }
                if (confirm(this.selectedItems.length + '개의 상품을 위시리스트에서 삭제하시겠습니까?')) {
                    // 실제 삭제 로직 (AJAX 통신)
                    let self = this;
                    $.ajax({
                        url: "/user/deleteWishlist",
                        type: "POST",
                        data: { productIds: self.selectedItems },
                        success: function() {
                            alert('선택한 상품이 삭제되었습니다.');
                            self.fnList(); // 목록 새로고침
                        }
                    });

                    // 프론트엔드 테스트: 실제로 삭제된 것처럼 목록에서 제거
                    this.wishlist = this.wishlist.filter(item => !this.selectedItems.includes(item.id));
                    this.selectedItems = []; // 선택 목록 초기화
                    this.selectAll = false;
                    alert('선택한 상품이 삭제되었습니다. (테스트)');
            }

        }, // methods
        watch: {
            // 개별 체크박스 상태 변화를 감지하여 '전체선택' 체크박스 상태 업데이트
            selectedItems: function() {
                if (this.selectedItems.length === this.wishlist.length && this.wishlist.length > 0) {
                    this.selectAll = true;
                } else {
                    this.selectAll = false;
                }
            }
        }
        },
        // computed: {
        //     // 가상 데이터 (실제 프로젝트에서는 fnList의 success 내에서 서버 데이터 사용)
        //     dummyWishlist() {
        //         return [
        //             { id: 1, storeName: '○○네 케이크', productName: '귀여운 생일 전용 레터링 케이크', price: '23,500원' },
        //             { id: 2, storeName: '△△ 디저트', productName: '수제 마카롱 10종 세트', price: '19,900원' },
        //             { id: 3, storeName: '☆☆ 베이킹', productName: '수제 초코칩 쿠키 박스', price: '15,000원' },
        //         ];
        //         // return []; // 위시리스트가 비었을 때 테스트하려면 이 코드를 사용하세요.
        //     }
        // },
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>