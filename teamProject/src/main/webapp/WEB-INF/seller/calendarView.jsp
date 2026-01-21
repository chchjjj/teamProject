<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>픽업 일정 확인 캘린더</title>

            <!-- jQuery / Vue / FullCalendar -->
            <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
            <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.css" />
            <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

            <style>
                body {
                    margin: 0;
                    font-family: 'Malgun Gothic', sans-serif;
                    background-color: #f4f4f4;
                }

                .main-wrapper {
                    display: flex;
                    min-height: 100vh;
                }

                .content-area {
                    flex-grow: 1;
                    padding: 30px;
                    background-color: white;
                    margin-left: 220px;
                    box-sizing: border-box;
                }

                .page-title {
                font-size: 28px;
                font-weight: 800;
                color: var(--espresso);
                margin-bottom: 30px;
                padding-left: 15px;
                border-left: 6px solid var(--peony);
                /* 왼쪽에 핑크색 포인트 바 */
                display: flex;
                align-items: center;
                letter-spacing: -1px;
                background: linear-gradient(to right, #ffffff, #fdfdfd);
                padding-top: 10px;
                padding-bottom: 10px;
                border-radius: 0 8px 8px 0;
            }

                #calendar {
                    max-width: 1100px;
                    margin: 0 auto;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 8px;

                    /* 아래 내용 추가 */
                    transform: scale(0.88);      /* 전체 크기를 85%로 축소 */
                    transform-origin: top center; /* 축소 기준점을 위쪽 중앙으로 설정 */
                    margin-bottom: -100px;       /* 축소된 만큼 생기는 빈 공간(공백) 제거 */
                }

                /* ---------------------- 이벤트 스타일 ---------------------- */
                .fc-daygrid-event {
                    background-color: #007bff !important;
                    border: none !important;
                    border-radius: 6px;
                    padding: 5px !important;
                    text-align: center;
                    color: #fff !important;
                    font-weight: bold;
                    font-size: 13px;
                }

                .fc-event-title {
                    color: black !important;
                    color: #fff !important;
                    font-weight: 700;
                    font-size: 13px;
                }

                .fc .fc-event-time {
                    display: none !important;
                }
            </style>
        </head>

        <body>
            <div id="calendar-app">
                <div class="main-wrapper">
                    <div class="content-area">
                        <h1 class="page-title">픽업 일정 확인 캘린더</h1>
                        <div id="calendar"></div>
                    </div>
                </div>
            </div>

            <script>
                const { createApp } = Vue;

                createApp({
                    data() {
                        return {
                            userId: "${sessionId}",
                            calendar: null
                        };
                    },
                    methods: {
                        /** DB 결과 → FullCalendar 이벤트로 변환 */
                        formatEvents(data) {
                            return data
                                // 유효한 시작 날짜가 있는 항목만 필터링 (유지)
                                .filter(item => item.PICKUP_START_DATE || item.pickup_start_date || item.pickupStartDate)
                                .map(item => {

                                    // 1. 주문 ID를 추출 (대문자 ORDER_ID로 잘 잡힐 것입니다)
                                    const rawOrderId = item.ORDER_ID || item.order_id || item.orderId || "(없음)";

                                    // 2. ⭐️ 추출된 값을 명시적으로 문자열로 변환
                                    const orderId = rawOrderId.toString();

                                    // (이전 코드에서 이미 orderId가 문자열화되고 있었지만, 안전을 위해 rawOrderId를 사용하여 다시 명시적 변환)
                                    // ----------------------------------------------------

                                    const startDate = item.PICKUP_START_DATE || item.pickup_start_date || item.pickupStartDate;
                                    const endDate = item.PICKUP_END_DATE || item.pickup_end_date || item.pickupEndDate;

                                    return {
                                        id: orderId,

                                        // 3. ⭐️ title 생성 (변수가 문자열임을 확신하고 삽입)
                                        title: `주문 #\${orderId}`,

                                        start: startDate,
                                        end: endDate,
                                        allDay: true,
                                        extendedProps: { orderId }
                                    };
                                });
                        },

                        /** 서버에서 일정 데이터 불러오기 */
                        fetchPickupSchedules(fetchInfo, successCallback, failureCallback) {
                            const startStr = fetchInfo.startStr.substring(0, 10);
                            const endStr = fetchInfo.endStr.substring(0, 10);

                            if (!this.userId || this.userId.startsWith('$')) {
                                console.warn("userId(세션 ID)가 유효하지 않습니다.");
                                successCallback([]);
                                return;
                            }

                            $.ajax({
                                url: "/seller/calendar.dox",
                                method: "POST",
                                dataType: "json",
                                data: {
                                    userId: this.userId,
                                    start: startStr,
                                    end: endStr
                                },
                                success: (data) => {
                                    //console.log("📦 서버 응답:", data);
                                    successCallback(this.formatEvents(data));
                                },
                                error: (xhr, status, error) => {
                                    console.error("픽업 일정 로드 실패:", error);
                                    alert("픽업 일정을 불러오는 데 실패했습니다. (HTTP " + xhr.status + ")");
                                    failureCallback();
                                }
                            });
                        },

                        /** 이벤트 클릭 시 채팅페이지 이동 */
                        handleEventClick(info) {
                          const orderId = info.event.extendedProps.orderId || info.event.id;
    
                        if (orderId && orderId !== "(없음)") {
                            const url = `/seller/OrderHistoryViewDetail.do?orderId=\${orderId}`;
                            window.location.href = url;
                        } else {
                            alert("주문 ID를 찾을 수 없습니다.");
                        }
                        }
                    },
                    mounted() {
                        const calendarEl = document.getElementById('calendar');
                        this.calendar = new FullCalendar.Calendar(calendarEl, {
                            initialView: 'dayGridMonth',
                            locale: 'ko',
                            headerToolbar: {
                                left: 'prev,next today',
                                center: 'title',
                                right: 'dayGridMonth,timeGridWeek,timeGridDay'
                            },
                            events: this.fetchPickupSchedules,
                            eventClick: this.handleEventClick,
                            displayEventTime: false
                        });
                        this.calendar.render();
                    }
                }).mount('#calendar-app');
            </script>
        </body>

        </html>