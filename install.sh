#!/usr/bin/env bash
# ติดตั้งคำสั่ง ds (Claude Code + DeepSeek) — macOS / Linux
# รันซ้ำได้ ไม่เพิ่มซ้ำ · สำรอง rc เดิมก่อนแก้
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

command -v claude >/dev/null 2>&1 || {
  echo "ยังไม่มี Claude Code — ติดตั้งก่อน: npm install -g @anthropic-ai/claude-code (ต้องมี Node.js 18+)"; exit 1; }

case "${SHELL##*/}" in
  zsh)  RC="$HOME/.zshrc" ;;
  bash) RC="$HOME/.bashrc" ;;
  *)    RC="$HOME/.profile" ;;
esac

if [ ! -s "$HOME/.deepseek_key" ]; then
  printf "วาง DeepSeek API key (ตัวอักษรจะไม่แสดง): "
  read -rs KEY; echo
  [ -n "$KEY" ] || { echo "ไม่ได้ใส่คีย์"; exit 1; }
  umask 077; printf "%s" "$KEY" > "$HOME/.deepseek_key"; unset KEY
  chmod 600 "$HOME/.deepseek_key"
  echo "บันทึกคีย์ที่ ~/.deepseek_key (chmod 600) แล้ว"
else
  echo "มี ~/.deepseek_key อยู่แล้ว — ใช้ของเดิม"
fi

MARK_BEGIN="# >>> claude-deepseek-ds >>>"
MARK_END="# <<< claude-deepseek-ds <<<"
touch "$RC"
if grep -qF "$MARK_BEGIN" "$RC"; then
  echo "$RC มีคำสั่ง ds อยู่แล้ว — ไม่แก้"
else
  cp "$RC" "$RC.bak-ds-$(date +%Y%m%d%H%M%S)"
  { echo; echo "$MARK_BEGIN"; cat "$HERE/ds.sh"; echo "$MARK_END"; } >> "$RC"
  echo "เพิ่มคำสั่ง ds ใน $RC แล้ว (สำรองไฟล์เดิมไว้ข้าง ๆ)"
fi
echo "เสร็จ — เปิด Terminal ใหม่ หรือรัน: source $RC แล้วลอง: ds --version"
