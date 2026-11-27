#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# Jalankan ulang sebagai root bila belum root.
# disable_hotspot.sh
# Fungsi: Cek status hotspot, navigasi ke menu Hotspot Pribadi
#         Realme UI, matikan switch toggle, tunggu hingga nonaktif,
#         dan kembali ke layar utama.
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "sh '$0' \"\$@\""
fi

echo "--- Menjalankan: disable_hotspot.sh ---"

# Fungsi cek status hotspot aktif
is_hotspot_on() {
    if ip link show ap0 2>/dev/null | grep -q "state UP" || dumpsys tethering 2>/dev/null | grep -q "ap0 - TetheredState"; then
        return 0
    else
        return 1
    fi
}

# 1. Periksa apakah hotspot sudah nonaktif
if ! is_hotspot_on; then
    echo "[✓] Hotspot pribadi sudah NONAKTIF sebelumnya. Tidak ada perubahan yang dilakukan."
    exit 0
fi

echo "[*] Hotspot saat ini aktif. Membuka pengaturan Penambatan (Tethering)..."

# Tutup instance wirelesssettings lama untuk mencegah fragment kosong
am force-stop com.oplus.wirelesssettings >/dev/null 2>&1
sleep 0.3

# Buka halaman Tether Settings
am start -a android.settings.TETHER_SETTINGS >/dev/null 2>&1
sleep 1.2

# Tekan menu 'Hotspot pribadi' (baris pertama: koordinat X=540, Y=416)
echo "[*] Membuka sub-menu Hotspot pribadi..."
input tap 540 416
sleep 1.2

# Tekan switch toggle Hotspot untuk mematikan (koordinat X=927, Y=522)
echo "[*] Menekan tombol switch untuk mematikan Hotspot..."
input tap 927 522

echo "[*] Menunggu proses pematian Hotspot (hingga 8 detik)..."
HOTSPOT_STOPPED=false
for i in $(seq 1 8); do
    sleep 1
    if ! is_hotspot_on; then
        HOTSPOT_STOPPED=true
        echo "[+] Hotspot terdeteksi NONAKTIF pada detik ke-$i!"
        break
    fi
    echo "[...] Menunggu pematian ($i detik)..."
done

# Kembali ke layar utama (Home)
input keyevent 3
sleep 0.5

# 2. Verifikasi status akhir
if [ "$HOTSPOT_STOPPED" = true ] || ! is_hotspot_on; then
    echo "[✓] BERHASIL: Hotspot pribadi kini NONAKTIF."
    exit 0
else
    echo "[ERROR] Gagal mematikan Hotspot pribadi! Periksa layar perangkat." >&2
    exit 1
fi
