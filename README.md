# 전화번호부 통합 프로젝트 (Spring Boot + React + Flutter)

> 플러터 학습 이후 간단하게 진행한 전화번호부 구현 프로젝트입니다.  
> 원래는 Flutter 앱 개발이 목표였으나, 개인적으로 React UI를 추가 제작하고,  
> 기존 미니 프로젝트에서 사용했던 Spring Boot 백엔드와 연동해 **3개의 플랫폼을 연결**한 프로젝트입니다.

---

## 프로젝트 기간
- 2025.03.11 ~ 2025.03.22

---

## 프로젝트 목표

- Flutter의 기본 구조 이해 및 실습
- React, Spring Boot 백엔드와 연동하여 **풀스택 연계 구조 테스트**
- 전화번호부 CRUD 기능 구현 및 **검색 자동완성 기능(AutoComplete)** 실습
- 프로필 이미지 + 애니메이션 효과 적용 학습

---

## 구현 기능

- 연락처 등록 / 수정 / 삭제 / 조회 (CRUD)
- 검색 기능:
  - 이름 or 전화번호 기준 선택 후 입력
  - `김`을 입력하면 `김`으로 시작하는 모든 사용자 자동 노출
  - 드롭다운 기반 필터 옵션 적용
- 프로필 사진 등록 기능
- 기본 사진 애니메이션 적용 (Flutter에서 Lottie 또는 JSON 기반 애니메이션 사용)

---

## 기술 스택

- **Frontend (Web)**: React, JSX, CSS
- **Backend**: Spring Boot, Java, MyBatis
- **Mobile App**: Flutter, Dart
- **Database**: MySQL
- **DevOps**: Docker (Spring)

---

## 폴더 구성 요약

```
spring/
 ┣ controller, service, mapper, vo
 ┣ mybatis/mappers (xml)
 ┣ Dockerfile

react/
 ┣ components (PhoneAppAdd.jsx 등)
 ┣ css
 ┣ App.jsx, main.jsx, vite.config.js

flutter/
 ┣ lib/
 ┃ ┣ main.dart, list.dart, writeForm.dart, editForm.dart
 ┣ assets/
 ┃ ┣ loading_animation.json
 ┣ pubspec.yaml
```

---

## 느낀 점

> 기본적인 전화번호부 기능을 다양한 프레임워크로 구현해보면서,  
> 각 플랫폼 간 UI 구성 방식과 API 연동 구조의 차이를 체험할 수 있었습니다.  
> 특히 **검색 자동완성 기능을 React에서 구현하면서 실시간 검색 처리와 UX 설계의 중요성**을 느꼈고,  
> **Flutter에서의 애니메이션 적용**은 사용자 경험을 보다 풍부하게 만들어주는 흥미로운 시도였습니다.  
> 간단한 프로젝트였지만, **크로스 플랫폼 구조를 동시에 구현한 점**이 유의미했습니다.
