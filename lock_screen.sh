#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# lock_screen.sh
# Fungsi: Cek status layar. Jika menyala, tekan tombol Power
#         untuk mengunci/mematikan layar (menghemat baterai).
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "sh '$0' $*"
fi

echo "--- Menjalankan: lock_screen.sh ---"

# Cek kondisi daya layar
WAKEFULNESS=$(dumpsys power 2>/dev/null | grep -o "mWakefulness=[a-zA-Z]*" | head -n 1 | cut -d= -f2)
echo "[i] Status Layar Saat Ini: ${WAKEFULNESS:-Unknown}"

if [ "$WAKEFULNESS" = "Awake" ]; then
    echo "[*] Layar terdeteksi MENYALA. Menekan tombol Power untuk mematikan..."
    input keyevent 26
    sleep 0.8

    # Verifikasi status setelah tombol power ditekan
    NEW_STATUS=$(dumpsys power 2>/dev/null | grep -o "mWakefulness=[a-zA-Z]*" | head -n 1 | cut -d= -f2)
    if [ "$NEW_STATUS" = "Asleep" ] || [ "$NEW_STATUS" = "Dozing" ]; then
        echo "[✓] BERHASIL: Layar telah dimatikan dan terkunci."
        exit 0
    else
        echo "[!] Peringatan: Layar masih terdeteksi $NEW_STATUS." >&2
        exit 1
    fi
else
    echo "[✓] Layar sudah dalam kondisi MATI / SLEEP sebelumnya."
    exit 0
fi
