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

# Fungsi untuk menjalankan alur penuh (Unlock -> Hotspot On -> Status -> Lock)
run_all() {
    echo ""
    echo "=========================================================="
    echo "     MENJALANKAN OTOMASI PENUH (Unlock -> Hotspot -> Lock)"
    echo "=========================================================="

    # 1. Buka Kunci Layar
    run_script "unlock_screen.sh" "Buka Kunci Layar (PIN 900000)"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada unlock_screen.sh." >&2
        return 1
    fi

    sleep 1.0

    # 2. Nyalakan Hotspot
    run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada enable_hotspot.sh." >&2
        return 1
    fi

    sleep 1.0

    # 3. Verifikasi Status Akhir
    run_script "check_status.sh" "Verifikasi Status Akhir"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada check_status.sh." >&2
        return 1
    fi

    sleep 1.0

    # 4. Kunci / Matikan Layar Kembali (menghemat baterai)
    run_script "lock_screen.sh" "Kunci / Matikan Layar"
    if [ $? -ne 0 ]; then
        echo "[STOP] Otomasi dihentikan karena error pada lock_screen.sh." >&2
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
    echo "  [1] Buka Kunci Layar PIN 900000     (unlock_screen.sh)"
    echo "  [2] Kunci / Matikan Layar           (lock_screen.sh)"
    echo "  [3] Nyalakan Hotspot Pribadi        (enable_hotspot.sh)"
    echo "  [4] Matikan Hotspot Pribadi         (disable_hotspot.sh)"
    echo "  [5] Toggle Mode Pesawat / Ganti IP  (toggle_airplane.sh)"
    echo "  [6] Cek Status Perangkat & Jaringan (check_status.sh)"
    echo "  [7] Jalankan Otomasi Penuh          (Unlock -> Hotspot -> Lock)"
    echo "  [0] Keluar"
    echo "=========================================================="
    printf "Pilih menu [0-7]: "
}

# Eksekusi langsung jika menggunakan argumen CLI
if [ -n "$1" ]; then
    case "$1" in
        1|unlock)
            run_script "unlock_screen.sh" "Buka Kunci Layar (PIN 900000)"
            exit $?
            ;;
        2|lock)
            run_script "lock_screen.sh" "Kunci / Matikan Layar"
            exit $?
            ;;
        3|hotspot-on|on)
            run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
            exit $?
            ;;
        4|hotspot-off|off)
            run_script "disable_hotspot.sh" "Matikan Hotspot Pribadi"
            exit $?
            ;;
        5|airplane|ap)
            run_script "toggle_airplane.sh" "Toggle Mode Pesawat / Ganti IP"
            exit $?
            ;;
        6|status)
            run_script "check_status.sh" "Cek Status Perangkat & Jaringan"
            exit $?
            ;;
        7|all)
            run_all
            exit $?
            ;;
        *)
            echo "Penggunaan: ./main.sh [1-7] atau jalankan tanpa argumen untuk menu interaktif."
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
            run_script "unlock_screen.sh" "Buka Kunci Layar (PIN 900000)"
            ;;
        2)
            run_script "lock_screen.sh" "Kunci / Matikan Layar"
            ;;
        3)
            run_script "enable_hotspot.sh" "Nyalakan Hotspot Pribadi"
            ;;
        4)
            run_script "disable_hotspot.sh" "Matikan Hotspot Pribadi"
            ;;
        5)
            run_script "toggle_airplane.sh" "Toggle Mode Pesawat / Ganti IP"
            ;;
        6)
            run_script "check_status.sh" "Cek Status Perangkat & Jaringan"
            ;;
        7)
            run_all
            ;;
        0|q|Q)
            echo ""
            echo "Keluar."
            exit 0
            ;;
        *)
            echo ""
            echo "[!] Pilihan tidak valid. Silakan pilih 0 sampai 7."
            ;;
    esac

    echo ""
    printf "Tekan [Enter] untuk kembali ke menu..."
    read -r dummy || exit 0
done
