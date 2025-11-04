<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/seller/sellerSideBar.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>픽업 일정 확인 캘린더</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" 
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
        crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script> 
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.css' />
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>

    <style>
        body { margin: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f4f4; }
        .main-wrapper { display: flex; min-height: 100vh; }
        .content-area { flex-grow: 1; padding: 30px; background-color: white; margin-left: 220px; box-sizing: border-box; }
        .page-title { font-size: 24px; font-weight: 300; margin-bottom: 20px; color: #333; }
        #calendar { max-width: 1100px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }

        /* ---------------------- 캘린더 이벤트 스타일 ---------------------- */
        .fc .fc-daygrid-event { 
            white-space: nowrap !important;
            height: auto !important; 
            padding: 4px 6px !important; 
            box-sizing: border-box; 
        }
        .fc .fc-event-main { display: block !important; }

        /* 주문번호 텍스트 스타일: 굵게, 흰색 */
        .fc .fc-daygrid-event .fc-custom-event-wrapper div {
            color: #fff !important;
            font-weight: 700;
            font-size: 13px;
            line-height: 1.1;
        }

        .fc .fc-daygrid-event .fc-event-time { display: none; }
        /* 모든 이벤트를 기본 파란색으로 설정합니다. */
        .event-location-default { background-color: #007bff !important; border-color: #007bff !important; }
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

        const calendarApp = createApp({
            data() {
                return {
                    // Vue 데이터로 userId 관리
                    userId: "${sessionId}", 
                    calendar: null,
                };
            },
            methods: {
                // 이벤트 데이터를 FullCalendar 형식에 맞게 변환하는 메서드
                formatEvents(data) {
                    return data.map(item => {
                        const orderId = item.ORDER_ID || "(없음)";
                        
                        // 🌟 주소 관련 로직 제거, 모든 이벤트에 기본 클래스 사용
                        const className = 'event-location-default'; 

                        return {
                            id: orderId,
                            title: `주문 #${orderId}`, // 제목은 주문번호만
                            start: item.PICKUP_START_DATE,
                            end: item.PICKUP_END_DATE,
                            allDay: true,
                            classNames: [className],
                            extendedProps: {
                                orderId: orderId
                                // 🌟 주소 데이터 필드 제거
                            }
                        };
                    });
                },
                
                // FullCalendar의 events 속성에 사용될 커스텀 데이터 로딩 함수 (통신 로직)
                fetchPickupSchedules: function (fetchInfo, successCallback, failureCallback) {
                    const startStr = fetchInfo.startStr.substring(0, 10);
                    const endStr = fetchInfo.endStr.substring(0, 10);

                    if (!this.userId || this.userId.startsWith('$')) {
                        console.warn("userId(세션 ID)가 유효하지 않습니다. 데이터 로드를 건너킵니다.");
                        successCallback([]);
                        return;
                    }

                    $.ajax({
                        // 🌟 /seller/calendar.dox URL 유지
                        url: "/seller/calendar.dox",
                        method: "POST",
                        dataType: "json",
                        data: {
                            userId: this.userId, 
                            start: startStr,
                            end: endStr
                        },
                        success: (data) => {
                            const events = this.formatEvents(data);
                            successCallback(events);
                        },
                        error: function (xhr, status, error) {
                            console.error("픽업 일정 로드 실패:", error);
                            alert("픽업 일정을 불러오는 데 실패했습니다. (HTTP " + xhr.status + ")");
                            failureCallback();
                        }
                    });
                },

                // **화면에 이벤트 내용을 렌더링하는 핵심 로직 (주문번호만 표시)**
                renderEventContent(arg) {
                    const orderId = String(arg.event.extendedProps.orderId || "(오류)");
                    
                    const wrapper = document.createElement('div');
                    wrapper.className = 'fc-custom-event-wrapper';
                    wrapper.style.textAlign = 'center';

                    // 주문번호 엘리먼트만 생성
                    const idEl = document.createElement('div');
                    idEl.textContent = `주문 #${orderId}`; 
                    idEl.style.fontWeight = 'bold';

                    // 주문번호 엘리먼트만 wrapper에 추가
                    wrapper.appendChild(idEl);

                    return { domNodes: [wrapper] };
                },

                // 이벤트 클릭 로직 (변경 없음)
                handleEventClick(info) {
                    const orderId = info.event.extendedProps.orderId;
                    if (orderId && orderId !== "(없음)") {
                        window.location.href = `/seller/sellerChat.do?orderId=${orderId}`;
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
                    editable: false,
                    dayMaxEvents: false,
                    displayEventTime: false,
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    },
                    
                    events: this.fetchPickupSchedules,
                    eventContent: this.renderEventContent, 
                    eventClick: this.handleEventClick,
                });

                this.calendar.render();
            }
        });

        calendarApp.mount('#calendar-app');
    </script>

</body>

</html>