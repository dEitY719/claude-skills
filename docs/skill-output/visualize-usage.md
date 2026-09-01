# visualize 사용 결과

> **한 줄 요약** — `visualize` 스킬은 **마크다운(`.md`) 문서를 입력으로 받아, 자체 완결형 HTML(`.html`) 산출물을 생성**합니다.

```
마크다운 문서 (.md)  ──▶  /visuals:visualize  ──▶  HTML 산출물 (.html)
```

## 1. 실행한 명령

범용 형식:

```
/visuals:visualize <마크다운-문서-경로>
```

이번 예시:

```
/visuals:visualize skills/visualize/SKILL.md
```

## 2. 입력 (마크다운 문서)

- **입력 파일:** `skills/visualize/SKILL.md`
- `visualize` 스킬의 정의가 담긴 평범한 마크다운 문서입니다.
- 어떤 마크다운 문서든 입력으로 넣을 수 있습니다 — 위 파일은 하나의 예시일 뿐입니다.

## 3. 결과 (HTML 산출물)

위 명령을 실행하면, 입력 마크다운에 대응하는 **자체 완결형 HTML output** 이 생성됩니다.

- **생성 산출물:** [`docs/skill-guides/visualize.html`](../skill-guides/visualize.html)
- 별도 의존성 없이 브라우저에서 바로 열어볼 수 있는 단일 HTML 파일입니다.

> 마크다운 문서 한 장을, 한눈에 읽히는 시각 자료(HTML)로 바꿔주는 것이 `visualize` 스킬의 역할입니다.
