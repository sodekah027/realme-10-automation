# realme-10-automation
Kumpulan script otomatisasi modular untuk Realme 10 (RMX3630).

Setiap script dibuat terpisah sesuai fungsinya masing-masing sehingga mudah diuji coba atau diperbaiki secara independen jika terjadi kendala.

---

## Struktur File Script

| Nama Script | Fungsi Utama |
| :--- | :--- |
| **`main.sh`** | Runner pengontrol utama dengan **Menu Interaktif** [0-8]. |
| **`unlock_screen.sh`** | Mengecek kondisi daya layar (mati/menyala/terkunci), menekan tombol Power jika mati, dan memasukkan PIN `900000` jika layar terkunci. |
| **`lock_screen.sh`** | Mengecek status layar. Jika menyala, menekan tombol Power untuk mematikan/mengunci layar kembali agar baterai hemat. |
| **`enable_hotspot.sh`** | Memeriksa status hotspot, membuka menu pengaturan Hotspot Pribadi Realme UI, dan mengaktifkan toggle switch hingga terdeteksi aktif. |
| **`disable_hotspot.sh`** | Memeriksa status hotspot, membuka menu pengaturan Hotspot Pribadi Realme UI, dan mematikan switch hingga nonaktif. |
| **`toggle_airplane.sh`** | Mengaktifkan dan menonaktifkan Mode Pesawat secara otomatis (jeda 3 detik) untuk merefresh jaringan & mengganti IP seluler. |
| **`combo_airplane_hotspot.sh`** | **Combo 2-in-1**: Refresh IP seluler via Mode Pesawat (ON -> OFF), memastikan layar terbuka, lalu menyalakan kembali Hotspot Pribadi dan memverifikasi status akhir. |
| **`check_status.sh`** | Memeriksa dan menampilkan laporan status akhir (Hotspot, IP Gateway, kondisi layar, dan level baterai). |

---

## Kebutuhan Sistem
- **Perangkat**: Realme 10 (RMX3630 - 1080x2400)
- **Akses**: Root (KernelSU / Magisk)
- **Environment**: Termux

---

## Cara Penggunaan

Masuk ke direktori repository:
```bash
cd ~/realme-10-automation
```

### 1. Menu Interaktif (`main.sh`)
Cukup jalankan:
```bash
./main.sh
```
Akan tampil menu interaktif:
```text
==========================================================
             OTOMASI REALME 10 - MENU UTAMA               
==========================================================
  [1] Buka Kunci Layar PIN 900000     (unlock_screen.sh)
  [2] Kunci / Matikan Layar           (lock_screen.sh)
  [3] Nyalakan Hotspot Pribadi        (enable_hotspot.sh)
  [4] Matikan Hotspot Pribadi         (disable_hotspot.sh)
  [5] Toggle Mode Pesawat / Ganti IP  (toggle_airplane.sh)
  [6] Combo: Refresh IP + Hotspot ON  (combo_airplane_hotspot.sh)
  [7] Cek Status Perangkat & Jaringan (check_status.sh)
  [8] Jalankan Otomasi Penuh          (Unlock -> Hotspot -> Lock)
  [0] Keluar
==========================================================
Pilih menu [0-8]: 
```

### 2. Menjalankan Langsung via Argumen atau Script Terpisah
Jika ingin menjalankan modul secara mandiri tanpa menu interaktif:
```bash
# Menjalankan modul individual:
./unlock_screen.sh
./lock_screen.sh
./enable_hotspot.sh
./disable_hotspot.sh
./toggle_airplane.sh
./combo_airplane_hotspot.sh
./check_status.sh

# Atau lewat argumen main.sh:
./main.sh 1    # Buka Kunci Layar
./main.sh 2    # Kunci / Matikan Layar
./main.sh 3    # Nyalakan Hotspot
./main.sh 4    # Matikan Hotspot
./main.sh 5    # Toggle Mode Pesawat (Ganti IP)
./main.sh 6    # Combo: Refresh IP + Hotspot ON
./main.sh 7    # Cek Status
./main.sh 8    # Jalankan Semua Alur (Unlock -> Hotspot -> Lock)
```
