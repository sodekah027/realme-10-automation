#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# combo_airplane_hotspot.sh
# Fungsi: Combo otomatis untuk refresh jaringan/IP seluler
#         (Mode Pesawat ON -> OFF) lalu menyalakan Hotspot
#         pribadi kembali dan memeriksa status akhir.
# Target: Realme 10 (RMX3630)
# ==========================================================

# Pastikan izin root
if [ "$(id -u)" -ne 0 ]; then
    exec su -c "sh '$0' $*"
fi

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================================="
echo "   COMBO: REFRESH IP (AIRPLANE MODE) -> NYALAKAN HOTSPOT  "
echo "=========================================================="

# 1. Toggle Mode Pesawat (Refresh IP)
echo ""
echo "[Langkah 1/4] Merefresh Jaringan Seluler (Toggle Mode Pesawat)..."
sh "$DIR/toggle_airplane.sh"
if [ $? -ne 0 ]; then
    echo "[ERROR] Gagal melakukan toggle mode pesawat!" >&2
    exit 1
fi

sleep 1.0

# 2. Cek & Buka Kunci Layar jika diperlukan
echo ""
echo "[Langkah 2/4] Memastikan Layar Menyala & Terbuka..."
sh "$DIR/unlock_screen.sh"
if [ $? -ne 0 ]; then
    echo "[ERROR] Gagal membuka kunci layar!" >&2
    exit 1
fi

sleep 1.0

# 3. Nyalakan Hotspot Pribadi
echo ""
echo "[Langkah 3/4] Menyalakan Hotspot Pribadi..."
sh "$DIR/enable_hotspot.sh"
if [ $? -ne 0 ]; then
    echo "[ERROR] Gagal menyalakan hotspot pribadi!" >&2
    exit 1
fi

sleep 1.0

# 4. Verifikasi Status Akhir
echo ""
echo "[Langkah 4/4] Memeriksa Status Akhir Jaringan..."
sh "$DIR/check_status.sh"
if [ $? -ne 0 ]; then
    echo "[ERROR] Verifikasi status akhir gagal!" >&2
    exit 1
fi

echo ""
echo "=========================================================="
echo "[✓] SUKSES: Jaringan di-refresh & Hotspot telah AKTIF kembali!"
echo "=========================================================="
