# md-to-scrolldeck 사용 결과

> **한 줄 요약** — `md-to-scrolldeck` 스킬은 **마크다운(`.md`) 문서 한 개를 리더 보고용 세로 스크롤스냅 HTML 덱(scrollytelling)으로 압축**합니다.

```
마크다운 문서 (.md)  ──▶  /visuals:md-to-scrolldeck  ──▶  세로 스크롤 덱 (.html)
```

`visualize` 가 문서를 **한 장의 시각 자료**로 바꾼다면, 이 스킬은 문서를
**여러 개의 내러티브 비트(슬라이드)** 로 나눕니다. 핵심은 마크업이 아니라
**편집적 압축** — 제목을 1:1로 슬라이드에 옮기지 않고, 무엇을 자를지 결정합니다.

## 1. 실행한 명령

범용 형식:

```
/visuals:md-to-scrolldeck <마크다운-문서-경로> [--out <경로>] [--slides n] [--outline-only]
```

이번 예시:

```
/visuals:md-to-scrolldeck README.md --out docs/skill-output/md-to-scrolldeck-deck.html --no-open
```

## 2. 입력 (마크다운 문서)

- **입력 파일:** [`README.md`](../../README.md) — 이 저장소의 README (177줄)
- 어떤 마크다운 문서든 입력으로 넣을 수 있습니다. 이번에는 저장소 자신의
  README 를 "리더에게 보고하는 문서" 로 보고 덱으로 만들었습니다.

## 3. 중간 산출물 (슬라이드 아웃라인)

이 스킬은 **HTML 을 쓰기 전에 먼저 아웃라인을 출력**합니다. 여기서 무엇이
살아남고 무엇이 잘렸는지 확인하고 개입할 수 있습니다.

| # | id | 라벨 | phase | 출처 |
|---|----|------|-------|------|
| 1 | `hero` | 보여줄 수 있는 것으로 만드는 세 스킬 | INTRO | L1-6 |
| 2 | `three-skills` | 세 개의 산출물, 세 개의 스킬 | WHAT | L8-14 |
| 3 | `pick-rule` | 주제가 아니라 산출물로 고른다 | WHAT | L16-18 |
| 4 | `install` | 여섯 하네스, 한 줄 설치 | INSTALL | L29-72 |
| 5 | `support-matrix` | 어디까지 되는가 | HOW | L74-86 |
| 6 | `image-readback` | 이미지를 되읽지 못하는 하네스라면 | HOW | L88-95 |
| 7 | `layout-flat` | 매니페스트는 루트, 스킬은 평평하게 | HOW | L97-118 |
| 8 | `layout-why` | 중첩 레이아웃을 버린 이유 | HOW | L120-128 |
| 9 | `ci-selfcontained` | 공유 워크플로우를 쓰지 않는다 | HOW | L130-145 |
| 10 | `ci-gate` | 되돌아가기 위한 단 하나의 조건 | NEXT | L147-153 |
| 11 | `provenance` | 이 스킬들은 어디서 왔는가 | NEXT | L155-173 |
| 12 | `close` | MIT, 그리고 시작하기 | START | L175-177 |

**잘라낸 것:** GitHub Pages 링크 목록(L20-27, 링크 덤프) · 하네스별 설치
코드블록 7개는 슬라이드 4의 카드 그리드 하나로 병합 · `.kimi-plugin`
사전 프로비저닝 각주는 슬라이드 8에 흡수.

177줄 문서에서 39개 제목이 아니라 **12개 슬라이드**가 나온 이유가 이것입니다.

## 4. 결과 (스크롤 덱)

- **생성 산출물:** [`docs/skill-output/md-to-scrolldeck-deck.html`](./md-to-scrolldeck-deck.html)
- 단일 HTML 파일이며, 상단 진행바 · 고정 헤더(`01 / 12` 카운터) · 우측 도트 레일 ·
  방향키 내비게이션 · 인쇄 대응을 모두 포함합니다.
- 작성 후 체크리스트 검증을 통과했습니다: 슬라이드 12 = 도트 12,
  스크롤 큐 11개가 다음 슬라이드로 정확히 연결, 금지 항목(테마 토글 ·
  햄버거 메뉴 · PNG 내보내기 · base64 폰트) 0건.

> 문서를 요약하는 것이 아니라, **무엇을 버릴지 결정해서 이야기로 만드는 것**이
> `md-to-scrolldeck` 스킬의 역할입니다.
