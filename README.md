# Obsidian-CLI One-Click Kit

> Windows에서 **NotesMD CLI**를 한 번의 클릭으로 설치하고 사용하는 원클릭 키트입니다.

[English README](./README.en.md)

---

## 프로젝트 개요

**NotesMD CLI**는 [Yakitrak/notesmd-cli](https://github.com/Yakitrak/notesmd-cli)에서 개발한 오픈소스 도구로, Obsidian 볼트(노트 저장 폴더)를 터미널에서 직접 관리할 수 있게 해줍니다.

이 키트는 일반 사용자도 별도 설정 없이 바로 사용할 수 있도록 **설치 → 실행 → 제거** 흐름을 `.bat` 파일 3개로 단순화한 Windows 전용 원클릭 패키지입니다.

---

## 주요 기능

RUN.bat을 실행하면 아래 15가지 기능을 메뉴에서 선택할 수 있습니다.

| 번호 | 기능 | 설명 |
|------|------|------|
| 1 | 기본 볼트 설정 | Obsidian 볼트 이름을 기본값으로 지정 |
| 2 | 볼트 정보 보기 | 현재 설정된 볼트 경로 확인 |
| 3 | 노트 열기 | 특정 노트를 Obsidian 또는 편집기로 열기 |
| 4 | 오늘 일기 열기 | Daily Note를 바로 열기 |
| 5 | 노트 퍼지 검색 | 노트 이름 일부로 빠르게 찾기 |
| 6 | 내용 검색 | 노트 내용 중 특정 단어 검색 |
| 7 | 볼트 목록 보기 | 볼트의 모든 노트 목록 출력 |
| 8 | 노트 내용 출력 | 터미널에서 노트 내용 읽기 |
| 9 | 노트 생성/수정 | 새 노트 생성 또는 내용 추가·덮어쓰기 |
| 10 | 노트 이동/이름 변경 | 자동으로 연결된 링크도 함께 업데이트 |
| 11 | 노트 삭제 | 확인 후 영구 삭제 |
| 12 | 프론트매터 관리 | YAML 메타데이터 조회·추가·삭제 |
| 13 | 버전 확인 | 설치된 notesmd-cli 버전 출력 |
| 14 | 업데이트 | 최신 버전으로 자동 업데이트 |
| 15 | 전체 도움말 | 모든 명령어 레퍼런스 보기 |

---

## 시스템 요구 사항

- **운영체제**: Windows 10 / 11 (64비트)
- **PowerShell**: 버전 5 이상 (Windows 기본 포함)
- **인터넷 연결**: 설치 시 GitHub에서 파일 다운로드 필요
- **Obsidian**: 노트를 열려면 [Obsidian](https://obsidian.md) 설치 권장

---

## 설치 방법

### 방법 1: 원클릭 키트 사용 (권장)

1. 이 저장소 Releases 페이지에서 `Obsidian-CLI_NotesMD-CLI_One-Click_Kit.7z`를 다운로드합니다.
2. 압축을 해제합니다.
3. **`INSTALL.bat`** 을 더블클릭합니다.
4. 설치가 완료되면 **현재 터미널을 닫고 새 터미널을 열어야** 합니다. (PATH 적용을 위해 필수)

> 설치 중 Windows Defender나 백신 프로그램이 경고를 표시할 수 있습니다. 이 키트는 공개 GitHub에서 도구를 다운로드하는 스크립트이며 악성코드가 없습니다.

### 방법 2: 수동 설치

```
https://github.com/Yakitrak/notesmd-cli/releases
→ Windows amd64 버전 다운로드
→ notesmd-cli.exe를 %USERPROFILE%\bin 폴더에 복사
→ %USERPROFILE%\bin 경로를 Windows PATH에 추가
```

---

## 실행 방법

설치 완료 후 새 터미널(또는 새 창)을 열고:

1. **`RUN.bat`** 을 더블클릭합니다.
2. 메뉴에서 원하는 번호를 입력하고 Enter를 누릅니다.

**처음 실행 시 반드시 [1] 기본 볼트 설정 먼저 하기**
→ Obsidian 볼트 폴더 이름을 입력합니다. (예: `MyNotes`)

---

## 제거 방법

1. **`UNINSTALL.bat`** 을 더블클릭합니다.
2. `uninstall`을 입력하고 Enter를 눌러 확인합니다.

> **안전 보장**: 제거 시 Obsidian 볼트(노트 파일)는 절대 삭제되지 않습니다. CLI 도구 파일만 제거됩니다.

---

## 폴더 구조

```
Obsidian-CLI_One-Click_Kit/
├── INSTALL.bat                                 # 설치 스크립트 (v14)
├── RUN.bat                                     # 실행 메뉴 스크립트 (v13)
├── UNINSTALL.bat                               # 제거 스크립트 (v13)
├── Obsidian-CLI_NotesMD-CLI_One-Click_Kit.7z  # 배포용 압축 파일 (Releases 첨부)
├── README.md                                   # 이 문서 (한국어)
├── README.en.md                                # English documentation
└── LICENSE                                     # 라이선스
```

---

## 코딩을 전혀 모르는 분을 위한 가이드

이 프로그램은 **코딩 지식이 전혀 없어도** 사용할 수 있습니다.

**딱 3가지만 기억하세요:**

| 파일 | 언제 쓰나요? |
|------|------------|
| `INSTALL.bat` | 처음 한 번만 — 프로그램 설치 |
| `RUN.bat` | 매번 사용할 때 — 프로그램 실행 |
| `UNINSTALL.bat` | 더 이상 필요 없을 때 — 프로그램 제거 |

**.bat 파일이 뭔가요?**
배치 파일이라고 불리는 Windows 전용 자동화 스크립트입니다. 더블클릭하면 프로그램처럼 실행됩니다.

**"관리자 권한으로 실행"이 필요한가요?**
아니요. 일반 사용자 권한으로 실행됩니다. `%USERPROFILE%\bin` (내 문서 안의 폴더)에 설치됩니다.

---

## 운영 시 주의사항

- `INSTALL.bat` 실행 후 반드시 새 터미널을 열어야 `RUN.bat`이 정상 작동합니다.
- 볼트 이름은 Obsidian에서 설정한 **폴더 이름**과 정확히 일치해야 합니다.
- 노트 삭제([11])는 되돌릴 수 없으니 신중하게 사용하세요.
- 인터넷이 없는 환경에서는 [14] 업데이트 기능을 사용할 수 없습니다.

---

## 라이선스

이 프로젝트는 [MIT License](./LICENSE)를 따릅니다.

Copyright © 2026 SoDam AI Studio

> **참고**: 이 키트가 다운로드하는 `notesmd-cli` 도구 자체는 [Yakitrak/notesmd-cli](https://github.com/Yakitrak/notesmd-cli)의 별도 라이선스를 따릅니다.
