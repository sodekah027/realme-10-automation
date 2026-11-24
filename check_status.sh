#!/bin/bash
# ==========================================================
# check_status.sh
# Fungsi: Memeriksa dan melaporkan status akhir perangkat
#         (Hotspot, IP Gateway, Status Layar, Baterai).
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "$0" "$@"
fi

echo "--- [3/3] Menjalankan: check_status.sh ---"

# 1. Cek status Hotspot & IP
HOTSPOT_ACTIVE=false
if ip link show ap0 2>/dev/null | grep -q "state UP" || cmd wifi status 2>/dev/null | grep -q "SoftApManager"; then
    HOTSPOT_ACTIVE=true
fi

# 2. Ambil IP Hotspot
AP_IP=$(ip -4 addr show ap0 2>/dev/null | grep -o "inet [0-9.]*" | awk '{print $2}')

# 3. Status Layar
WAKEFULNESS=$(dumpsys power 2>/dev/null | grep -o "mWakefulness=[a-zA-Z]*" | head -n 1 | cut -d= -f2)

# 4. Status Baterai
BATTERY_LEVEL=$(dumpsys battery 2>/dev/null | grep "level:" | awk '{print $2}')
BATTERY_TEMP=$(dumpsys battery 2>/dev/null | grep "temperature:" | awk '{printf "%.1f°C", $2/10}')

echo "=========================================="
echo "          RINGKASAN STATUS AKHIR          "
echo "=========================================="
if [ "$HOTSPOT_ACTIVE" = true ]; then
    echo " Hotspot     : [AKTIF]"
    echo " IP Gateway  : ${AP_IP:-192.168.43.1}"
else
    echo " Hotspot     : [NONAKTIF]"
fi
echo " Layar       : ${WAKEFULNESS:-Unknown}"
echo " Baterai     : ${BATTERY_LEVEL:-Unknown}% (${BATTERY_TEMP:-Unknown})"
echo "=========================================="

if [ "$HOTSPOT_ACTIVE" = true ]; then
    echo "[✓] Verifikasi berhasil: Hotspot beroperasi normal."
    exit 0
else
    echo "[ERROR] Hotspot tidak dalam keadaan aktif!" >&2
    exit 1
fi
