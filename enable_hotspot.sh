#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# Jalankan ulang sebagai root bila belum root.
# enable_hotspot.sh
# Fungsi: Cek status hotspot, navigasi ke menu Hotspot Pribadi
#         Realme UI, aktifkan switch toggle, tunggu hingga aktif,
#         dan kembali ke layar utama.
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    su -c "sh '$0' \"\$@\""
    exit $?
fi

echo "--- [2/3] Menjalankan: enable_hotspot.sh ---"

# Fungsi cek status hotspot aktif
is_hotspot_on() {
    if ip link show ap0 2>/dev/null | grep -q "state UP" || dumpsys tethering 2>/dev/null | grep -q "ap0 - TetheredState"; then
        return 0
    else
        return 1
    fi
}

# 1. Periksa apakah hotspot sudah aktif
if is_hotspot_on; then
    echo "[✓] Hotspot pribadi sudah AKTIF sebelumnya. Tidak ada perubahan yang dilakukan."
    exit 0
fi

echo "[*] Hotspot masih nonaktif. Membuka pengaturan Penambatan (Tethering)..."

# Tutup instance wirelesssettings lama untuk mencegah fragment kosong
am force-stop com.oplus.wirelesssettings >/dev/null 2>&1
sleep 0.3

# Buka halaman Tether Settings
am start -a android.settings.TETHER_SETTINGS >/dev/null 2>&1
sleep 1.2

# Tekan menu 'Hotspot pribadi' (baris pertama di TetherSettings: koordinat X=540, Y=416)
echo "[*] Membuka sub-menu Hotspot pribadi..."
input tap 540 416
sleep 1.2

# Tekan switch toggle Hotspot (koordinat X=927, Y=522 pada layar 1080x2400)
echo "[*] Menekan tombol switch Hotspot pribadi..."
input tap 927 522

echo "[*] Menunggu proses inisialisasi jaringan Hotspot (hingga 8 detik)..."
HOTSPOT_READY=false
for i in $(seq 1 8); do
    sleep 1
    if is_hotspot_on; then
        HOTSPOT_READY=true
        echo "[+] Hotspot terdeteksi AKTIF pada detik ke-$i!"
        break
    fi
    echo "[...] Menunggu aktivasi ($i detik)..."
done

# Kembali ke layar utama (Home)
input keyevent 3
sleep 0.5

# 2. Verifikasi status akhir
if [ "$HOTSPOT_READY" = true ] || is_hotspot_on; then
    echo "[✓] BERHASIL: Hotspot pribadi kini AKTIF."
    exit 0
else
    echo "[ERROR] Hotspot belum berhasil aktif setelah 8 detik! Periksa pengaturan jaringan perangkat." >&2
    exit 1
fi
