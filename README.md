# 🗺️ MAPTRIX - AI 기반 통합 상권분석 및 창업 지원 플랫폼

> 대전지역 소상공인과 예비 창업자를 위한 데이터 기반 창업 성공 솔루션

## 📋 프로젝트 소개

**MAPTRIX**는 경기 침체 속 신뢰할 만한 데이터 부재로 어려움을 겪는 소상공인과 예비 창업자에게 실질적인 창업 성공을 지원하기 위해 개발된 플랫폼입니다.

기존의 단순한 데이터 나열을 넘어, **다중회귀분석·군집분석 등 검증된 통계 모델과 AI 해석을 결합**하여 신뢰성과 합리성을 갖춘 **상권분석 리포트**를 제공합니다.

## 🛠️ 기술 스택

### Frontend
- HTML5, CSS3, JavaScript
- Bootstrap / Tailwind CSS
- Chart.js (데이터 시각화)

### Backend
- **Spring Framework** (Spring MVC)
- **MyBatis** (ORM)
- **Java 8+**

### Database
- **Oracle Database** (메인 데이터베이스)
- **Oracle SQL Developer** (데이터베이스 관리 도구)

### AI/ML
- Python (Pandas, NumPy, Scikit-learn)
- 다중회귀분석 모델
- 군집분석 알고리즘

### API & External Services
- **Kakao Map API** (지도 서비스)
- **공공데이터포털 API** (상권정보)
- **상권정보 Open API**

### Tools
- Git, GitHub
- Figma (UI/UX 디자인)

## ⭐ 주요 기능

### 🎯 핵심 기능
- **📊 AI 기반 상권분석**: 다중회귀분석·군집분석을 통한 과학적 상권 평가
- **📍 GPS 스탬프 투어**: 사용자 참여형 데이터 수집으로 분석 정확도 향상
- **📈 통계적 분석 도구**: 사용자가 직접 수행할 수 있는 상권분석 기능

### 🔧 부가 기능
- **🏪 2D/3D 매장 시뮬레이터**: 가상 매장 레이아웃 설계
- **🔍 SNS 키워드 분석**: 트렌드 기반 상권 인사이트
- **👥 업종별 커뮤니티**: 창업자 간 정보 공유 플랫폼
- **📱 반응형 웹 디자인**: 모바일/데스크톱 최적화

## 🎨 차별성

### 1️⃣ 데이터 선순환 체계
**GPS 스탬프 투어**를 통해 사용자가 직접 참여하며 데이터를 축적하여, 자체 데이터의 신뢰성을 높이고 분석 모델을 지속적으로 고도화하는 체계를 구축했습니다.

### 2️⃣ 통계적 검증성
단순 데이터 나열이 아닌 **검증된 통계 모델과 AI 해석을 결합**하여 과학적이고 신뢰할 수 있는 상권분석을 제공합니다.

### 3️⃣ 통합 솔루션
상권분석부터 매장 설계, 트렌드 분석, 커뮤니티까지 **창업 전 과정을 지원하는 원스톱 플랫폼**입니다.

## 🚀 실행 방법

### 📋 사전 준비사항
- **Java 8** 이상
- **Spring Tool Suite (STS)** 또는 **Eclipse**
- **Apache Tomcat 8.5** 이상
- **Oracle Database** (Oracle SQL Developer)
- **Maven** (의존성 관리)
- **Kakao Map API Key**

### 🔧 실행 단계

#### 1. 프로젝트 다운로드
```bash
git clone https://github.com/socialo4751/MAPTRIX-portfolio.git
```

#### 2. STS에서 프로젝트 Import
1. **File** → **Import** → **Existing Maven Projects**
2. 다운로드한 프로젝트 폴더 선택
3. **Import** 클릭

#### 3. Oracle Database 설정
```sql
-- Oracle SQL Developer에서 스키마 생성
CREATE USER maptrix IDENTIFIED BY password;
GRANT CONNECT, RESOURCE TO maptrix;
```

#### 4. 설정 파일 수정
```properties
# src/main/resources/application.properties 또는 database.properties
spring.datasource.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
spring.datasource.username=maptrix
spring.datasource.password=your_password

# Kakao Map API 설정
kakao.api.key=your_kakao_api_key
```

#### 5. Maven 의존성 업데이트
```bash
# STS 내에서 프로젝트 우클릭
# Maven → Reload Projects
```

#### 6. 서버 실행
- **프로젝트 우클릭** → **Run As** → **Spring Boot App**
- 또는 **Run As** → **Run on Server** (Tomcat)

#### 7. 브라우저 접속
```
http://localhost
```

### 🔑 API 키 설정 방법

#### Kakao Map API 키 발급
1. [Kakao Developers](https://developers.kakao.com/) 접속
2. 애플리케이션 등록 후 JavaScript 키 발급
3. 플랫폼 설정에서 도메인 등록 (`http://localhost`)

### 💡 참고사항
- Oracle Database 연결 확인 필요
- 카카오 API 키는 보안상 별도 설정 파일로 관리 권장
- 포트 80 사용으로 관리자 권한이 필요할 수 있음

## 📸 스크린샷

### 메인 대시보드
*상권분석 결과를 한눈에 볼 수 있는 통합 대시보드*

### GPS 스탬프 투어
*사용자 참여형 데이터 수집 인터페이스*

### AI 상권분석 리포트
*통계 모델 기반 상권분석 결과 시각화*

## 📍 대상 지역

**대전광역시** 전 지역
- 서구, 중구, 동구, 유성구, 대덕구
- 주요 상권: 둔산동, 은행동, 중앙로, 유성온천 등

## 👥 팀원 및 개발 역할

### 🎯 Backend Developer & System Architect - [@socialo4751](https://github.com/socialo4751)

#### **💻 시스템 설계 및 구축**
- **Spring MVC**와 **MyBatis**를 활용한 복잡한 비즈니스 로직 체계적 구현
- 회원 탈퇴 기능의 이중 보안 검증, 파일 재다운로드 기능의 소유권 검증 등 **보안 중심 설계**
- 시스템 안정성과 보안을 최우선으로 하는 아키텍처 설계

#### **🗄️ 데이터베이스 관리 및 최적화**  
- 대용량 데이터 처리를 위한 **페이징 쿼리** 적용 (알림 내역, 다운로드 이력)
- 불필요한 데이터 조회 최소화로 서버/DB 부하 감소 및 성능 최적화
- 논리적 삭제 적용으로 효율적인 시스템 자원 관리

#### **🔌 RESTful API 개발**
- 관심 지역/업종 관리 API 설계 및 구축
- **@RequestBody, @RequestParam** 등 Spring 어노테이션 활용
- 프론트엔드-백엔드 간 효율적인 통신 처리

#### **🔒 보안 및 인증 시스템**
- **Principal** 객체와 **SecurityContextHolder**를 통한 안전한 사용자 인증
- 중요 기능(회원 탈퇴 등)의 이중 보안 검증으로 데이터 무결성 보장
- 세션/쿠키 무효화를 통한 체계적인 보안 관리

#### **⚡ 성능 최적화 및 UX 개선**
- **URLEncoder** 활용한 한글 깨짐 방지로 안정성 확보
- **RedirectAttributes**를 통한 사용자 피드백 시스템 구현
- 멀티탭 페이징 상태 관리로 향상된 사용자 경험 제공

### 🤝 기타 팀원
- **Frontend Developer** - UI/UX 디자인, 지도 API 연동, 반응형 웹 구현
- **Data Analyst** - AI/ML 모델링, 통계분석, 상권분석 알고리즘 개발  
- **Product Manager** - 서비스 기획, 사용자 리서치, 프로젝트 관리

## 📅 개발 기간

2025.07.14 ~ 2025.08.25 (7주)

## 🎯 기대효과

### 💡 사회적 가치
- **창업 실패율 감소**: 데이터 기반 과학적 의사결정 지원
- **지역 상권 활성화**: 대전지역 소상공인 경쟁력 강화
- **정보 격차 해소**: 누구나 접근 가능한 상권분석 도구 제공

### 📊 비즈니스 임팩트
- 예비 창업자의 **최적 입지 선정** 지원
- **실전 창업 성공률** 향상
- **지속가능한 데이터 생태계** 구축

## 🔗 링크

- **기술 문서**: [https://delicate-dirt-4ca.notion.site/26408ffbb3b6806cba61c30f2b049d45?v=26408ffbb3b6819f8656000c74f54ede]



## 📝 개발 후기

### 💪 성과 및 배운 점
- 실제 창업자들의 니즈를 반영한 실용적 솔루션 개발
- AI/ML과 통계학을 활용한 데이터 분석 역량 향상
- 대용량 데이터 처리 및 실시간 분석 시스템 구축 경험
- 사용자 중심의 UX/UI 설계 및 반응형 웹 개발

---

## 🏆 Awards & Recognition
- [최종프로젝트 공모전 우수상]

---

> "데이터로 창업 성공률을 높인다" - MAPTRIX Team