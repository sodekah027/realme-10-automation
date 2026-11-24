#!/bin/bash
# ==========================================================
# main.sh
# Runner utama untuk otomatisasi Realme 10.
# Menjalankan modul secara berurutan:
#   1. unlock_screen.sh
#   2. enable_hotspot.sh
#   3. check_status.sh
# Jika terjadi error pada salah satu script, eksekusi akan
# berhenti dan menampilkan pesan error dari script terkait.
# ==========================================================

# Pastikan izin root di awal
if [ "$(id -u)" -ne 0 ]; then
    echo "[*] Meminta izin root..."
    exec su -c "$0" "$@"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_script() {
    local script_name="$1"
    local script_desc="$2"
    local script_path="$DIR/$script_name"

    if [ ! -f "$script_path" ]; then
        echo "[ERROR] File $script_name tidak ditemukan di $DIR!" >&2
        return 1
    fi

    echo ""
    echo "=========================================================="
    echo " Memproses: $script_name ($script_desc)"
    echo "=========================================================="
    
    bash "$script_path"
    local exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo ""
        echo "[GAGAL] Error terdeteksi pada: $script_name (Exit Code: $exit_code)" >&2
        echo "Silakan periksa atau perbaiki $script_name." >&2
        return $exit_code
    fi

    echo "[SUKSES] $script_name selesai tanpa error."
    return 0
}

# Dukungan argumen jika ingin menjalankan modul tertentu saja
case "$1" in
    unlock|screen)
        run_script "unlock_screen.sh" "Cek Layar & Buka Kunci PIN"
        exit $?
        ;;
    hotspot)
        run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
        exit $?
        ;;
    status|check)
        run_script "check_status.sh" "Cek Status Jaringan & Perangkat"
        exit $?
        ;;
    help|--help|-h)
        echo "Penggunaan:"
        echo "  ./main.sh          # Menjalankan semua modul (Unlock -> Hotspot -> Status)"
        echo "  ./main.sh unlock   # Hanya jalankan unlock_screen.sh"
        echo "  ./main.sh hotspot  # Hanya jalankan enable_hotspot.sh"
        echo "  ./main.sh status   # Hanya jalankan check_status.sh"
        exit 0
        ;;
esac

echo "=========================================================="
echo "          OTOMASI REALME 10 - EKSEKUSI PENUH              "
echo "=========================================================="

# 1. Buka Kunci Layar
run_script "unlock_screen.sh" "Cek Layar & Buka Kunci PIN" || exit 1

sleep 1.0

# 2. Nyalakan Hotspot
run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi" || exit 1

sleep 1.0

# 3. Verifikasi Status Akhir
run_script "check_status.sh" "Cek Status Jaringan & Perangkat" || exit 1

echo ""
echo "=========================================================="
echo "[SELESAI] Seluruh tahapan otomasi sukses dijalankan!"
echo "=========================================================="
