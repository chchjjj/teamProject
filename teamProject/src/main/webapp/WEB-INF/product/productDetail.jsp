<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>제품상세</title>
        <link rel="stylesheet" href="/css/productDetail-style.css">
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>
            <div id="app">

                <div class="product-detail-container">
                    <main class="product-detail-page">
                        <div class="product-info-area">

                            <div class="image-section">
                                <div class="main-image-box">제품 이미지</div>
                                <div class="thumbnail-list">
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                    <div class="thumbnail-item"></div>
                                </div>
                            </div>

                            <div class="option-section">
                                <h2 class="product-name">귀여운 생일 전용 레터링 케이크</h2>
                                <p class="store-name">철수네 케이크</p>

                                <div class="price-and-action">
                                    <p class="price">12,000 ~</p>
                                    <br>
                                    <p class="shipping-fee">배송비 3,000</p>
                                    <img src="/img/좋아요누르기전.png" alt="찜 목록"></a>
                                </div>

                                <button class="delivery-date-btn">픽업/배송 날짜 선택</button>

                                <div class="option-selectors">
                                    <div class="option-item">:: 크기 선택(S/M/L) ::
                                        <span class="material-symbols-outlined"></span>
                                    </div>

                                </div>

                                <div class="lettering-input-area">
                                    <p class="prompt">문구: 레터링 문구를 입력하시오.</p>
                                </div>

                                <div class="action-buttons">
                                    <button class="buy-btn">구매</button>
                                    <button class="cart-btn">장바구니</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-menu">
                            <button class="tab-btn active">상세정보</button>
                            <button class="tab-btn">리뷰</button>
                            <button class="tab-btn">QnA</button>
                        </div>

                        <div class="tab-content">
                        </div>
                    </main>
                </div>

            </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    proNo : "${proNo}"
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