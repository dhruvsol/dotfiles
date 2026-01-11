#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# 🌸 Sakura Night - Screen Recorder
# ═══════════════════════════════════════════════════════════════

RECORD_DIR="$HOME/Videos/Recordings"
mkdir -p "$RECORD_DIR"

PIDFILE="/tmp/screenrecord.pid"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$RECORD_DIR/recording_$TIMESTAMP.mp4"

start_recording() {
    local area="$1"
    
    if [[ "$area" == "area" ]]; then
        GEOMETRY=$(slurp)
        [[ -z "$GEOMETRY" ]] && exit 1
        wf-recorder -g "$GEOMETRY" -f "$FILENAME" &
    else
        wf-recorder -f "$FILENAME" &
    fi
    
    echo $! > "$PIDFILE"
    notify-send -i media-record "Recording" "Started recording..." -h string:x-canonical-private-synchronous:screenrecord
}

stop_recording() {
    if [[ -f "$PIDFILE" ]]; then
        kill -SIGINT "$(cat $PIDFILE)" 2>/dev/null
        rm -f "$PIDFILE"
        notify-send -i media-playback-stop "Recording" "Saved to Videos/Recordings" -h string:x-canonical-private-synchronous:screenrecord
    fi
}

case "$1" in
    "start")
        start_recording "full"
        ;;
    "start-area")
        start_recording "area"
        ;;
    "stop")
        stop_recording
        ;;
    "toggle")
        if [[ -f "$PIDFILE" ]] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
            stop_recording
        else
            # Ask full or area
            CHOICE=$(echo -e "Full Screen\nSelect Area" | rofi -dmenu -p "󰍹 Record")
            case "$CHOICE" in
                "Full Screen") start_recording "full" ;;
                "Select Area") start_recording "area" ;;
            esac
        fi
        ;;
    *)
        echo "Usage: $0 {start|start-area|stop|toggle}"
        exit 1
        ;;
esac

