#!/bin/bash
# ==========================================================
# enable_hotspot.sh
# Fungsi: Cek status hotspot, buka menu Hotspot Realme UI,
#         dan aktifkan toggle switch hotspot pribadi.
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "$0" "$@"
fi

echo "--- [2/3] Menjalankan: enable_hotspot.sh ---"

# Fungsi cek status hotspot aktif
is_hotspot_on() {
    ip link show ap0 2>/dev/null | grep -q "state UP" || cmd wifi status 2>/dev/null | grep -q "SoftApManager"
}

if is_hotspot_on; then
    echo "[✓] Hotspot pribadi sudah AKTIF sebelumnya. Tidak ada perubahan yang dilakukan."
    exit 0
fi

echo "[*] Hotspot masih nonaktif. Membuka pengaturan Hotspot Realme UI..."

# Buka halaman pengaturan Hotspot Pribadi Realme UI
am start -n com.oplus.wirelesssettings/com.android.settings.Settings\$WifiApSettingsActivity >/dev/null 2>&1 || \
am start -n com.android.settings/.TetherSettings >/dev/null 2>&1

sleep 1.2

# Tekan switch toggle Hotspot (koordinat X=927, Y=522 untuk layar 1080x2400)
echo "[*] Menekan tombol toggle switch Hotspot..."
input tap 927 522
sleep 1.5

# Kembali ke layar utama (Home)
input keyevent 3
sleep 1.0

# Verifikasi status aktivasi
if is_hotspot_on; then
    echo "[✓] Berhasil: Hotspot pribadi kini AKTIF."
    exit 0
else
    echo "[!] Percobaan pertama belum aktif, mencoba metode fallback (TetherSettings)..."
    am start -n com.android.settings/.TetherSettings >/dev/null 2>&1
    sleep 1.0
    input keyevent 20 # DPAD DOWN
    sleep 0.3
    input keyevent 66 # ENTER
    sleep 1.2
    input keyevent 3  # HOME

    if is_hotspot_on; then
        echo "[✓] Berhasil: Hotspot aktif via fallback."
        exit 0
    else
        echo "[ERROR] Gagal mengaktifkan Hotspot pribadi!" >&2
        exit 1
    fi
fi
