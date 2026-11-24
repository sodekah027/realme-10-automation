#!/bin/bash
# ==========================================================
# main.sh
# Runner utama dengan Menu Interaktif untuk Realme 10
# ==========================================================

# Pastikan izin root di awal
if [ "$(id -u)" -ne 0 ]; then
    echo "[*] Meminta izin root..."
    exec su -c "$0" "$@"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fungsi untuk mengeksekusi script individual dan mengecek statusnya
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
    
    bash "$script_path"
    local exit_code=$?

    echo ""
    if [ $exit_code -ne 0 ]; then
        echo "----------------------------------------------------------"
        echo "[GAGAL] Terjadi error pada: $script_name (Kode: $exit_code)" >&2
        echo "Silakan perbaiki file '$script_name' untuk mengatasi kendala." >&2
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
    clear
    echo "=========================================================="
    echo "             OTOMASI REALME 10 - MENU UTAMA               "
    echo "=========================================================="
    echo "  [1] Buka Kunci Layar PIN 90000     (unlock_screen.sh)"
    echo "  [2] Nyalakan Hotspot Pribadi       (enable_hotspot.sh)"
    echo "  [3] Cek Status Perangkat & Jaringan(check_status.sh)"
    echo "  [4] Jalankan Semua Alur Sekaligus  (1 -> 2 -> 3)"
    echo "  [0] Keluar"
    echo "=========================================================="
    echo -n "Pilih menu [0-4]: "
}

# Jika ada argumen CLI (misal: ./main.sh 1 atau ./main.sh all)
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

# Loop menu interaktif saat dijalankan tanpa argumen
while true; do
    show_menu
    read -r pilihan
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
            echo "Sampai jumpa!"
            exit 0
            ;;
        *)
            echo ""
            echo "[!] Pilihan tidak valid. Silakan pilih 0 sampai 4."
            ;;
    esac

    echo ""
    read -r -p "Tekan [Enter] untuk kembali ke menu..." dummy
done
