<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>:: 디저트 연구소 ::</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!--페이지 이동-->
    <script src="/js/page-change.js"></script>
    <style>
        
    .main-membership{
        margin-top: 20px;
        margin-left: 20px;
    }

    .main-membership img{
        width: 400px;      
        height: 300px;
        border-radius: 10px;
    }

    .container {
        width: 1000px;
        margin: 0 auto;
    }

    #mapDessert{
        width: 400px ;
        height: 100px;
        box-sizing: border-box;
        border-radius: 10px; 
               
    }

    #cart{
        width: 400px ;
        height: 100px;
        box-sizing: border-box;
        border-radius: 10px;                
    }

    .category-wrap {
    display: flex;              /* 가로 정렬 */
    justify-content: center;    /* 가운데 정렬 (원하면 space-between 등으로 조정 가능) */
    align-items: center;        /* 세로축 정렬 */
    flex-wrap: wrap;            /* 화면 작을 때 자동 줄바꿈 (필요 없으면 제거) */
    }   

    .category{
        text-align: center;
        border: 1px solid rgb(189, 170, 170);
        border-radius: 50%;  
        margin: 50px;
        width: 150px;
        height: 150px;
        background-image: url(""); 
        background-size: cover;
        background-repeat: no-repeat;        
        display: flex;
        justify-content: center;   /* 가로 가운데 정렬 */
        align-items: center;       /* 세로 가운데 정렬 */
        text-align: center;        /* 여러 줄일 때 가운데 정렬 유지 */
    }
    

    </style>
</head>
<body>
    <!-- 헤더 -->
        <%@ include file="/WEB-INF/main/header.jsp" %>

    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->        

        <div class="container">

            <!-- 멤버십 가게 광고 패널 / 내 주변 가게 찾기 / 장바구니 -->
            <div>★ 디저트 연구소 추천 상품! </div> 
            <span class="main-membership">
                <button><</button>
                <img src="/img/member_cookies.jpg" alt="멤버쉽 광고 패널">
                <button>></button>
            </span>
            <span>
                <button id="mapDessert" @click="fnMapDessert">내 주변 디저트 찾기</button>
                <button id="cart" @click="fnCart">장바구니</button>
                <!--주변 디저트 & 장바구니 모두 로그인 해야 넘어가도록-->
            </span>

            <!-- 카테고리 원형 버튼 영역 -->
            <!-- 클릭 시 해당 디저틑 카테고리 리스트만 나오게 (디폴트 : 케이크)-->
            <!-- 마우스 갖다댈 때 색 바뀌고 & 현재 클릭된 애가 색칠되어 나오게 구현해야함-->
            <div class="category-wrap">
                <div class="category" v-model="cake" @click="fnList">케이크</div>
                <div class="category" v-model="cookies" @click="fnList">수제쿠키</div>
                <div class="category" v-model="candy" @click="fnList">초콜릿/사탕</div>
                <div class="category" v-model="etd" @click="fnList">잡화</div>
            </div>

            <!-- 지역별 / 인기순 조회 -->
            <div>
                <!-- 지역별 조회-->
                <select v-model="area" @change="fnList">
                    <option value="">:: 지역별조회 ::</option> <!--전체-->
                    <option value="1">:: 서울 ::</option>
                    <option value="2">:: 인천 ::</option>
                    <option value="3">:: 경기 ::</option>
                    <option value="4">:: 강원 ::</option>
                    <option value="5">:: 대전/세종/충청 ::</option>
                    <option value="6">:: 광주/전북/전남 ::</option>
                    <option value="7">:: 부산/대구/울산 ::</option>
                    <option value="8">:: 경북/경남 ::</option>
                    <option value="9">:: 제주 ::</option>

                </select>

                <!--정렬 조건(번호,제목 : 오름차순 / 조회수 : 내림차순 / 시간순 : 내림차순)-->
                <select v-model="order" @change="fnList">
                    <option value="1">:: 조회순 ::</option>
                    <option value="2">:: 판매순 ::</option>
                    <option value="3">:: 최신순 ::</option>
                </select>
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

                // 메인 상단 - 멤버쉽 화면 홍보 이미지
                productImages: [
                    '/img/member_cookies.jpg',
                    '/img/member_cake.jpg'
                    // ...
                ],

                list : [], 
                userId : "${userId}", // 로그인 했을 시 전달 받은 아이디
                area : "", // 디폴트 : 전체 지역 조회
                order : 1 // 디폴트 :  조회순 정렬

            };
        },

        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    // 선택할 때마다 새로 목록 가져오게 해야함(위에서 @change 처리함)
                    area : self.area, 
                    order : self.order,
                };
                $.ajax({
                    url: "", // 상품 리스트 조회주소 넣어야함
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
						console.log(data);
                        self.list = data.list; // data에 있는 list 값을 변수 list에 담기                       
                    }
                });
            },

            // 내 주변 디저트 찾기
            fnMapDessert : function () {
                let self = this;
                if(self.userId == "" || self.userId == null){
                    alert("로그인 후 이용해주세요");
                    location.href="/user/login.do"; // 로그인 페이지 이동
                } else {
                    pageChange("", {userId : self.userId}); // 주변 디저트 찾기 페이지 주소 넣어야 함
                }
                
            },

            // 장바구니 이동 
            fnCart : function () {
                let self = this;
                if(self.userId == "" || self.userId == null){
                    alert("로그인 후 이용해주세요");
                    location.href="/user/login.do"; // 로그인 페이지 이동
                } else {
                    pageChange("", {userId : self.userId}); // 장바구니 페이지 주소 넣어야 함
                }
            },


        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            console.log(self.userId); // 로그인한 아이디 잘 넘어오나 테스트
        }
    });

    app.mount('#app');
</script>