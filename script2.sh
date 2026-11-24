#!/bin/bash
# ==========================================================
# Script 2: Cek Kondisi Layar, Buka Kunci (Jika Perlu), & Nyalakan Hotspot
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan script dijalankan dengan izin root
if [ "$(id -u)" -ne 0 ]; then
    echo "[*] Meminta izin root..."
    exec su -c "$0" "$@"
fi

# Fungsi mengecek kondisi daya layar (Awake / Asleep / Dozing)
check_screen_power() {
    dumpsys power 2>/dev/null | grep -o "mWakefulness=[a-zA-Z]*" | head -n 1 | cut -d= -f2
}

# Fungsi mengecek apakah layar sedang terkunci (Keyguard aktif / device locked)
check_is_locked() {
    local keyguard
    keyguard=$(dumpsys window policy 2>/dev/null | grep -A 5 "KeyguardStateMonitor" | grep -o "mIsShowing=[a-zA-Z]*" | head -n 1 | cut -d= -f2)
    local locked
    locked=$(dumpsys trust 2>/dev/null | grep -o "deviceLocked=[0-9]*" | head -n 1 | cut -d= -f2)

    if [ "$keyguard" = "true" ] || [ "$locked" = "1" ]; then
        echo "locked"
    else
        echo "unlocked"
    fi
}

# Fungsi memasukkan PIN 90000
enter_pin() {
    echo "[*] Mengusap layar ke atas (swipe to unlock)..."
    input swipe 540 1800 540 600 250
    sleep 0.6

    echo "[*] Memasukkan PIN 90000..."
    input keyevent 16 # 9
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 0.15
    input keyevent 7  # 0
    sleep 1.0
}

# Fungsi mengecek apakah Hotspot sedang aktif
check_hotspot_status() {
    if ip link show ap0 2>/dev/null | grep -q "state UP" || cmd wifi status 2>/dev/null | grep -q "SoftApManager"; then
        echo "on"
    else
        echo "off"
    fi
}

echo "=========================================="
echo " [1/3] Pengecekan Kondisi Layar & Kunci   "
echo "=========================================="

SCREEN_POWER=$(check_screen_power)
echo "[i] Status Layar: ${SCREEN_POWER:-Unknown}"

if [ "$SCREEN_POWER" = "Asleep" ] || [ "$SCREEN_POWER" = "Dozing" ]; then
    echo "[!] Layar dalam kondisi MATI / SLEEP."
    echo "[*] Menyalakan layar (Power button)..."
    input keyevent 26
    sleep 1.2
    
    # Periksa status kunci setelah layar menyala
    LOCK_STATUS=$(check_is_locked)
    if [ "$LOCK_STATUS" = "locked" ]; then
        echo "[!] Layar terkunci. Membuka kunci dengan PIN..."
        enter_pin
    else
        echo "[✓] Layar menyala dan tidak terkunci."
    fi

elif [ "$SCREEN_POWER" = "Awake" ]; then
    echo "[i] Layar sudah MENYALA."
    LOCK_STATUS=$(check_is_locked)
    if [ "$LOCK_STATUS" = "locked" ]; then
        echo "[!] Layar menyala tetapi MASIH TERKUNCI."
        echo "[*] Membuka kunci dengan PIN..."
        enter_pin
    else
        echo "[✓] Layar menyala dan SUDAH TERBUKA (tidak terkunci)."
    fi
else
    # Fallback jika wakefulness tidak terbaca
    echo "[?] Memastikan layar menyala..."
    input keyevent 224 # KEYCODE_WAKEUP (aman tidak mematikan layar jika sudah on)
    sleep 0.5
fi

echo ""
echo "=========================================="
echo " [2/3] Memeriksa Status Hotspot Saat Ini   "
echo "=========================================="

HOTSPOT_STATUS=$(check_hotspot_status)
if [ "$HOTSPOT_STATUS" = "on" ]; then
    echo "[✓] Hotspot pribadi SUDAH AKTIF. Tidak perlu dinyalakan lagi."
    exit 0
fi

echo "[i] Hotspot saat ini NONAKTIF. Menyalakan..."
echo "=========================================="
echo " [3/3] Menyalakan Hotspot Pribadi          "
echo "=========================================="

# Buka halaman pengaturan Hotspot Pribadi Realme UI
am start -n com.oplus.wirelesssettings/com.android.settings.Settings\$WifiApSettingsActivity >/dev/null 2>&1 || \
am start -n com.android.settings/.TetherSettings >/dev/null 2>&1

sleep 1.2

# Tekan toggle switch Hotspot Pribadi (koordinat X=927, Y=522 untuk Realme 10 1080x2400)
input tap 927 522
sleep 1.5

# Kembali ke layar utama (Home)
input keyevent 3

# Verifikasi status akhir
sleep 1.0
FINAL_STATUS=$(check_hotspot_status)
if [ "$FINAL_STATUS" = "on" ]; then
    echo "[✓] BERHASIL: Hotspot pribadi kini AKTIF!"
else
    echo "[!] Peringatan: Hotspot belum terdeteksi aktif. Mengirim event fallback..."
    # Fallback menggunakan TetherSettings jika belum aktif
    am start -n com.android.settings/.TetherSettings >/dev/null 2>&1
    sleep 1.0
    input keyevent 20 # DPAD DOWN
    sleep 0.3
    input keyevent 66 # ENTER
    sleep 1.0
    input keyevent 3  # HOME
fi

echo "[✓] Selesai!"
