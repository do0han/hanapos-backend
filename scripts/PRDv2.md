---

### **제품 요구사항 문서 (Product Requirements Document - PRD)**

### 1. 프로젝트 개요 (Executive Summary)

**1.1 제품명:** **hanaPOS Cloud Base**

**1.2 핵심 목표:**
**필리핀 전역의 소규모 카페 및 식당**을 위한 **클라우드 기반의 저렴하고 사용하기 쉬운 POS(Point-of-Sale) 및 통합 주문 관리 앱**을 개발하여, 이들의 비효율적인 운영 방식(수기 장부, 비싼 기존 POS)을 개선하고, **현지 모바일 결제(GCash, PayMaya)를 완벽하게 지원**함으로써 운영 효율과 고객 만족도를 극대화합니다.

**1.3 주요 차별점:**
* **현지화된 결제:** 필리핀에서 가장 널리 사용되는 GCash 및 PayMaya QR 코드 결제 시스템을 완벽하게 통합하여 현지 상점의 니즈에 최적화합니다.
* **합리적인 가격:** 소규모 사업자들이 부담 없이 사용할 수 있는 경쟁력 있는 월 구독료 모델을 제공합니다.
* **직관적인 사용성:** 기술에 익숙하지 않은 사용자도 쉽게 배우고 사용할 수 있는 간결하고 직관적인 UI/UX를 제공합니다.
* **통합 주문 기능:** 매장 내 주문(QR 오더)과 온라인 픽업/배달 주문 기능을 통합하여 한 앱에서 관리 가능한 기반을 마련합니다 (MVP에서는 기본 틀만 구축).

---

### 2. 비즈니스 배경 (Business Context)

**2.1 문제점 (Pain Points):**
* **수기 장부의 비효율성:** 필리핀 전역의 많은 소규모 사업자들이 여전히 수기 장부로 매출 및 재고를 관리하여 오류 발생 가능성이 높고, 실시간 현황 파악이 어렵습니다.
* **높은 POS 도입 비용:** 기존의 상용 POS 시스템은 도입 비용 및 월 유지보수 비용이 높아 소규모 사업자에게 큰 부담입니다.
* **모바일 결제 연동의 어려움:** GCash, PayMaya 등 현지 모바일 결제가 대중화되었으나, 이를 POS에 효과적으로 연동하는 솔루션이 부족하거나 복잡합니다.
* **온라인 주문 관리의 파편화:** 배달 플랫폼(GrabFood, Foodpanda 등) 수수료가 높고, 자체 온라인 주문 시스템 부재로 고객 유치 및 관리가 어렵습니다.

**2.2 솔루션:**
hanaPOS Cloud Base는 이러한 문제들을 해결하기 위해 다음 기능을 제공합니다.
* 클라우드 기반 POS 시스템으로 초기 하드웨어 투자 비용을 절감합니다.
* 직관적인 재고 관리 및 매출 보고 기능을 제공합니다.
* GCash 및 PayMaya QR 코드 생성 및 결제 연동 기능을 제공합니다.
* 간단한 온라인 주문 및 픽업/배달 기능을 지원합니다 (MVP는 픽업 위주).

---

### 3. 타겟 사용자 (Target Users)

**3.1 주요 사용자군:**
* **필리핀 전역의 소규모 카페 및 식당 주인/매니저:**
    * **니즈:** 매장 운영 전반(재고, 매출, 직원)을 효율적으로 관리하고자 합니다. 비용 절감 및 시간 절약에 관심이 많으며, 온라인 채널 확대를 원합니다.
    * **사용 환경:** 주로 웹 기반 백오피스 대시보드를 사용합니다 (Next.js로 개발 예정). 때때로 앱을 통해 실시간 매출을 확인합니다.
* **필리핀 전역의 매장 직원/캐셔:**
    * **니즈:** 빠르고 정확하게 주문 및 결제를 처리하고자 합니다. 사용하기 쉬운 시스템을 선호합니다.
    * **사용 환경:** 안드로이드/iOS 태블릿 앱을 사용합니다.

---

### 4. 핵심 기능 요구사항 (Functional Requirements - MVP Scope)

**4.1 일반 요구사항 (Global Requirements)**
* **클라우드 기반:** 모든 데이터는 Supabase PostgreSQL에 저장 및 실시간 동기화됩니다.
* **오프라인 모드:** 인터넷 연결 없이도 판매 가능하며, 재연결 시 Supabase Realtime/PostgREST를 통해 자동 동기화됩니다.
* **보안:** Supabase Auth를 통한 사용자 인증 및 **역할 기반 접근 제어(RBAC)**를 지원합니다.
* **기술 스택:**
    * **프론트엔드 (모바일 앱):** Flutter (Dart)
        * 주요 패키지: `http`, `shared_preferences`, `supabase_flutter`
    * **백엔드 (API 서버):** Next.js (API Routes) + Supabase
        * 데이터베이스: PostgreSQL (Supabase 관리)
        * Supabase Client Libraries: `supabase-js` (Next.js), `supabase_flutter` (Flutter)
        * 인증: Supabase Auth
        * 데이터 접근: Supabase PostgREST API (자동 생성)
        * 복잡한 로직/외부 연동: Supabase Edge Functions (Deno 기반 TypeScript)
    * **클라우드 인프라:** Supabase Cloud (배포), Vercel (Next.js 웹 백오피스 배포 시)
    * **결제 게이트웨이 연동:** GCash API (또는 PayMongo), PayMaya API (Next.js API Routes 또는 Supabase Edge Functions 통해 연동)

**4.2 기능 모듈 1: 사용자 인증 (User Authentication)**

* **목표:** 매장 직원이 안전하게 시스템에 접근하고, 작업이 끝난 후 로그아웃할 수 있도록 합니다.
* **작업 1.2.1: Supabase Auth 설정 및 사용자 테이블 스키마 정의**
    * **요구사항:** Supabase 프로젝트에 인증을 위한 기본 설정 완료. `users` 테이블 (Supabase Auth 기본 테이블)에 `role` (VARCHAR, `admin` 또는 `cashier` 값), `store_id` (UUID, 매장 식별자) 컬럼 추가. 초기 `admin` 계정 생성 로직 (선택 사항, 수동 생성 가능).
* **작업 1.2.2: 로그인 화면 (Flutter)**
    * **요구사항:** 사용자 이름 및 비밀번호 입력 필드, 로그인 버튼 포함 UI. 로그인 버튼 클릭 시, Flutter `supabase_flutter` SDK를 사용하여 Supabase Auth `signInWithPassword` 호출. 성공 시, Supabase 세션 정보를 로컬 저장소(`shared_preferences`)에 저장하고 **메인 POS 화면**으로 이동. 실패 시, 사용자에게 "잘못된 사용자 이름 또는 비밀번호입니다." 에러 메시지 표시. 입력 유효성 검사: 사용자 이름/비밀번호 필드는 비워둘 수 없으며, 비밀번호는 최소 8자 이상.
* **작업 1.2.3: 로그아웃 기능 (Flutter)**
    * **요구사항:** 앱 내 로그아웃 버튼(예: 메인 POS 화면 상단) 구현. 버튼 클릭 시, Flutter `supabase_flutter` SDK를 사용하여 Supabase Auth `signOut` 호출. 로컬 저장소의 세션 정보 삭제 후 로그인 화면으로 리디렉션.
* **작업 1.2.4: 역할 기반 접근 제어 (Supabase RLS & Custom Claims)**
    * **요구사항:** Supabase RLS 정책을 설정하여 `admin` 역할만 `products` 테이블의 특정 쓰기 작업(INSERT, UPDATE, DELETE)을 수행할 수 있도록 제한. `cashier` 역할은 `products` 테이블 조회 및 `orders` 테이블에만 쓰기 작업 허용. Supabase PostgREST API 호출 시 사용자 역할이 자동으로 적용되도록 설정.

**4.3 기능 모듈 2: 상품 관리 (Product Management)**

* **목표:** 매장 관리자가 앱 또는 웹 백오피스에서 상품을 쉽게 등록, 조회, 수정할 수 있도록 합니다.
* **작업 2.3.1: `products` 테이블 스키마 정의 (Supabase PostgreSQL)**
    * **요구사항:** 컬럼: `id` (UUID, PK), `store_id` (UUID, FK to `stores` 테이블, RLS 적용), `name` (TEXT, NOT NULL), `price` (DECIMAL, NOT NULL), `stock` (INTEGER, NOT NULL, DEFAULT 0), `sku` (TEXT, UNIQUE), `category` (TEXT), `barcode` (TEXT), `created_at` (TIMESTAMP WITH TIME ZONE, DEFAULT now()), `updated_at` (TIMESTAMP WITH TIME ZONE, DEFAULT now()).
* **작업 2.3.2: 상품 목록 조회 API (Next.js API Route or Supabase PostgREST)**
    * **요구사항:** `GET /api/products` (인증된 사용자만 접근 가능). 현재 로그인된 `store_id`에 해당하는 상품만 조회되도록 RLS 적용. 상품 이름, 가격, 재고, 카테고리 등을 반환.
* **작업 2.3.3: 상품 등록/수정/삭제 API (Next.js API Route or Supabase PostgREST)**
    * **요구사항:** `POST /api/products` (새 상품 등록), `PUT /api/products/:id` (상품 정보 업데이트), `DELETE /api/products/:id` (상품 삭제). `admin` 역할만 접근 가능하도록 RLS 또는 API Route 내 권한 검증 로직 추가. 재고 조정 시 트랜잭션 안전성 확보.
* **작업 2.3.4: 상품 관리 UI (Flutter)**
    * **요구사항:** 관리자/매니저가 상품 목록을 보고, 새 상품을 추가하거나 기존 상품을 편집/삭제할 수 있는 화면 구현. 상품 등록/편집 폼: 이름, 가격, 재고, 카테고리 등 입력 필드 포함.

**4.4 기능 모듈 3: 판매 처리 (Point-of-Sale - POS)**

* **목표:** 매장 직원이 상품을 선택하고 다양한 방법으로 결제를 처리할 수 있도록 합니다.
* **작업 3.4.1: `orders` 및 `order_items` 테이블 스키마 정의 (Supabase PostgreSQL)**
    * **요구사항:** `orders` 테이블: `id` (UUID, PK), `store_id` (UUID, FK), `total_amount` (DECIMAL, NOT NULL), `payment_method` (TEXT, 'cash', 'gcash', 'paymaya' 등), `status` (TEXT, 'pending', 'completed', 'cancelled'), `cashier_id` (UUID, FK to `users` 테이블), `created_at`. `order_items` 테이블: `id` (UUID, PK), `order_id` (UUID, FK), `product_id` (UUID, FK), `quantity` (INTEGER, NOT NULL), `unit_price` (DECIMAL, NOT NULL).
* **작업 3.4.2: 메인 POS 화면 UI (Flutter)**
    * **요구사항:** 앱의 핵심인 메인 POS 화면(`lib/screens/pos_screen.dart`) 구현. 이 화면은 크게 상품 목록 영역, 장바구니 영역, 총액 표시 영역, 그리고 결제 버튼 영역으로 나뉘어야 합니다. 직관적이고 사용하기 쉽게 디자인합니다.
* **작업 3.4.3: 상품 선택 및 장바구니 관리 로직**
    * **요구사항:** POS 화면에서 상품을 탭하면 장바구니에 1개씩 추가되도록 로직 구현. 장바구니 내 상품의 수량 조절(+/- 버튼) 및 삭제 기능 구현. 총액이 실시간으로 업데이트되도록 합니다.
* **작업 3.4.4: 현금 결제 기능 구현**
    * **요구사항:** '현금' 결제 버튼 클릭 시 고객이 지불한 금액을 입력받는 팝업을 띄우고, 거스름돈을 자동 계산하여 표시. 결제 완료 시, 장바구니의 상품 정보를 `orders` 및 `order_items` 테이블에 기록하고, 해당 상품의 재고를 자동으로 차감하는 로직 구현.
* **작업 3.4.5: GCash/PayMaya QR 결제 API (Next.js)**
    * **요구사항:** Next.js API Routes에 GCash 및 PayMaya 결제 게이트웨이와 연동하여 QR 코드를 생성하고 결제 상태를 확인하는 초기 API (`/api/payments/gcash-qr`, `/api/payments/paymaya-qr`)를 구현. 실제 결제 API 연동 대신, 일단은 더미(dummy) 응답으로 QR 코드 이미지 URL을 반환하도록 합니다.
* **작업 3.4.6: GCash/PayMaya QR 결제 UI 및 연동 (Flutter)**
    * **요구사항:** POS 화면에서 'GCash QR' 또는 'PayMaya QR' 버튼 클릭 시, Next.js API Route를 호출하여 QR 코드 이미지 URL을 받아 화면에 표시. 결제 상태는 일단 '결제 대기 중'으로 표시하고, '결제 완료' 버튼을 수동으로 누르면 주문이 완료되도록 임시 로직 구현 (향후 실제 연동 시 자동화).

**4.5 기능 모듈 4: 재고 관리 (Inventory Management)**

* **목표:** 판매 시 재고가 자동으로 반영되고, 현재 재고 현황을 파악할 수 있도록 합니다.
* **작업 4.5.1: 자동 재고 차감 로직 (Supabase Function/Trigger)**
    * **요구사항:** `orders` 테이블에 새로운 레코드가 추가되거나 `status`가 'completed'로 변경될 때, `order_items`의 상품 수량만큼 `products` 테이블의 `stock`을 자동으로 감소시키는 Supabase Function 또는 Database Trigger 구현.
* **작업 4.5.2: 재고 현황 표시 (Flutter)**
    * **요구사항:** 상품 목록 화면 및 상품 상세 화면에 현재 재고 수량 표시. 재고가 부족한 상품은 시각적으로 강조 (예: 빨간색 텍스트).
* **작업 4.5.3: 수동 재고 조정 (Flutter UI & Supabase Function)**
    * **요구사항:** `admin` 역할만 접근 가능한 화면에서 특정 상품의 재고 수량을 수동으로 조정(증가/감소)할 수 있는 기능. 재고 조정 시, `stock_adjustments` 테이블(별도 생성)에 변경 이력 기록.

**4.6 기능 모듈 5: 기본 보고서 (Basic Reporting)**

* **목표:** 매일의 매출 현황을 간략하게 파악할 수 있도록 합니다.
* **작업 4.6.1: 일별 총 매출액 조회 API (Next.js API Route or Supabase SQL View)**
    * **요구사항:** `GET /api/reports/daily-sales` (인증된 `admin` 또는 `manager` 역할만 접근 가능). 특정 날짜 범위의 `completed` 상태 주문들의 `total_amount`를 합산하여 반환. 결과 필터링을 위해 `store_id` 기준 적용.
* **작업 4.6.2: 일별 매출 보고서 UI (Flutter 또는 Next.js 웹 대시보드)**
    * **요구사항:** 간단한 보고서 탭 또는 페이지 구현. 선택된 날짜(기본값: 오늘)의 총 매출액을 명확하게 표시.

---

### 5. 비기능 요구사항 (Non-Functional Requirements)

**5.1 성능:**
* **응답 시간:** 핵심 API 응답 시간 1초 이내. POS 화면의 결제 처리 시간 0.5초 이내.
* **동기화:** 오프라인 모드에서 온라인 전환 시 데이터 동기화 5초 이내 (Supabase Realtime 및 PostgREST 활용).

**5.2 보안:**
* 모든 통신은 HTTPS/SSL 암호화 (Supabase 및 Next.js에서 기본 제공).
* 비밀번호는 Supabase Auth를 통해 안전하게 처리 (해싱 및 솔팅).
* Supabase RLS(Row Level Security)를 통해 데이터베이스 수준의 역할 기반 접근 제어 구현.
* **필리핀 데이터 개인 정보 보호법(DPA) 준수.**
* 결제 정보는 PCI DSS 규정을 준수하는 결제 게이트웨이(GCash/PayMaya)를 통해 처리하며, 앱은 민감한 카드 정보를 직접 저장하지 않습니다.

**5.3 사용성 (UI/UX):**
* **직관성:** 기술에 익숙하지 않은 사용자도 쉽게 배우고 사용할 수 있는 간결하고 명확한 디자인.
* **효율성:** POS 화면은 최소한의 터치로 빠르고 정확하게 결제를 완료할 수 있도록 최적화.
* **반응형:** 태블릿 (안드로이드, iOS) 화면 크기에 최적화된 레이아웃.

**5.4 확장성:**
* Supabase의 확장 가능한 아키텍처(PostgreSQL, Serverless Functions) 활용하여 향후 사용자 및 데이터 증가에 대응.
* Next.js API Routes는 서버리스 환경에 최적화되어 트래픽 증가에 유연하게 대응.
* 새로운 기능 추가(예: 고객 충성도 프로그램, 온라인 예약)가 용이하도록 모듈식 설계.
* **다중 매장 지원 아키텍처:** `store_id` 개념을 도입하여 여러 매장이 하나의 시스템을 공유하되, 각 매장 데이터는 분리하여 관리합니다.

**5.5 안정성:**
* 예상치 못한 오류 발생 시 앱 크래시 방지.
* 데이터 손실 방지 (Supabase의 데이터 백업 및 복구 기능 활용).

---

### 6. 개발 로드맵 (Development Roadmap - AI Task-master Focused)

이 로드맵은 **Task-master AI가 모든 코딩 작업을 담당**하도록 명확히 지시하며, 당신은 각 단계와 작업의 진행을 관리하고 결과를 확인합니다.

---

**Phase 1: MVP (Minimum Viable Product) - 핵심 기능 구현**

* **목표:** 최소한의 기능으로 앱을 출시하여 시장 반응을 확인하고 초기 사용자를 확보합니다. 기본적인 판매, 상품 관리, 인증, 현지 모바일 결제(QR 코드 표시) 기능을 완성합니다.
* **당신의 역할:** Task-master에게 각 작업을 **순서대로 명확히 지시**하고, 각 작업이 완료될 때마다 **결과를 확인하고 피드백**을 제공합니다.

    * **단계 1.1: 프로젝트 초기 설정 및 Supabase 환경 구축**
        * **1.1.1 Supabase 프로젝트 생성 및 초기 설정:**
            * **지시:** "Task-master, Supabase 웹사이트에서 `hanaPOS` 프로젝트를 생성하고, 내 계정 정보를 바탕으로 Supabase Flutter SDK를 Flutter 프로젝트에 연동하는 기본 설정을 가이드하고 코드를 준비해 줘."
        * **1.1.2 필수 데이터베이스 테이블 스키마 정의:**
            * **지시:** "PRD 4.2, 4.3, 4.4 섹션을 참고해서, Supabase PostgreSQL에 `users`, `products`, `orders`, `order_items`, `stores` 테이블의 스키마를 생성하는 SQL 코드를 작성해 줘. `users`에 `role`, `store_id`를 추가하고, 모든 테이블에 `store_id` FK를 포함시켜 다중 매장 구조를 지원하도록 해 줘."
        * **1.1.3 Supabase RLS(Row Level Security) 설정:**
            * **지시:** "PRD 4.2.4를 참고해서, `users`, `products`, `orders`, `order_items` 테이블에 대한 RLS 정책 SQL 코드를 작성해 줘. `admin`은 모든 데이터 접근, `cashier`는 본인 `store_id` 데이터 읽기 및 `orders`/`order_items` 쓰기만 허용하도록 해 줘."
        * **1.1.4 Next.js 프로젝트 생성 및 Supabase 연동:**
            * **지시:** "Next.js 프로젝트를 생성하고, Supabase PostgREST API와 인증 기능을 사용할 수 있도록 Next.js에 Supabase 클라이언트를 초기화하는 코드를 작성해 줘."

    * **단계 1.2: 사용자 인증 기능 개발 (Flutter 앱)**
        * **1.2.1 로그인 화면 UI 구현:**
            * **지시:** "PRD 4.2.2에 맞춰 Flutter 앱의 `lib/screens/login_screen.dart`에 사용자 이름/비밀번호 입력 필드와 로그인 버튼 UI를 구현해 줘. 깔끔하고 직관적으로."
        * **1.2.2 로그인 로직 연동 (Supabase Auth):**
            * **지시:** "PRD 4.2.2, 4.2.3을 참고해서, 로그인 화면에서 Supabase Auth `signInWithPassword`를 호출하는 로직을 `lib/services/auth_service.dart`에 작성해 줘. 성공 시 세션 저장 및 메인 POS 화면 이동, 실패 시 에러 메시지 표시를 `login_screen.dart`에 반영해 줘."
        * **1.2.3 로그아웃 기능 구현:**
            * **지시:** "PRD 4.2.3에 따라, 앱 내 적절한 위치에 로그아웃 버튼을 추가하고, 클릭 시 Supabase Auth `signOut` 호출, 로컬 세션 삭제 후 로그인 화면으로 돌아가게 해 줘."

    * **단계 1.3: 상품 관리 기능 개발 (Flutter 앱 및 Supabase 연동)**
        * **1.3.1 상품 목록 조회 UI 구현:**
            * **지시:** "PRD 4.3.4에 맞춰, 관리자가 상품 목록을 볼 수 있는 화면(`lib/screens/product_list_screen.dart`)을 Flutter로 구현해 줘. Supabase `products` 테이블 데이터를 조회하여 그리드 형태로 이름, 가격, 재고를 보여줘."
        * **1.3.2 상품 등록/수정/삭제 UI 및 로직 구현:**
            * **지시:** "PRD 4.3.4에 따라, 상품 추가/편집/삭제 화면(`lib/screens/product_form_screen.dart`)을 구현해 줘. 입력받은 상품 정보를 Supabase PostgREST API를 통해 저장/업데이트/삭제하는 로직을 구현하고, `admin` 권한만 사용 가능하도록 RLS 정책을 따르게 해 줘."

    * **단계 1.4: 판매 처리 (POS) 기능 개발 (Flutter 앱 및 Supabase 연동)**
        * **1.4.1 메인 POS 화면 UI 구현:**
            * **지시:** "PRD 4.4.2에 맞춰, 앱의 핵심인 메인 POS 화면(`lib/screens/pos_screen.dart`)을 구현해 줘. 상품 목록, 장바구니, 총액, 결제 버튼 영역으로 구성하고, 직관적으로 디자인해 줘."
        * **1.4.2 상품 선택 및 장바구니 관리 로직:**
            * **지시:** "PRD 4.4.3에 따라, POS 화면에서 상품 탭 시 장바구니에 1개 추가되도록 로직 구현. 장바구니 내 상품 수량 조절(+/-) 및 삭제 기능, 총액 실시간 업데이트를 구현해 줘."
        * **1.4.3 현금 결제 기능 구현:**
            * **지시:** "PRD 4.4.4에 따라, '현금' 결제 시 금액 입력 팝업, 거스름돈 자동 계산 표시, 결제 완료 시 `orders` 및 `order_items` 기록, 재고 자동 차감 로직을 구현해 줘."
        * **1.4.4 GCash/PayMaya QR 결제 API (Next.js):**
            * **지시:** "PRD 4.4.5에 따라, Next.js API Routes에 GCash 및 PayMaya QR 코드 생성 및 상태 확인을 위한 더미 API (`/api/payments/gcash-qr`, `/api/payments/paymaya-qr`)를 구현해 줘. (실제 연동은 이후)"
        * **1.4.5 GCash/PayMaya QR 결제 UI 및 연동 (Flutter):**
            * **지시:** "PRD 4.4.6에 맞춰, POS 화면에서 'GCash QR'/'PayMaya QR' 버튼 클릭 시 Next.js API Route 호출하여 QR 코드 이미지 표시. 결제 상태 '결제 대기 중' 표시 및 수동 '결제 완료' 버튼으로 주문 완료 임시 로직을 구현해 줘."

    * **단계 1.5: 재고 관리 및 기본 보고서 기능 개발**
        * **1.5.1 자동 재고 차감 로직 (Supabase Function/Trigger):**
            * **지시:** "PRD 4.5.1에 따라, 'completed' 상태 주문 시 `order_items`에 있는 상품들의 재고를 `products` 테이블에서 자동으로 감소시키는 Supabase Function 또는 Database Trigger를 구현해 줘."
        * **1.5.2 일별 매출 보고서 UI 구현:**
            * **지시:** "PRD 4.6.2에 따라, 앱 내 '보고서' 탭 또는 페이지에 오늘 날짜의 총 매출액을 Supabase `orders` 테이블에서 조회하여 표시하는 UI를 구현해 줘."

---

**Phase 2: Core Enhancements (핵심 기능 고도화)**

* **목표:** MVP 출시 후 사용자 피드백을 반영하여 핵심 기능을 개선하고, 매장 운영의 효율성을 더욱 높입니다.
* **당신의 역할:** Phase 1이 완료되면, 이 단계의 작업들을 **하나씩 지시**하고 Task-master의 결과물을 검토합니다.

    * **단계 2.1: 고급 재고 관리**
        * **2.1.1 재고 입고/출고 및 조정 기능:**
            * **지시:** "PRD 8.2.1.1에 따라, `stock_movements` 테이블을 Supabase에 생성하고, 재고 입고/출고/조정을 위한 Flutter UI와 백엔드 로직을 구현해 줘. 각 트랜잭션이 기록되고 `products` 테이블 재고가 정확히 업데이트되도록."
        * **2.1.2 재고 부족 알림 시스템:**
            * **지시:** "PRD 8.2.1.2에 따라, 상품별 최소 재고 수량 설정 기능 추가 및 재고 임계값 이하 시 관리자 알림(Supabase Edge Function 또는 앱 푸시)을 구현해 줘."
        * **2.1.3 복합 상품 재고 관리:**
            * **지시:** "PRD 8.2.1.3에 따라, 상품 등록 시 세트 메뉴 구성 필드를 추가하고, 판매 시 구성된 개별 상품의 재고가 차감되도록 Supabase Function을 업데이트해 줘."

    * **단계 2.2: 상세 보고서 및 분석**
        * **2.2.1 매출 보고서 고도화:**
            * **지시:** "PRD 8.2.2.1에 따라, 일별/주별/월별/연간 매출 그래프, 카테고리별/상품별 판매량, 결제 수단별 매출을 보여주는 Flutter UI와 이를 위한 Supabase SQL View 또는 Next.js API Route를 구현해 줘."
        * **2.2.2 인기 상품 및 비수익 상품 분석:**
            * **지시:** "PRD 8.2.2.2에 맞춰, 판매량/매출액 상위/하위 10개 상품 목록을 보여주는 보고서 기능을 구현해 줘."

    * **단계 2.3: 고객 관리 (Basic CRM)**
        * **2.3.1 고객 정보 등록 및 조회:**
            * **지시:** "PRD 8.2.3.1에 따라, `customers` 테이블을 Supabase에 생성하고, 고객 정보를 앱에 등록, 검색, 조회할 수 있는 Flutter UI와 관련 로직을 구현해 줘. 판매 시 고객을 연결하는 기능도 추가해 줘."

    * **단계 2.4: 영수증 프린터 연동**
        * **2.4.1 Bluetooth 프린터 연동 및 영수증 발행:**
            * **지시:** "PRD 8.2.4에 따라, Flutter 앱에서 Bluetooth POS 프린터를 검색하고 연결하여, 결제 완료 시 영수증을 자동 출력하거나 재출력할 수 있는 기능을 구현해 줘."

---

**Phase 3: Advanced Features & Ecosystem Expansion (고급 기능 및 생태계 확장)**

* **목표:** hanaPOS Cloud Base를 종합 비즈니스 솔루션으로 발전시키고, 시장 경쟁력을 더욱 강화합니다.
* **당신의 역할:** Phase 2가 완료되면, 이 단계의 작업들을 **필요에 따라 선택하고 지시**합니다. 복잡한 작업이 많을 수 있습니다.

    * **단계 3.1: 온라인 주문 시스템**
        * **3.1.1 자체 웹 기반 주문 페이지 (Next.js):**
            * **지시:** "PRD 8.3.1.1에 따라, Next.js 기반으로 고객이 상품을 보고 주문할 수 있는 웹사이트를 만들어 줘. 장바구니, Supabase를 통한 주문 및 결제(QR 결제 연동) 기능을 포함시켜 줘."
        * **3.1.2 배달 플랫폼 연동 (선택적):**
            * **지시:** "PRD 8.3.1.2에 따라, GrabFood 또는 Foodpanda와 같은 필리핀 주요 배달 플랫폼의 주문을 통합 관리할 수 있는 API 연동 및 관련 UI를 구현해 줘. (해당 플랫폼의 개발자 문서가 필요할 수 있음)"

    * **단계 3.2: 고객 로열티 및 마케팅**
        * **3.2.1 포인트/리워드 시스템:**
            * **지시:** "PRD 8.3.2.1에 따라, 고객 구매 시 포인트를 적립하고, 적립된 포인트를 결제 시 사용할 수 있는 로열티 시스템을 구현해 줘."
        * **3.2.2 할인 및 프로모션 기능:**
            * **지시:** "PRD 8.3.2.2에 따라, 관리자가 다양한 할인(정액, 정률) 및 프로모션(예: 1+1)을 설정하고, POS 시스템에서 자동으로 적용되도록 기능을 구현해 줘."

    * **단계 3.3: 다중 매장 관리**
        * **3.3.1 다중 매장 관리 웹 대시보드 (Next.js):**
            * **지시:** "PRD 8.3.3에 따라, 여러 매장을 소유한 관리자가 각 매장의 매출, 재고 현황을 통합 관리할 수 있는 웹 대시보드를 Next.js로 구현해 줘."

    * **단계 3.4: 회계 소프트웨어 통합**
        * **3.4.1 Xero 또는 QuickBooks 연동:**
            * **지시:** "PRD 8.3.4에 따라, Xero 또는 QuickBooks 중 하나와 연동하여 hanaPOS Cloud Base의 판매 데이터를 자동으로 동기화하는 기능을 구현해 줘. (해당 API 문서 참조 필요)"

    * **단계 3.5: 직원 근태 관리**
        * **3.5.1 직원 출퇴근 기록 및 관리:**
            * **지시:** "PRD 8.3.5에 따라, 직원들이 앱에서 출퇴근 시간을 기록하고 관리자가 근무 시간을 확인할 수 있는 기능을 구현해 줘."

    * **단계 3.6: 하드웨어 통합 확장**
        * **3.6.1 바코드 스캐너 연동:**
            * **지시:** "PRD 8.3.6에 따라, Flutter 앱에서 Bluetooth 바코드 스캐너를 연동하여 상품을 빠르게 검색하고 장바구니에 추가하는 기능을 구현해 줘."
        * **3.6.2 주방 디스플레이 시스템 (KDS) 또는 고객 디스플레이 (CDP) 연동:**
            * **지시:** "PRD 8.3.6에 따라, 주방으로 주문 정보(KDS) 또는 고객에게 주문 내역(CDP)을 표시하는 기능을 구현해 줘. (연동 방식 협의 필요)"

---

### 7. 성공 기준 (Success Metrics)

* MVP 출시 후 3개월 내 **필리핀 전역**에서 10개 이상의 소규모 사업자 확보.
* 사용자 만족도 설문조사 평균 4.0/5.0점 이상 (사용성, 안정성).
* 판매 데이터 처리 정확도 99% 이상.
* GCash/PayMaya 결제 성공률 95% 이상.

---

**중요 참고 사항:**

* **BIR 규정 준수:** 필리핀에서 비즈니스를 하시려면 BIR(Bureau of Internal Revenue)의 POS 시스템 관련 규정을 반드시 준수해야 합니다. 이 부분은 기술적인 구현뿐만 아니라 법률적인 검토가 필요하므로, **Phase 2 또는 3 진행 시 현지 전문가의 자문을 받아야 함**을 Task-master에게도 명확히 알려주세요.
* **지속적인 피드백:** Task-master가 코드를 생성하고 기능을 구현할 때, 당신은 적극적으로 결과를 확인하고 필요한 경우 수정 사항이나 추가 지시를 내려야 합니다.

---

이 최종 PRD는 `hanaPOS Cloud Base` 프로젝트를 위한 포괄적인 개발 지침입니다. Task-master AI가 이 문서를 기반으로 모든 코딩 작업을 수행할 수 있도록 명확하게 구성되어 있습니다.
