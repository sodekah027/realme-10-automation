#!/bin/bash
# ==========================================================
# Script 1: Tekan Tombol Power & Masukkan Angka 90000
# Target: Realme 10 (RMX3630 - 1080x2400)
# ==========================================================

# Pastikan script dijalankan dengan izin root
if [ "$(id -u)" -ne 0 ]; then
    echo "[*] Meminta izin root..."
    exec su -c "$0" "$@"
fi

echo "[1/3] Menekan tombol Power..."
input keyevent 26
sleep 1.2

echo "[2/3] Menggeser layar ke atas (membuka keypad PIN)..."
# Geser ke atas dari Y=1800 ke Y=600 (layar 1080x2400)
input swipe 540 1800 540 600 250
sleep 0.6

echo "[3/3] Memasukkan angka 90000..."
# Keycode Android: 9 = KEYCODE_9 (16), 0 = KEYCODE_0 (7)
# Menggunakan keyevent per digit agar tidak terlewat oleh lockscreen
input keyevent 16 # 9
sleep 0.15
input keyevent 7  # 0
sleep 0.15
input keyevent 7  # 0
sleep 0.15
input keyevent 7  # 0
sleep 0.15
input keyevent 7  # 0

echo "[✓] Selesai!"
