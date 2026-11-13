#!/bin/bash
set -e
git config user.name sigco3111
git config user.email sigco3111@users.noreply.github.com
S=$1; U=$2; T=$3; L=$4; A=$5; P=$6; G=$7; R=$8; C=$9
mkdir -p $S; rm -rf _x; mkdir _x
curl -fsSL --retry 3 -o _dl "$U" || { echo FAIL $S; exit 1; }
if unzip -tq _dl >/dev/null 2>&1; then cp _dl $S/$S.zip; unzip -qo $S/$S.zip -d _x; else cp _dl "_x/$(basename "$U")"; (cd _x && zip -q -r "../$S/$S.zip" .); fi
N=$(find _x -type f | wc -l); Z=$(du -h $S/$S.zip | cut -f1)
I=$(find _x -type f \( -iname '*.png' -o -iname '*.jpg' \) -printf '%s %p\n' | sort -rn | head -1 | cut -d' ' -f2-)
if [ -n "$I" ]; then convert "$I[0]" -resize 512x512 -background white -gravity center -extent 512x512 $S/preview.jpg; else convert -size 512x512 xc:white -annotate +0+0 "$T" $S/preview.jpg; fi
rm -rf _x
printf '# %s\n- 출처 URL: %s\n- 받은 파일: %s.zip (%s)\n- 라이선스: %s\n- 제작자: %s\n- 공개일: %s\n- 파일 수: %s\n- 태그: %s\n- 표기 요구: %s\n- AI 생성 여부: 출처 페이지에 언급 없음\n' "$T" "$R" $S "$Z" "$L" "$A" "$P" "$N" "$G" "$C" > $S/pack.md
printf '%s\n출처 URL: %s\n표기 라이선스: %s\n제작자: %s\n공개일: %s\n이 파일은 수집자가 출처 페이지의 라이선스 표기를 기록한 것입니다.\n' "$T" "$R" "$L" "$A" "$P" > $S/LICENSE-SOURCE.txt
case "$C" in yes*) printf '%s\n제작자: %s (OpenGameArt.org)\n출처: %s\n라이선스: %s\n표기 예:\n"%s" by %s (OpenGameArt.org), %s\n' "$T" "$A" "$R" "$L" "$T" "$A" "$L" > $S/CREDITS.txt;; esac
git add -A; git commit -qm "에셋: $T 추가"; git push
