#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# Jalankan ulang sebagai root bila belum root.
# unlock_screen.sh
# Fungsi: Cek kondisi layar, tekan tombol Power jika mati,
#         dan masukkan PIN 900000 jika layar terkunci.
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "sh '$0' \"\$@\""
fi

echo "--- [1/3] Menjalankan: unlock_screen.sh ---"

# Cek status daya layar
WAKEFULNESS=$(dumpsys power 2>/dev/null | grep -o "mWakefulness=[a-zA-Z]*" | head -n 1 | cut -d= -f2)
echo "[i] Status Layar: ${WAKEFULNESS:-Unknown}"

if [ "$WAKEFULNESS" = "Asleep" ] || [ "$WAKEFULNESS" = "Dozing" ]; then
    echo "[*] Layar mati/tidur. Menekan tombol Power..."
    input keyevent 26
    sleep 1.2
fi

# Cek apakah layar sedang terkunci
is_locked() {
    local keyguard
    keyguard=$(dumpsys window policy 2>/dev/null | grep -A 5 "KeyguardStateMonitor" | grep -o "mIsShowing=[a-zA-Z]*" | head -n 1 | cut -d= -f2)
    local locked
    locked=$(dumpsys trust 2>/dev/null | grep -o "deviceLocked=[0-9]*" | head -n 1 | cut -d= -f2)

    [ "$keyguard" = "true" ] || [ "$locked" = "1" ]
}

if is_locked; then
    echo "[*] Layar terkunci. Mengusap ke atas (swipe to unlock)..."
    input swipe 540 1800 540 600 250
    sleep 0.6

    echo "[*] Memasukkan PIN 900000..."
    input keyevent 16 # 9
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 1.0

    # Verifikasi apakah kunci berhasil terbuka
    if is_locked; then
        echo "[ERROR] Layar masih terkunci! Periksa kembali PIN Anda." >&2
        exit 1
    fi
    echo "[✓] Berhasil membuka kunci layar."
else
    echo "[✓] Layar sudah menyala dan tidak terkunci."
fi

exit 0
