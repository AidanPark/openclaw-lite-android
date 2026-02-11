# CLAUDE.md - OpenClaw Lite Android

## Project Overview

Android Termux에서 proot-distro 없이 OpenClaw(Node.js AI 에이전트 게이트웨이)를 설치하는 스크립트 + 패치 세트.
범위는 `npm install -g openclaw@latest` 성공까지. 설치 이후 설정/운영은 범위 밖.

## Architecture

```
install.sh (진입점)
  ├── [1/6] scripts/check-env.sh      # Termux 환경 검증
  ├── [2/6] scripts/install-deps.sh    # pkg install (nodejs-lts 등)
  ├── [3/6] scripts/setup-paths.sh     # 디렉토리 생성
  ├── [4/6] scripts/setup-env.sh       # .bashrc에 환경변수 추가
  ├── [5/6] patches/apply-patches.sh   # 패치 적용
  │         ├── bionic-compat.js 복사
  │         └── patches/patch-paths.sh # sed로 하드코딩 경로 치환
  └── [6/6] tests/verify-install.sh    # 설치 검증
```

## Key Technical Decisions

- **bionic-compat.js**: `os.networkInterfaces()`를 monkey-patch. `NODE_OPTIONS="-r ..."` 로 자동 로드
- **경로 패치**: 설치된 OpenClaw JS 파일 내 `/tmp`, `/bin/sh`, `/bin/bash`, `/usr/bin/env`를 `$PREFIX/...`로 sed 치환
- **환경변수 블록**: `.bashrc`에 `# >>> OpenClaw Lite Android >>>` / `# <<< OpenClaw Lite Android <<<` 마커로 관리 (중복 방지, 제거 용이)
- **CONTAINER=1**: systemd 의존성 우회용 환경변수

## Conventions

### Shell Scripts
- 모든 스크립트는 `#!/usr/bin/env bash` + `set -euo pipefail`
- ANSI 색상 코드: `RED`, `GREEN`, `YELLOW`, `BOLD`, `NC` (No Color) 변수 사용
- 출력 포맷: `[OK]`, `[FAIL]`, `[WARN]`, `[SKIP]`, `[INFO]` 접두사
- 스크립트 상단에 한 줄 주석으로 목적 설명: `# filename.sh - 설명`

### JavaScript (patches/)
- CommonJS (`require`) 사용 — `'use strict'` 필수
- Node.js 내장 모듈만 사용 (외부 의존성 없음)

## Useful Commands

```bash
# 문법 체크 (모든 쉘 스크립트)
for f in install.sh uninstall.sh patches/*.sh scripts/*.sh tests/*.sh; do bash -n "$f"; done

# JS 문법 체크
node -c patches/bionic-compat.js

# shellcheck 정적 분석 (설치된 경우)
shellcheck install.sh uninstall.sh patches/*.sh scripts/*.sh tests/*.sh

# 실제 Termux에서 end-to-end 테스트
bash install.sh
```

## File Roles

| 파일 | 수정 시 주의사항 |
|------|-----------------|
| `patches/bionic-compat.js` | `NODE_OPTIONS`로 모든 Node 프로세스에 주입됨. 사이드이펙트 최소화 필수 |
| `scripts/setup-env.sh` | `.bashrc` 직접 수정. 마커 기반 블록 관리 로직 변경 시 `uninstall.sh`도 함께 수정 |
| `patches/patch-paths.sh` | OpenClaw 업데이트 시 재실행 필요. sed 패턴 변경 시 광범위 영향 |
| `install.sh` | 6단계 순서 의존성 있음. 단계 추가/제거 시 step 번호와 총 개수 업데이트 |

## Target Environment

- **Runtime**: Termux on Android (aarch64 primary, armv7l supported)
- **Node.js**: >= 22.12.0 (LTS)
- **Shell**: Bash (Termux 기본)
- **NOT supported**: proot-distro, adb shell, standard Linux
