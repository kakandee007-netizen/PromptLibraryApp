# คลังพรอมป์ — สร้าง .ipa แล้วติดตั้งผ่าน KSign

KSign เซ็นและติดตั้ง `.ipa` ให้ได้ แต่ไม่ได้คอมไพล์โค้ด จึงต้องมีไฟล์ `.ipa`
ที่ build เสร็จก่อน ชุดนี้ตั้งค่าให้ build บนคลาวด์ฟรีได้เลย ไม่ต้องมี Mac

---

## วิธีที่แนะนำ: build บนคลาวด์ แล้วเซ็นด้วย KSign (ไม่ต้องใช้คอม)

### ขั้นที่ 1 — เอาไฟล์ขึ้น GitHub
1. สมัคร/ล็อกอิน GitHub (ทำบนเว็บในมือถือได้)
2. สร้าง repository ใหม่ (ตั้งเป็น Public หรือ Private ก็ได้)
3. อัปโหลดไฟล์ทั้งหมดในโฟลเดอร์นี้ขึ้นไป โดย **คงโครงสร้างโฟลเดอร์เดิม**:
   ```
   project.yml
   Sources/PromptLibraryApp.swift
   Sources/ContentView.swift
   Resources/index.html
   .github/workflows/build.yml
   ```
   (อัปโหลดผ่านปุ่ม “Add file ▸ Upload files” บนเว็บ GitHub ได้ ลากทีละโฟลเดอร์)

### ขั้นที่ 2 — ให้คลาวด์ build ไฟล์ .ipa
1. เข้าแท็บ **Actions** ใน repo
2. เลือกเวิร์กโฟลว์ **Build unsigned IPA** ▸ กด **Run workflow**
   (หรือมันจะรันเองทันทีหลังอัปโหลดไฟล์ขึ้น branch `main`)
3. รอประมาณ 2–4 นาที จนมีเครื่องหมายถูกสีเขียว
4. เปิดงานที่รันเสร็จ เลื่อนลงล่างสุดหัวข้อ **Artifacts** ▸ โหลด **PromptLibrary-ipa**
   จะได้ไฟล์ zip ที่ข้างในมี `PromptLibrary.ipa`

> ไฟล์ที่ได้เป็น .ipa แบบ **ยังไม่เซ็น** ซึ่งตรงกับที่ KSign ต้องการพอดี
> เพราะ KSign จะเซ็นด้วยใบรับรอง (certificate) ของคุณเองตอนติดตั้ง

### ขั้นที่ 3 — เซ็นและติดตั้งด้วย KSign
1. แตก zip เอาไฟล์ `PromptLibrary.ipa` (แอป Files บนไอโฟนทำได้)
2. เปิด KSign ▸ ไปที่ **Files** ▸ กด **+** ▸ **Import from Files** ▸ เลือก `PromptLibrary.ipa`
3. ไปที่ **Library** ▸ เลือกแอป ▸ กด **Sign and Install** ▸ **Start Signing**
4. ถ้าระบบถามให้เชื่อถือโปรไฟล์: ไปที่ Settings ▸ General ▸ VPN & Device Management แล้วกด Trust
5. เปิดแอป “คลังพรอมป์” จากหน้าจอโฮมได้เลย

---

## ทางเลือก: ถ้ามี Mac
เปิด Xcode ▸ New ▸ App (SwiftUI) ▸ แทนที่สองไฟล์ใน `Sources/` ▸ ลาก
`Resources/index.html` เข้าโปรเจกต์ (ติ๊ก Add to target) ▸ Product ▸ Archive ▸
Distribute เพื่อได้ .ipa จากนั้นจะเซ็นเองหรือส่งให้ KSign เซ็นก็ได้

---

## เกร็ด
- อยากแก้หน้าตา/ฟีเจอร์: แก้แค่ `Resources/index.html` แล้วสั่ง build ใหม่
- ข้อมูลพรอมป์เก็บในเครื่อง (UserDefaults ของแอป) อัปเดตแอปแล้วข้อมูลเดิมยังอยู่
- เปลี่ยนชื่อ/ไอคอนแอป: แก้ `INFOPLIST_KEY_CFBundleDisplayName` ใน `project.yml`
  ส่วนไอคอนเพิ่มได้ภายหลังใน Xcode (ถ้าใช้เส้นทาง Mac)
