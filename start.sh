#!/bin/bash
set -e

# ====== تشغيل Bedrock Server ======
echo "[$(date)] Starting Bedrock Server..."

export LD_LIBRARY_PATH=/bedrock-server

# إنشاء server.properties إذا لم يكن موجوداً
if [ ! -f /data/server.properties ]; then
    cat > /data/server.properties <<EOF
server-name=${SERVER_NAME:-Bedrock Server}
gamemode=${GAMEMODE:-survival}
difficulty=${DIFFICULTY:-normal}
allow-cheats=false
max-players=${MAX_PLAYERS:-50}
online-mode=${ONLINE_MODE:-true}
white-list=${WHITE_LIST:-false}
server-port=${SERVER_PORT:-19132}
server-portv6=${SERVER_PORT_V6:-19133}
view-distance=${VIEW_DISTANCE:-10}
tick-distance=${TICK_DISTANCE:-4}
player-idle-timeout=${PLAYER_IDLE_TIMEOUT:-30}
max-threads=${MAX_THREADS:-8}
level-name=${LEVEL_NAME:-BedrockLevel}
level-seed=${LEVEL_SEED:-}
default-player-permission-level=member
texturepack-required=${TEXTUREPACK_REQUIRED:-false}
content-log-file-enabled=false
compression-threshold=1
compression-algorithm=zlib
server-authoritative-movement=${SERVER_AUTHORITATIVE_MOVEMENT:-server-auth}
player-movement-score-threshold=${PLAYER_MOVEMENT_SCORE_THRESHOLD:-20}
player-movement-distance-threshold=${PLAYER_MOVEMENT_DISTANCE_THRESHOLD:-0.3}
player-movement-duration-threshold-in-ms=${PLAYER_MOVEMENT_DURATION_THRESHOLD_IN_MS:-500}
correct-player-movement=${CORRECT_PLAYER_MOVEMENT:-true}
EOF
fi

# تشغيل Bedrock Server في الخلفية
cd /bedrock-server
./bedrock-server &
BEDROCK_PID=$!

sleep 5

echo "[$(date)] Bedrock Server started on PID $BEDROCK_PID"

# ====== تشغيل playit-agent ======
if [ -n "$SECRET_KEY" ]; then
    echo "[$(date)] Starting playit-agent..."
    /usr/local/bin/playit --secret "$SECRET_KEY" &
    PLAYIT_PID=$!
    echo "[$(date)] playit-agent started on PID $PLAYIT_PID"
else
    echo "[$(date)] WARNING: SECRET_KEY not set. playit-agent will not start."
    PLAYIT_PID=""
fi

# ====== مراقبة العمليات ======
cleanup() {
    echo "[$(date)] Shutting down..."
    if [ -n "$PLAYIT_PID" ]; then
        kill $PLAYIT_PID 2>/dev/null || true
    fi
    kill $BEDROCK_PID 2>/dev/null || true
    wait
    exit 0
}

trap cleanup SIGTERM SIGINT

# انتظار إيقاف Bedrock Server
wait $BEDROCK_PID
