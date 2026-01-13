<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>멤버십 관리</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <style>
            body {
                background: #f5f6f8;
            }

            .membership-container {
                max-width: 720px;
                margin: 60px auto;
                background: #fff;
                border-radius: 16px;
                padding: 40px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            }

            .membership-title {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 24px;
            }

            .info-box {
                display: flex;
                justify-content: space-between;
                padding: 18px 0;
                border-bottom: 1px solid #eee;
                font-size: 15px;
            }

            .info-box span {
                color: #666;
            }

            .info-box strong {
                font-weight: 600;
            }

            .highlight {
                color: #ff0000;
                font-weight: 700;
            }

            .btn-group {
                margin-top: 32px;
                display: flex;
                gap: 12px;
            }

            .btn {
                flex: 1;
                padding: 14px 0;
                border-radius: 10px;
                border: none;
                font-size: 15px;
                cursor: pointer;
            }

            .btn-primary {
                background: #3E2723;
                color: #fff;
            }

            .btn-outline {
                background: #fff;
                border: 1px solid #ddd;
                color: #333;
            }

            .btn-danger {
                background: #f44336;
                color: #fff;
            }

            .terms {
                margin-top: 36px;
                font-size: 13px;
                line-height: 1.7;
                color: #777;
                background: #fafafa;
                padding: 20px;
                border-radius: 10px;
            }
        </style>
    </head>

    <body>
        <%@ include file="/WEB-INF/main/header.jsp" %>

            <div id="app">
                <div class="membership-container">
                    <div class="membership-title">판매자 멤버십 관리</div>

                    <div class="info-box">
                        <span>멤버십 상태</span>
                        <strong class="highlight">{{ membershipStatusText }}</strong>
                    </div>


                    <div class="info-box">
                        <span>가입일</span>
                        <strong>{{ joinDate }}</strong>
                    </div>

                    <div class="info-box">
                        <span>{{ dateLabel }}</span>
                        <strong>{{ nextPayDate }}</strong>
                    </div>


                    <div class="info-box">
                        <span>총 이용 기간</span>
                        <strong>{{ usedMonths }} 개월</strong>
                    </div>

                    <div class="btn-group">
                        <button class="btn btn-primary" @click="fnAdBanner">
                            광고 배너 등록하기
                        </button>
                        <button class="btn btn-danger" @click="fnCancelMembership" :disabled="membershipStatus === 'B'">
                            {{ membershipStatus === 'B' ? '해지 중' : '멤버십 해지' }}
                        </button>
                    </div>

                    <div class="terms">
                        <strong>[멤버십 이용약관]</strong><br><br>
                        · 멤버십은 월 단위로 자동 결제됩니다.<br>
                        · 결제일 전 해지 시 다음 결제는 발생하지 않습니다.<br>
                        · 멤버십 혜택은 해지 시 즉시 종료됩니다.<br>
                        · 광고 배너는 내부 심사 후 노출됩니다.<br>
                        · 기타 문의사항은 고객센터를 이용해주세요.
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
            joinDate: "",
            nextPayDate: "",
            usedMonths: 0,
            membershipStatus: "",       // 서버 상태 반영
            membershipStatusText: "",
            dateLabel: "다음 결제일"
        };
    },
    methods: {
        fnCheckMembership() {
            let self = this;
            $.ajax({
                url: "/main/checkmembership.dox",
                type: "POST",
                dataType: "json",
                data: { userId: self.userId },
                success(data) {
                    if (!data.info) return;
                    const info = data.info;

                    // 가입일 항상 처리
                    self.joinDate = info.joinDate ? info.joinDate.substring(0, 10) : "-";

                    // 서버 상태 그대로 반영
                    self.membershipStatus = info.membershipStatus;
                    self.membershipStatusText = info.membershipStatus === "B" ? "해지 중" : "이용 중";
                    self.dateLabel = info.membershipStatus === "B" ? "멤버십 만료일" : "다음 결제일";
                    self.nextPayDate = info.expirationDate ? info.expirationDate.substring(0, 10) : self.nextPayDate;

                    // 다음 결제일 계산 (이용 중일 때만)
                    if (info.membershipStatus !== "B") {
                        const [jy, jm, jd] = self.joinDate.split("-").map(Number);
                        const now = new Date();
                        let year = now.getFullYear();
                        let month = now.getMonth();
                        let lastDay = new Date(year, month + 1, 0).getDate();
                        let payDay = Math.min(jd, lastDay);
                        let nextPay = new Date(year, month, payDay);

                        if (nextPay < now) {
                            month++;
                            lastDay = new Date(year, month + 1, 0).getDate();
                            payDay = Math.min(jd, lastDay);
                            nextPay = new Date(year, month, payDay);
                        }

                        const yyyy = nextPay.getFullYear();
                        const mm = String(nextPay.getMonth() + 1).padStart(2, "0");
                        const dd = String(nextPay.getDate()).padStart(2, "0");

                        self.nextPayDate = yyyy + '-' + mm + '-' + dd;
                    }

                    // 이용 개월 수 계산
                    const join = new Date(info.joinDate);
                    const now = new Date();
                    self.usedMonths = (now.getFullYear() - join.getFullYear()) * 12 +
                                      (now.getMonth() - join.getMonth()) + 1;
                },
                error(err) {
                    console.error("fnCheckMembership Ajax 에러:", err);
                }
            });
        },

        fnAdBanner() {
            location.href = "/product/membershipIMG.do";
        },

        fnCancelMembership() {
            if (this.membershipStatus === "B") return; // 이미 해지 중이면 실행 금지

            if (confirm("멤버십을 해지하시겠습니까?")) {
                let self = this;
                $.ajax({
                    url: "/product/deleteMembership.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        userId: self.userId,
                        expirationDate: self.nextPayDate // DB에 해지 날짜 전달
                    },
                    success(data) {
                        alert("해지되었습니다");

                        // 해지 후 서버 상태 다시 가져오기
                        self.fnCheckMembership();
                    },
                    error(err) {
                        console.error("fnCancelMembership Ajax 에러:", err);
                        alert("멤버십 오류. 관리자에게 문의해주세요.");
                    }
                });
            }
        }
    },
    mounted() {
        this.fnCheckMembership();
    }
});

app.mount("#app");
</script>
