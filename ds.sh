# ds — รัน Claude Code โดยใช้โมเดล DeepSeek แทน Claude
# ใส่ไว้ใน ~/.zshrc หรือ ~/.bashrc (install.sh ทำให้อัตโนมัติ)
# คีย์อ่านจากไฟล์ ~/.deepseek_key (chmod 600) — ไม่ฝังคีย์ในไฟล์นี้
ds() {
  if [ ! -s "$HOME/.deepseek_key" ]; then
    echo "ไม่พบ ~/.deepseek_key — รัน install.sh ก่อน" >&2
    return 1
  fi
  ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" \
  ANTHROPIC_AUTH_TOKEN="$(tr -d '\n' < "$HOME/.deepseek_key")" \
  ANTHROPIC_MODEL="deepseek-flash[1m]" \
  ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-flash[1m]" \
  ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-flash[1m]" \
  ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-flash" \
  CLAUDE_CODE_SUBAGENT_MODEL="deepseek-flash" \
  CLAUDE_CODE_AUTO_COMPACT_WINDOW="786432" \
  claude "$@"
}
