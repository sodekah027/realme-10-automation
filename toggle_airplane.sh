#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# Jalankan ulang sebagai root bila belum root.
# toggle_airplane.sh
# Fungsi: Menyalakan dan mematikan Mode Pesawat (Airplane Mode)
#         secara otomatis untuk refresh koneksi dan ganti IP seluler.
# Target: Realme 10 (RMX3630)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "sh '$0' \"\$@\""
fi

echo "--- Menjalankan: toggle_airplane.sh ---"

# Fungsi membaca status mode pesawat
get_airplane_status() {
    cmd connectivity airplane-mode 2>/dev/null
}

case "$1" in
    on|enable)
        echo "[*] Mengaktifkan Mode Pesawat..."
        cmd connectivity airplane-mode enable
        sleep 1.0
        echo "[✓] Status Mode Pesawat: $(get_airplane_status)"
        exit 0
        ;;
    off|disable)
        echo "[*] Menonaktifkan Mode Pesawat..."
        cmd connectivity airplane-mode disable
        sleep 1.0
        echo "[✓] Status Mode Pesawat: $(get_airplane_status)"
        exit 0
        ;;
esac

# Default alur: Refresh IP (ON -> Tunggu 3 detik -> OFF)
echo "[i] Status Mode Pesawat awal: $(get_airplane_status)"
echo "[1/3] Mengaktifkan Mode Pesawat (memutuskan jaringan)..."
cmd connectivity airplane-mode enable

echo "[2/3] Menunggu 3 detik..."
sleep 3.0

echo "[3/3] Menonaktifkan Mode Pesawat (menghubungkan kembali)..."
cmd connectivity airplane-mode disable

echo "[*] Menunggu pemulihan sinyal seluler (3 detik)..."
sleep 3.0

FINAL_STATUS=$(get_airplane_status)
if [ "$FINAL_STATUS" = "disabled" ]; then
    echo "[✓] BERHASIL: Mode Pesawat telah di-refresh (koneksi pulih)."
    exit 0
else
    echo "[ERROR] Mode Pesawat masih dalam status: $FINAL_STATUS" >&2
    exit 1
fi
