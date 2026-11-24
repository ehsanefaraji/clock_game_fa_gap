# امضای APK / APK signing

۱. در رایانه‌ای که Java ۱۷ دارد، خارج از پوشهٔ پروژه اجرا کنید:

```sh
keytool -genkeypair -v -storetype PKCS12 -keystore clock-upload.p12 -alias clock-upload -keyalg RSA -keysize 3072 -validity 10000
```

رمز قوی انتخاب کنید. برای PKCS12 این دستور، رمز کلید و رمز مخزن یکسان است. از کلید و رمز در مکانی جدا و امن نسخهٔ پشتیبان داشته باشید. برای به‌روزرسانی APK مستقیم، همان کلید و همان شناسهٔ برنامه لازم است.

۲. خروجی Base64 را در محلی خصوصی بسازید؛ Base64 رمزنگاری نیست.

```sh
# Linux/macOS
base64 < clock-upload.p12 | tr -d '\r\n' > clock-upload.b64
```

```powershell
# Windows PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes((Resolve-Path 'clock-upload.p12').Path)) | Set-Content -NoNewline -Encoding ascii clock-upload.b64
```

۳. در مخزن: **Settings → Secrets and variables → Actions → New repository secret**. چهار مقدار را جداگانه وارد کنید:

- `KEYSTORE_BASE64`: تمام محتوای فایل `.b64` در یک خط
- `KEYSTORE_PASSWORD`: رمز فایل کلید
- `KEY_ALIAS`: مقدار `clock-upload` یا نام انتخاب‌شده هنگام ساخت
- `KEY_PASSWORD`: برای این دستور PKCS12، همان رمز مخزن

فایل کلید، Base64 و رمزها را commit نکنید یا در چت نفرستید. اگر مقدارها ناقص باشند، Workflow پس از تحلیل و تست، APK آزمایشی می‌سازد. اگر هر چهار مقدار حاضر ولی نامعتبر باشند، ساخت شکست می‌خورد و به حالت آزمایشی برنمی‌گردد.

## English
Run the `keytool` command above outside the repo. Securely back up the PKCS12 file and password. Encode the file as a single Base64 line and put it, the store password, key alias, and key password in the four **repository** secrets listed above. For this PKCS12 command the key password matches the store password. Never commit the key or encoded data. If switching from a debug APK to a release APK on-device, uninstall the debug build first if Android reports a signature mismatch; uninstalling erases local progress.
