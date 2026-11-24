# بازی با ساعت | Clock Game

بازی آفلاین آموزش ساعت عقربه‌ای برای کودک فارسی‌زبان. پنج دنیا و پنجاه مرحله دارد؛ هر مرحلهٔ داستانی پنج پرسش دارد. خواندن ساعت، تنظیم عقربه و جمع زمان به‌تدریج معرفی می‌شوند. تمرین آزاد بدون زمان‌سنج است؛ چالش روزانه سه پرسش در سی ثانیه دارد. در بازی دونفره، سارا و آراد به نوبت از همان دستگاه استفاده می‌کنند.

## ساخت در گیت‌هاب

۱. مخزن **Private** بسازید. ZIP را باز کنید و محتویات پوشهٔ `clock_game_fa` را در ریشهٔ شاخهٔ `main` قرار دهید؛ `.github` پوشهٔ پنهان است و باید منتقل شود. این پروژه را با سورس بازی دیگری ادغام نکنید.
۲. برای APK امضاشده طبق [راهنمای امضا](KEYSTORE-README.md) کلید بسازید، آن را Base64 کنید و چهار Secret را ثبت کنید. اگر فقط آزمون نصب می‌خواهید، از این مرحله بگذرید.
۳. از **Actions → Android APK → Run workflow** اجرا کنید. تحلیل و تست قبل از ساخت اجرا می‌شوند.
۴. انتهای اجرای سبز، از **Artifacts** بستهٔ `clock-game-release` یا `clock-game-debug` را بگیرید. ZIP خروجی GitHub را باز کنید و APK داخل آن را به گوشی منتقل کنید.
۵. APK را از فایل‌منیجر باز کنید. اگر اندروید اجازه خواست، نصب از همین منبع را موقتاً فعال کنید. اگر امضای نسخهٔ قبلی متفاوت است، پیش از حذف بدانید که دادهٔ محلی آن پاک می‌شود.

## ساخت محلی

Java ۱۷، Android SDK و Flutter را نصب کنید. نسخهٔ پیشنهادی و ثابت CI، Flutter ۳٫۲۹٫۳ است؛ قیود سورس از Dart ۳٫۵ شروع می‌شود ولی ترکیب‌های دیگر SDK و نسخه‌های وابستگی در این بسته تأیید نشده‌اند. حداقل اندروید API ۲۱؛ هدف API ۳۴؛ کامپایل API ۳۵.

```sh
./setup.sh             # دریافت وابستگی، تحلیل و تست
./setup.sh --apk       # همچنین ساخت APK آزمایشی
flutter run
```

در ویندوز `setup.bat` یا `setup.bat --apk`. برای نشر در فروشگاه‌ها، سطح API هدف و سیاست فعلی فروشگاه را جداگانه بررسی کنید؛ تنظیم API ۳۴ به درخواست پروژه است و تضمین پذیرش فروشگاه نیست.

## صدا، پیشرفت و محتوای فارسی

- فونت Vazirmatn داخل بسته است؛ برنامه برای دریافت فونت به اینترنت نیاز ندارد. مجوز قلم در `assets/fonts/OFL.txt` است.
- `flutter_tts` فقط `fa-IR` را درخواست می‌کند؛ اگر موتور دستگاه از آن پشتیبانی نکند، صدای زبان دیگری پخش نمی‌شود و متن روی صفحه می‌ماند. گویندهٔ فارسی ضبط‌شده داخل بسته نیست. در «حالت والدین» می‌توانید صدا را آزمایش کنید.
- گزارش، محدودیت زمان، ستاره‌ها و خریدها محلی هستند. ورودی والدین یک سؤال جمع است، نه قفل امنیتی یا مدیریت دستگاه. حذف برنامه پیشرفت را پاک می‌کند. جایزهٔ روزانه به تاریخ محلی دستگاه وابسته است.
- طرح اصلی: «نقشهٔ جغد ساعت». مسیر نقطه‌چین پیشرفت را نشان می‌دهد؛ در هر پرسش، خودِ صفحهٔ ساعت مرکز توجه می‌ماند. چینش فارسی آینه می‌شود، ولی جهت ساعت و جای اعداد همچنان استاندارد است.
- انیمیشن‌ها و افکت‌های صوتی تولیدشده قابل بازسازی با `python3 tools/generate_assets.py` و FFmpeg هستند.

## English

An on-device Persian-first analog clock game. Five worlds contain ten story levels each. It includes untimed practice, a timed daily session, local two-player turns, a cosmetic coin shop, and a parent dashboard. The app UI stays in Persian (`fa-IR`) with bundled Vazirmatn; clock numerals use Persian digits and remain in standard clockwise positions. Voice availability depends on the Android TTS engine; no other language is used as an in-app fallback.

Upload this folder's **contents**, including `.github`, to the root of a private repository. Use the signing guide to add repository secrets or leave them unset for a debug APK. Run **Actions → Android APK** and download and extract the resulting artifact. The checked-in Android wrapper and project are complete; setup scripts prepare dependencies and run checks rather than regenerating files. Java 17 and Flutter 3.29.3 are the CI baseline. Run `./setup.sh --apk` or `setup.bat --apk` locally. Unit tests cover Persian phrasing and digits, question generation, and star gates. Before publication, run CI and verify OEM TTS, TalkBack, Android 21 and modern Android devices, and actual game/session length with children.
