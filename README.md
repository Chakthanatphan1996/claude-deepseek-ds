# claude-deepseek-ds

ใช้ **Claude** วางแผนและตรวจงาน · ใช้ **DeepSeek** ลงมือเขียนโค้ด — ผ่าน Claude Code ตัวเดียวกัน สลับด้วยคำสั่ง `claude` / `ds`

> แจกโดยนักศึกษาเศรษฐศาสตร์ ม.อ. (ไม่ใช่สาย CS) ที่ใช้ workflow นี้ทำงานจริง · ไม่มีส่วนเกี่ยวข้องกับ Anthropic หรือ DeepSeek

## ทำไม
- Claude เก่งวางแผน คิดสถาปัตยกรรม และรีวิว แต่ถ้าให้เขียนโค้ดยาว ๆ เอง ใช้โควตาเร็ว
- DeepSeek ราคาต่อ token ถูกกว่ามาก เหมาะกับงาน "ทำตามแผน" ที่ใช้ token เยอะ
- **ผลจริงที่ลอง:** ระบบ POS ตัวอย่าง 8 ขั้น เทสผ่าน 66 ข้อ ค่า DeepSeek **$0.50** (57.8M tokens, พ.ย. 2569) — ราคาของคุณขึ้นกับงาน ช่วงเวลา และราคาปัจจุบันของ DeepSeek

## ติดตั้ง (macOS / Linux)
ต้องมีก่อน: Node.js 18+, Claude Code (`npm install -g @anthropic-ai/claude-code`), และ API key จาก [DeepSeek Platform](https://platform.deepseek.com/)

```bash
git clone https://github.com/Chakthanatphan1996/claude-deepseek-ds.git
cd claude-deepseek-ds
./install.sh
source ~/.zshrc     # หรือเปิด Terminal ใหม่
ds --version
```

`install.sh` จะ
1. ขอคีย์ (พิมพ์แล้วไม่แสดงบนจอ) เก็บที่ `~/.deepseek_key` สิทธิ์ 600 — **ไม่เก็บคีย์ใน repo**
2. เพิ่มฟังก์ชัน `ds` ใน `~/.zshrc` / `~/.bashrc` พร้อมสำรองไฟล์เดิม · รันซ้ำได้ไม่ซ้ำ
3. ถอนด้วย `./uninstall.sh`

Windows: ดูค่าตัวแปรใน `ds.sh` แล้วตั้งด้วย `$env:NAME="value"` ใน PowerShell ตาม [คู่มือ DeepSeek](https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code)

## วิธีใช้ — loop 3 ขั้น
| ขั้น | คำสั่ง | ทำอะไร |
|---|---|---|
| 1. วางแผน | `claude` (Opus/Sonnet) | ให้เขียนแผนเป็นไฟล์ `PLAN.md` — แตกเป็นขั้นเล็ก ๆ มีเกณฑ์ผ่านแต่ละขั้น |
| 2. ลงมือ | `ds` | "ทำตาม PLAN.md ทีละขั้น รันเทสทุกขั้น commit ทุกขั้น" |
| 3. ตรวจ | `claude` | "รีวิว diff ตั้งแต่ commit X เทียบกับ PLAN.md หาบั๊กและจุดเสี่ยง" |

รายละเอียดและ prompt ตัวอย่าง: [docs/workflow.md](docs/workflow.md) · แม่แบบ: [templates/](templates/)

## ข้อควรรู้ (อ่านก่อนใช้)
- **ข้อมูลไปที่เซิร์ฟเวอร์ DeepSeek ซึ่งเก็บและประมวลผลที่ประเทศจีน** ตาม[นโยบายความเป็นส่วนตัวของ DeepSeek](https://cdn.deepseek.com/policies/en-US/deepseek-privacy-policy.html) · อย่ารัน `ds` ในโฟลเดอร์ที่มีข้อมูลส่วนตัว รหัสผ่าน ไฟล์ `.env` จริง หรือข้อมูลคนอื่น
- ใน `ds` **MCP / connectors ใช้ไม่ได้** และจะเห็นคำเตือน model ไม่รู้จัก — ไม่เป็นไร
- ชื่อโมเดล `claude-opus*` ถูกแมปไป `deepseek-v4-pro` ส่วน `claude-sonnet*`/`claude-haiku*` ไป `deepseek-flash` ([อ้างอิง](https://api-docs.deepseek.com/guides/anthropic_api))
- ถ้ากด `/model` ใน `ds` แล้วบันทึก อาจไปเปลี่ยนค่าเริ่มต้นของ `claude` ปกติด้วย — ใช้ `claude --model sonnet` แก้
- DeepSeek คิด **ราคา 2 เท่าช่วง peak**: จ.–ศ. 01:00–04:00 และ 06:00–10:00 UTC (= 08:00–11:00 และ 13:00–17:00 เวลาไทย) · เช็กราคาล่าสุดที่ [Models & Pricing](https://api-docs.deepseek.com/quick_start/pricing) (ข้อมูล ณ 18 พ.ย. 2569)
- งานที่แตะฐานข้อมูลจริง (production) ระบบชำระเงิน หรือความปลอดภัย: ให้ Claude ตรวจทุกครั้ง และให้คนกด apply เอง

## License
MIT — ใช้ แก้ แจกต่อได้
