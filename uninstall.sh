#!/usr/bin/env bash
# ถอดคำสั่ง ds ออกจาก rc (ไม่ลบคีย์ — ลบเองถ้าต้องการ: rm ~/.deepseek_key)
set -euo pipefail
for RC in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
  [ -f "$RC" ] || continue
  if grep -qF "# >>> claude-deepseek-ds >>>" "$RC"; then
    cp "$RC" "$RC.bak-ds-uninstall-$(date +%Y%m%d%H%M%S)"
    sed -i.tmp '/# >>> claude-deepseek-ds >>>/,/# <<< claude-deepseek-ds <<</d' "$RC" && rm -f "$RC.tmp"
    echo "ถอด ds ออกจาก $RC แล้ว"
  fi
done
