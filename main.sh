#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# main.sh
# Runner utama dengan Menu Interaktif untuk Realme 10
# ==========================================================

# Pastikan izin root di awal
if [ "$(id -u)" -ne 0 ]; then
    echo "[*] Meminta izin root..."
    exec su -c "sh '$0' $*"
fi

DIR="$(cd "$(dirname "$0")" && pwd)"

# Fungsi untuk mengeksekusi script individual
run_script() {
    local script_name="$1"
    local script_desc="$2"
    local script_path="$DIR/$script_name"

    if [ ! -f "$script_path" ]; then
        echo ""
        echo "[ERROR] File $script_name tidak ditemukan di: $DIR" >&2
        return 1
    fi

    echo ""
    echo "=========================================================="
    echo " [EKSEKUSI] $script_desc ($script_name)"
    echo "=========================================================="
    
    sh "$script_path"
    local exit_code=$?

    echo ""
    if [ $exit_code -ne 0 ]; then
        echo "----------------------------------------------------------"
        echo "[GAGAL] Terjadi error pada: $script_name (Kode: $exit_code)" >&2
        echo "Silakan periksa dan perbaiki file '$script_name'." >&2
        echo "----------------------------------------------------------"
        return $exit_code
    else
        echo "----------------------------------------------------------"
        echo "[SUKSES] $script_name selesai tanpa error."
        echo "----------------------------------------------------------"
        return 0
    fi
}

# Fungsi untuk menjalankan semua alur secara berurutan
run_all() {
    echo ""
    echo "=========================================================="
    echo "       MENJALANKAN SEMUA OTOMASI BERURUTAN (1 -> 2 -> 3)  "
    echo "=========================================================="

    run_script "unlock_screen.sh" "Buka Kunci Layar (PIN 90000)"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada unlock_screen.sh." >&2
        return 1
    fi

    sleep 1.0

    run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada enable_hotspot.sh." >&2
        return 1
    fi

    sleep 1.0

    run_script "check_status.sh" "Verifikasi Status Akhir"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada check_status.sh." >&2
        return 1
    fi

    echo ""
    echo "[✓] SELURUH TAHAPAN OTOMASI BERHASIL DIJALANKAN!"
}

# Fungsi menampilkan menu interaktif
show_menu() {
    echo ""
    echo "=========================================================="
    echo "             OTOMASI REALME 10 - MENU UTAMA               "
    echo "=========================================================="
    echo "  [1] Buka Kunci Layar PIN 90000     (unlock_screen.sh)"
    echo "  [2] Nyalakan Hotspot Pribadi       (enable_hotspot.sh)"
    echo "  [3] Cek Status Perangkat & Jaringan(check_status.sh)"
    echo "  [4] Jalankan Semua Alur Sekaligus  (1 -> 2 -> 3)"
    echo "  [0] Keluar"
    echo "=========================================================="
    printf "Pilih menu [0-4]: "
}

# Eksekusi langsung jika menggunakan argumen CLI
if [ -n "$1" ]; then
    case "$1" in
        1|unlock)
            run_script "unlock_screen.sh" "Buka Kunci Layar (PIN 90000)"
            exit $?
            ;;
        2|hotspot)
            run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
            exit $?
            ;;
        3|status)
            run_script "check_status.sh" "Cek Status Perangkat & Jaringan"
            exit $?
            ;;
        4|all)
            run_all
            exit $?
            ;;
        *)
            echo "Penggunaan: ./main.sh [1|2|3|4] atau jalankan tanpa argumen untuk menu interaktif."
            exit 1
            ;;
    esac
fi

# Loop menu interaktif
while true; do
    show_menu
    if ! read -r pilihan; then
        echo ""
        exit 0
    fi

    case "$pilihan" in
        1)
            run_script "unlock_screen.sh" "Buka Kunci Layar (PIN 90000)"
            ;;
        2)
            run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
            ;;
        3)
            run_script "check_status.sh" "Cek Status Perangkat & Jaringan"
            ;;
        4)
            run_all
            ;;
        0|q|Q)
            echo ""
            echo "Keluar."
            exit 0
            ;;
        *)
            echo ""
            echo "[!] Pilihan tidak valid. Silakan pilih 0 sampai 4."
            ;;
    esac

    echo ""
    printf "Tekan [Enter] untuk kembali ke menu..."
    read -r dummy || exit 0
done
