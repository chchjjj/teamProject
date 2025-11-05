<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>픽업 일정 확인 캘린더</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.css" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

    <style>
        /* (기존 CSS 스타일 유지) */
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
            font-size: 24px;
            font-weight: 300;
            margin-bottom: 20px;
            color: #333;
        }

        #calendar {
            max-width: 1100px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }

        .fc-daygrid-event {
            background-color: #007bff !important;
            border: none !important;
            border-radius: 6px;
            padding: 5px !important;
            text-align: center;
            color: #fff !important;
            font-weight: bold;
            font-size: 13px;
            cursor: pointer;
        }

        .fc-event-title {
            display: block !important;
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
                    userId: "${sessionId}",  // 서버에서 세션 ID를 가져와 사용
                    checkOrderId: "",  // 클릭된 주문 ID를 저장
                    calendarEvents: []  // FullCalendar 이벤트 리스트
                };
            },
            methods: {
                // FullCalendar 초기화 및 이벤트 설정 메서드
                initCalendar() {
                    const calendarEl = document.getElementById('calendar');
                    const calendar = new FullCalendar.Calendar(calendarEl, {
                        initialView: 'dayGridMonth',
                        locale: 'ko',  // 한글 설정
                        headerToolbar: {
                            left: 'prev,next today',
                            center: 'title',
                            right: 'dayGridMonth,timeGridWeek,timeGridDay'
                        },
                        // 서버에서 이벤트를 로드하는 함수
                        events: this.fetchCalendarEvents,
                        eventClick: (info) => {
                            const orderId = info.event.extendedProps.orderId;
                            
                            if (orderId) {
                                console.log('클릭된 주문 ID:', orderId);
                                this.chatting(orderId);  // Vue 메서드 호출
                            } else {
                                alert("주문 ID가 존재하지 않는 이벤트입니다.");
                            }
                        },
                        eventTimeFormat: { 
                            hour: '2-digit', 
                            minute: '2-digit', 
                            meridiem: false 
                        }
                    });

                    calendar.render();
                },

                // 캘린더 이벤트를 서버에서 불러오는 AJAX 메서드
                fetchCalendarEvents(fetchInfo, successCallback, failureCallback) {
                    $.ajax({
                        url: "/seller/calendarEvents.dox", 
                        method: "POST",
                        dataType: "json",
                        data: {
                            userId: this.userId,
                            start: fetchInfo.startStr, 
                            end: fetchInfo.endStr
                        },
                        success: (res) => {
                            if (res.result === 'success' && res.list) {
                                const events = res.list.map(item => ({
                                    title: `[${item.PRO_TYPE}] ${item.PICKUP_TIME}`,
                                    start: item.PICKUP_DATE + 'T' + item.PICKUP_TIME_SLOT,
                                    extendedProps: { orderId: item.ORDER_ID }
                                }));
                                successCallback(events);
                            } else {
                                successCallback([]); 
                            }
                        },
                        error: (xhr, status, error) => {
                            console.error("캘린더 이벤트 로드 실패:", status, error);
                            failureCallback(error);
                        }
                    });
                },

                // 주문 ID를 저장하고 채팅 페이지로 이동하는 메서드
                chatting(id) {
                    // 1. 클릭된 ID를 checkOrderId 변수에 저장
                    this.checkOrderId = id;

                    // 2. 저장된 checkOrderId가 유효한지 확인하고 페이지 이동
                    if (this.checkOrderId) {
                        // URL을 Vue 데이터(this)를 사용하여 동적으로 생성
                        // const url = `/seller/sellerChat.do?orderId=${this.checkOrderId}`;
                        console.log(`채팅 페이지로 이동: ${url}`);

                        // 실제 페이지 이동
                        window.location.href = url;
                    } else {
                        alert("주문 번호(orderId)가 올바르게 설정되지 않았습니다.");
                    }
                }
            },
            mounted() {
                this.initCalendar();  // 캘린더 초기화
            }
        }).mount('#calendar-app');
    </script>

</body>

</html>
