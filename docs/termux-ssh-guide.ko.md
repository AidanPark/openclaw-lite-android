# Termux SSH 접속 가이드

폰의 Termux에 컴퓨터에서 SSH로 접속하면, 컴퓨터 키보드로 모든 명령어를 입력할 수 있습니다.

## 준비물

- 폰과 컴퓨터가 **같은 Wi-Fi 네트워크**에 연결되어 있어야 합니다

## 1단계: openssh 설치

폰에서 Termux 앱을 열고 입력합니다:

```bash
pkg install -y openssh
```

설치가 완료될 때까지 기다리세요 (1~2분).

## 2단계: 비밀번호 설정

```bash
passwd
```

비밀번호를 입력합니다 (예: `1234`):

```
New password: 1234          ← 입력
Retype new password: 1234   ← 같은 비밀번호 다시 입력
```

> 비밀번호 입력 시 화면에 아무것도 표시되지 않는 것이 정상입니다. 그냥 입력하고 Enter를 누르면 됩니다.

## 3단계: SSH 서버 시작

```bash
sshd
```

아무 메시지 없이 프롬프트(`$`)가 다시 나오면 정상입니다.

## 4단계: IP 주소 확인

```bash
ifconfig
```

`wlan0` 항목을 찾으세요:

```
wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.45.139  netmask 255.255.255.0
```

`inet` 뒤의 숫자가 폰의 IP 주소입니다 (위 예시에서는 `192.168.45.139`).

## 5단계: 컴퓨터에서 SSH 접속

컴퓨터 터미널(맥: 터미널, 윈도우: PowerShell 또는 명령 프롬프트)을 열고 입력합니다. IP 주소는 4단계에서 확인한 값으로 변경하세요:

```bash
ssh -p 8022 192.168.45.139
```

- `Are you sure you want to continue connecting?` → `yes` 입력
- `Password:` → 2단계에서 설정한 비밀번호 입력 (예: `1234`)

접속 성공하면 Termux의 `$` 프롬프트가 나타납니다. 이제부터 컴퓨터 키보드로 모든 Termux 명령어를 입력할 수 있습니다.

## 참고 사항

- Termux의 SSH 포트는 **8022**입니다 (일반 리눅스의 22가 아님)
- Termux 앱을 종료하면 SSH 서버도 꺼집니다. 다시 접속하려면 폰에서 Termux를 열고 `sshd`를 실행하세요
- 매번 `sshd`를 수동 실행하기 번거로우면 `~/.bashrc` 파일 맨 아래에 `sshd 2>/dev/null` 을 추가하면 Termux 시작 시 자동으로 SSH 서버가 켜집니다
