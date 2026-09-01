# excalidraw-diagram 사용 결과

## 1. 실행한 명령

```
/visuals:excalidraw-diagram docs/skill-output/example.txt
```

## 2. 입력 프롬프트 (`example.txt`)

> 지금 회로 다이어그램을 만들거야. 총 6개의 PMIC chip이 있고 이중에 1개는 Main-PMIC이고 나머지 5개는 Sub-PMIC야. Main PMIC에는 DSM ADC, SAR ADC와 함께 8개의 External source Channel, 10개의 NTC Channel이 있어. 각 Sub-PMIC에는 SAR ADC가 한개씩 들어가있어. SAR-ADC에는 Reference전압이 필요해서 칩 바깥쪽에서 받아올 수 있도록 그려줘. 연결선도 그리고 ADC의 input channel은 16개로 그려줘 ( mux를 활용)
>
> - MAIN 과 SUB의 통신선은 spmi로 표시해줘
> - adc의 block diagram은 네모가 아니라 ADC모양으로 해줘
> - NTC Line 그릴때 3 line으로 그려놓으면 헷갈리니까 중간에 `...`같이 더 line이 있다는것도 표시해줘
> - ex channel도 한개 input으로 들어가는데 일단 16개로 표현해줘

## 3. 결과

위 프롬프트를 바탕으로 **PMIC 시스템 아키텍처 다이어그램**이 생성되었습니다.

![PMIC System Architecture](./pmic-system.png)

> 1개의 Main PMIC + 5개의 Sub PMIC 구조를 SPMI 버스와 Vref 분배 경로까지 한 장에 표현한 다이어그램입니다.
