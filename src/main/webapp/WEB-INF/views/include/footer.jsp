<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer role="contentinfo"
        style="background:#f7f8fa; border-top:1px solid #e5e7eb; color:#4b5563; font-family:'Noto Sans KR',system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif; font-variant-numeric:tabular-nums;">
    <div style="max-width:920px; margin:0 auto; padding:22px 20px 16px; text-align:center;">

        <!-- 브랜드 로고: 상단 중앙 고정 -->
        <a href="${pageContext.request.contextPath}/"
           style="display:inline-block; line-height:0; text-decoration:none; margin-bottom:12px;">
            <img src="${pageContext.request.contextPath}/images/logoBlack.png"
                 alt="MAPTRIX 로고" loading="lazy"
                 style="height:40px; display:block; margin:0 auto; filter:drop-shadow(0 1px 0 rgba(0,0,0,.06));">
        </a>

        <!-- 정보 영역: 전부 중앙 정렬 스택 -->
        <section aria-label="고객센터" style="font-size:13px; line-height:1.65; margin-bottom:8px;">
            <div style="font-weight:700; color:#111827; letter-spacing:.2px; margin-bottom:4px;">고객센터</div>
            <div>
                <a href="tel:0426322222"
                   style="font-weight:800; font-size:15px; color:#1f2937; text-decoration:none;">042-632-2222</a>
                <span style="color:#9ca3af;">· 평일 09:00~19:00 (주말·공휴일 휴무)</span>
            </div>
            <div style="margin-top:4px;">
                <a href="mailto:help@team2.co.kr"
                   style="color:#4b5563; text-decoration:none;"
                   onmouseover="this.style.color='#111827'"
                   onmouseout="this.style.color='#4b5563'">help@team2.co.kr</a>
                <span style="margin:0 6px; color:#e5e7eb;">·</span>
                <span style="color:#4b5563;">Fax 042-632-3333(대표) / 042-632-4444(세금계산서)</span>
            </div>
        </section>

        <section aria-label="회사 정보" style="font-size:13px; line-height:1.65; margin-bottom:8px;">
            <div style="font-weight:700; color:#111827; letter-spacing:.2px; margin-bottom:4px;">회사 정보</div>
            <address style="margin:0; font-style:normal; color:#4b5563;">
                <strong>(주)대덕인재개발원</strong><br>
                우) 07800, 대전광역시 중구 계룡로 846 4층<br>
                대표: 장세진 · 최예찬 · 강경모 · 이지은 · 정연우 · 조이현 · 이민기
            </address>
            <div style="color:#9ca3af; margin-top:6px;">
                사업자등록: 113-86-070707 · 직업정보제공사업: 대전광역시 중구 2025-05호 · 통신판매업: 제 2025-대전중구-0707호
            </div>
        </section>

        <!-- 구분선 -->
        <hr style="border:0; border-top:1px solid #e5e7eb; margin:12px 0 10px;">

        <!-- 정책 링크 & 카피라이트: 중앙 정렬 -->
        <nav aria-label="정책 링크" style="display:flex; justify-content:center; gap:12px; font-size:12.5px; margin-bottom:6px;">
            <a href="${pageContext.request.contextPath}/guide/terms"
               style="color:#9ca3af; text-decoration:none;"
               onmouseover="this.style.color='#111827'"
               onmouseout="this.style.color='#9ca3af'">이용약관</a>
            <span aria-hidden="true" style="color:#e5e7eb;">|</span>
            <a href="${pageContext.request.contextPath}/guide/privacy"
               style="color:#9ca3af; text-decoration:none;"
               onmouseover="this.style.color='#111827'"
               onmouseout="this.style.color='#9ca3af'">개인정보처리방침</a>
        </nav>

        <p style="margin:0; font-size:12.5px; color:#9ca3af;">
            © <%= java.time.Year.now() %> MAPTRIX · Daejeon Commerce Data Portal. All rights reserved.
        </p>
    </div>
</footer>
