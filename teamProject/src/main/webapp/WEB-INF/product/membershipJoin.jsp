<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>멤버십 가입</title>
        <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
            body {
                margin: 0;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", sans-serif;
                background-color: #f5f6f8;
            }

            .membership-wrap {
                max-width: 920px;
                margin: 60px auto;
                padding: 0 16px;
                display: flex;
                gap: 24px;
            }

            .membership-card {
                background: #ffffff;
                border-radius: 20px;
                padding: 32px 24px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                flex: 1;
            }

            .membership-title {
                text-align: center;
                margin-bottom: 12px;
            }

            .membership-title h1 {
                font-size: 24px;
                font-weight: 700;
                margin: 0;
            }

            .membership-subtitle {
                text-align: center;
                font-size: 14px;
                color: #777;
                margin-bottom: 24px;
            }

            .benefit-list {
                margin-bottom: 32px;
            }

            .benefit-item {
                display: flex;
                align-items: center;
                padding: 14px 0;
                border-bottom: 1px solid #eee;
                font-size: 15px;
            }

            .benefit-item:last-child {
                border-bottom: none;
            }

            .benefit-icon {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: rgba(230, 230, 230, 0.89);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                margin-right: 14px;
                font-size: 14px;
            }

            .price-box {
                text-align: center;
                margin-bottom: 24px;
            }

            .price {
                font-size: 28px;
                font-weight: 700;
            }

            .price span {
                font-size: 15px;
                color: #666;
                font-weight: 400;
            }

            .notice-box {
                background: #f8f9fb;
                border-radius: 12px;
                padding: 16px;
                font-size: 13px;
                color: #666;
                line-height: 1.7;
            }

            .notice-box ul {
                padding-left: 18px;
                margin: 0;
            }

            .notice-box li {
                margin-bottom: 8px;
            }

            .membership-btn {
                width: 100%;
                height: 52px;
                margin-top: 24px;
                border: none;
                border-radius: 14px;
                background: #3E2723;
                color: #fff;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
            }

            /* 모바일 대응 */
            @media (max-width: 768px) {
                .membership-wrap {
                    flex-direction: column;
                }
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>

            <div id="app">
                <div class="membership-wrap">

                    <!-- 왼쪽 : 이용약관 -->
                    <div class="membership-card">
                        <div class="membership-title">
                            <h1>멤버십 이용약관</h1>
                        </div>

                        <div class="membership-subtitle">
                            디저트 연구소 멤버십 서비스 약관
                        </div>

                        <div class="notice-box">
                            <ul>
                                <li>본 멤버십은 판매자 전용 유료 서비스입니다.</li>
                                <li>멤버십 결제는 월 단위로 자동 갱신되며, 결제일 기준으로 매월 동일한 금액이 청구됩니다.</li>
                                <li>결제 완료 즉시 멤버십 혜택이 적용되며, 일부 기능은 시스템 반영에 시간이 소요될 수 있습니다.</li>
                                <li>멤버십 혜택은 회사 정책에 따라 사전 고지 후 변경될 수 있습니다.</li>
                                <li>회원은 언제든지 멤버십 해지가 가능하며, 해지 시 다음 결제일부터 요금이 청구되지 않습니다.</li>
                                <li>중도 해지 시 이미 결제된 금액에 대해서는 환불되지 않습니다.</li>
                                <li>부정 이용 또는 약관 위반 시 멤버십 이용이 제한될 수 있습니다.</li>
                                <li>기타 명시되지 않은 사항은 디저트 연구소 운영 정책을 따릅니다.</li>
                            </ul>
                        </div>
                    </div>

                    <!-- 오른쪽 : 멤버십 가입 -->
                    <div class="membership-card">
                        <div class="membership-title">
                            <h1>멤버십 가입신청</h1>
                        </div>

                        <div class="membership-subtitle">
                            디저트 연구소의 프리미엄 멤버십 혜택
                        </div>

                        <div class="benefit-list">
                            <div class="benefit-item">
                                <div class="benefit-icon">AD</div>
                                메인페이지 배너 광고 등록
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">TOP</div>
                                상품 리스트 상단 노출
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">★</div>
                                추천 딱지 부착
                            </div>
                        </div>

                        <div class="price-box">
                            <div class="price">
                                30,000원 <span>/ 월</span>
                            </div>
                        </div>

                        <button class="membership-btn" @click="fnMembershipPay">
                            멤버십 가입신청
                        </button>
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
                    userId: "${sessionId}",
                };
            },
            methods: {
                fnUpdateMembership: function () {
                    let self = this;
                    $.ajax({
                        url: "/product/updateMembership.dox",
                        dataType: "json",
                        type: "POST",
                        data: { userId: self.userId },
                        success: function (data) {
                            alert("축하합니다. 멤버십에 가입되었습니다!")
                            pageChange("/product/membershipManage.do", {});
                        },
                        error: function (err) {
                            console.error("fnUpdateMembership Ajax 에러:", err);
                            alert("멤버십 가입오류. 관리자에게 문의해주세요.")
                        }
                    });
                },
                // 멤버십 결제
                fnMembershipPay: function () {
                    const self = this;

                    if (!self.userId) {
                        alert("로그인 후 이용해주세요.");
                        location.href = "/user/login.do";
                        return;
                    }

                    const IMP = window.IMP;
                    IMP.init("imp44302855"); // 🔴 본인 아임포트 가맹점 코드

                    IMP.request_pay({
                        pg: "html5_inicis",
                        pay_method: "card",
                        merchant_uid: "membership_" + new Date().getTime(),
                        name: "디저트연구소 판매자 멤버십",
                        amount: 30000,
                        buyer_name: self.userId
                    }, function (rsp) {
                        if (rsp.success) {
                            alert("멤버십 결제가 완료되었습니다.");
                        self.fnUpdateMembership();
                        } else {
                            alert("결제가 취소되었습니다.\n" + rsp.error_msg);
                        }
                    });
                }
            },
            mounted() {
                let self = this;
            }
        });

        app.mount('#app');
    </script>