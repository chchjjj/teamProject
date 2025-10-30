<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/css/cart-style.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/main/header.jsp" %>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="product-detail-container">
    <div class="product-info-area">
        <div class="product-selection-section">

            <label class="product-card selected-product">
                <input type="radio" name="product_option" value="cake_a" checked>
                <div class="product-card-content">
                    <div class="radio-button-circle"></div>
                    <div class="product-details">
                        <h3 class="store-name">ㅇㅇ네 케이크</h3>
                        <div class="item-info">
                            <div class="item-left">
                                <div class="item-image-placeholder"></div>
                                <div class="item-text">
                                    <p class="item-title">귀여운 생일 전용 레터링 케이크</p>
                                    <p class="item-delivery">11월 12일 픽업</p>
                                    <p class="item-description">생크림, 시트, 초코, 토핑재료, 케이크, 토핑하는 바나나 등등...</p>
                                    <p class="item-price-detail">가격 + 배송비 : 20,500 + 0 = 23,500</p>
                                </div>
                            </div>
                            <div class="item-right">
                                <p class="item-final-price">23,500원</p>
                                <div class="quantity-control">
                                    <button class="quantity-btn" disabled>&lt;</button>
                                    <input type="text" value="1" readonly>
                                    <button class="quantity-btn">&gt;</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </label>

            <label class="product-card">
                <input type="radio" name="product_option" value="cake_b">
                <div class="product-card-content">
                    <div class="radio-button-circle"></div>
                    <div class="product-details">
                        <h3 class="store-name">ㅇㅇ네 케이크</h3>
                        <div class="item-info">
                            <div class="item-left">
                                <div class="item-image-placeholder"></div>
                                <div class="item-text">
                                    <p class="item-title">졸업 전용 케이크</p>
                                    <p class="item-delivery">11월 30일 예약배송</p>
                                    <p class="item-description">초코, 시트, 초코, 토핑재료, 케이크, 토핑하는 바나나 등등...</p>
                                    <p class="item-price-detail">가격 + 배송비 : 29,500 + 3000 = 32,500</p>
                                </div>
                            </div>
                            <div class="item-right">
                                <p class="item-final-price">32,500원</p>
                                <div class="quantity-control">
                                    <button class="quantity-btn" disabled>&lt;</button>
                                    <input type="text" value="1" readonly>
                                    <button class="quantity-btn">&gt;</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </label>

            <div class="order-button-container">
                <button class="order-button">주문하기</button>
            </div>
        </div>
    </div>
</div>
    </div>
    <%@ include file="/WEB-INF/main/footer.jsp" %>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>