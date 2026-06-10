# 🎮 Minecraft Bedrock Server 1.26.23.1

سيرفر Minecraft Bedrock للجوال يعمل على **Railway** مع **playit.gg** لتونيل الاتصال.

## 📋 المتطلبات

- حساب [Railway](https://railway.app) (خطة Pro أو أعلى لـ 100 لاعب)
- حساب [playit.gg](https://playit.gg)
- Docker (للتشغيل المحلي)

## 🚀 التشغيل المحلي (Docker Compose)

```bash
# 1. نسخ الملفات
git clone <repo-url>
cd minecraft-bedrock-railway

# 2. إعداد المتغيرات
cp .env.example .env
# عدّل .env وضع PLAYIT_SECRET_KEY

# 3. التشغيل
docker-compose up -d

# 4. المشاهدة
docker-compose logs -f bedrock
docker-compose logs -f playit
```

## 🚂 النشر على Railway

### الطريقة 1: Docker Compose (مستحسن)

1. ارفع المشروع إلى GitHub
2. في Railway: New Project → Deploy from GitHub repo
3. اضبط **Variables** في Railway:
   - `PLAYIT_SECRET_KEY` = مفتاحك من playit.gg
4. Railway سيقرأ `docker-compose.yml` تلقائياً

### الطريقة 2: Dockerfile (خدمة واحدة)

1. ارفع المشروع إلى GitHub
2. في Railway: New Project → Deploy from GitHub repo
3. Railway يستخدم `Dockerfile` + `railway.json`
4. اضبط **Variable**:
   - `SECRET_KEY` = مفتاحك من playit.gg

## 🔧 إعداد playit.gg

1. سجل دخولك في [playit.gg](https://playit.gg)
2. Dashboard → **Agents** → Add Agent → اختر **Docker**
3. احفظ الـ **Secret Key**
4. Dashboard → **Tunnels** → Add Tunnel
   - **Type**: `UDP`
   - **Local Address**: `bedrock:19132` (أو `127.0.0.1:19132` إذا استخدمت Dockerfile)
   - **Name**: `bedrock-udp`
5. احفظ الـ **Public Address** (مثال: `xxx.gl.at.ply.gg:12345`)

## 📱 للاعبين (الجوال)

1. افتح Minecraft Bedrock
2. **Play** → **Servers** → **Add Server**
3. **Server Name**: اسم سيرفرك
4. **Server Address**: `xxx.gl.at.ply.gg` (من playit.gg)
5. **Port**: `12345` (من playit.gg)
6. **Play**

## ⚙️ إعدادات السيرفر (100 لاعب)

| الإعداد | القيمة | السبب |
|---------|--------|-------|
| MAX_PLAYERS | 100 | السعة المطلوبة |
| MAX_THREADS | 8 | استخدام CPU كامل |
| VIEW_DISTANCE | 10 | توازن الأداء |
| TICK_DISTANCE | 4 | تحديث أقل للـ chunks البعيدة |
| PLAYER_IDLE_TIMEOUT | 30 | طرد الخاملين |

## 🛡️ الحماية

- `ONLINE_MODE=true`: يتحقق من Xbox Live
- `WHITE_LIST=false`: مفتوح للجميع (فعّله إذا أردت)
- `CORRECT_PLAYER_MOVEMENT=true`: يمنع غش الحركة

## 💰 تكلفة Railway (تقديرية)

| الخطة | RAM | CPU | السعر | ملائمة |
|-------|-----|-----|-------|--------|
| Hobby | 3GB | مشترك | $5/شهر | ❌ غير كافٍ لـ 100 لاعب |
| Pro | 8GB | 2 vCPU | ~$10/شهر | ⚠️ حد أدنى |
| Team | 16GB | 4 vCPU | ~$20/شهر | ✅ مثالي لـ 100 لاعب |

> **ملاحظة**: Bedrock أخف من Java، لكن 100 لاعب يحتاجون **8GB RAM على الأقل**.

## 📝 الملفات

| الملف | الوصف |
|-------|-------|
| `docker-compose.yml` | تشغيل Bedrock + playit كخدمات منفصلة |
| `Dockerfile` | صورة واحدة للنشر على Railway |
| `start.sh` | سكريبت التشغيل المشترك |
| `railway.json` | إعدادات Railway |
| `.env.example` | نموذج المتغيرات |

## 🔍 استكشاف الأخطاء

```bash
# مشاهدة logs
docker-compose logs -f bedrock
docker-compose logs -f playit

# إعادة التشغيل
docker-compose restart

# دخول الحاوية
docker exec -it bedrock-server bash
docker exec -it playit-agent sh
```

## 📄 رخصة

EULA Minecraft مطلوبة. لا تستخدم هذا المشروع إذا لم توافق على [EULA](https://www.minecraft.net/en-us/eula).
