# Dockerfile للنشر على Railway
# ينشئ سيرفر Bedrock + playit-agent في نفس الحاوية

FROM itzg/minecraft-bedrock-server:latest AS bedrock

# --- مرحلة playit ---
FROM ghcr.io/playit-cloud/playit-agent:0.17 AS playit

# --- الصورة النهائية ---
FROM ubuntu:22.04

# تثبيت المتطلبات
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    netcat \
    libc6 \
    libcurl4 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مجلدات العمل
RUN mkdir -p /data /usr/local/bin /etc/playit

# نسخ ملفات Bedrock من المرحلة الأولى
COPY --from=bedrock /bedrock-server /bedrock-server
COPY --from=bedrock /usr/local/bin/entrypoint-demoter /usr/local/bin/
COPY --from=bedrock /usr/local/bin/bedrock-entry.sh /usr/local/bin/

# نسخ playit-agent من المرحلة الثانية
COPY --from=playit /playit /usr/local/bin/playit
COPY --from=playit /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# إعدادات Bedrock
ENV EULA=TRUE
ENV VERSION=1.26.23.1
ENV SERVER_NAME="Bedrock Server"
ENV GAMEMODE=survival
ENV DIFFICULTY=normal
ENV MAX_PLAYERS=100
ENV VIEW_DISTANCE=10
ENV TICK_DISTANCE=4
ENV PLAYER_IDLE_TIMEOUT=30
ENV MAX_THREADS=8
ENV LEVEL_NAME=BedrockLevel
ENV ONLINE_MODE=true
ENV WHITE_LIST=false
ENV SERVER_PORT=19132
ENV SERVER_PORT_V6=19133
ENV TEXTUREPACK_REQUIRED=false
ENV SERVER_AUTHORITATIVE_MOVEMENT=server-auth
ENV CORRECT_PLAYER_MOVEMENT=true

# إعدادات playit
ENV SECRET_KEY=""

WORKDIR /data

# سكريبت التشغيل
COPY start.sh /start.sh
RUN chmod +x /start.sh /usr/local/bin/playit /usr/local/bin/entrypoint-demoter /usr/local/bin/bedrock-entry.sh

EXPOSE 19132/udp 19133/udp

ENTRYPOINT ["/start.sh"]
