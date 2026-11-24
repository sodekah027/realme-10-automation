# realme-10-automation
Kumpulan script otomatisasi modular untuk Realme 10 (RMX3630).

Setiap script dibuat terpisah sesuai fungsinya masing-masing sehingga mudah diuji coba atau diperbaiki secara independen jika terjadi kendala.

---

## Struktur File Script

| Nama Script | Fungsi Utama |
| :--- | :--- |
| **`main.sh`** | Runner pengontrol utama dengan **Menu Interaktif**. Pengguna dapat memilih menu untuk menjalankan script tertentu atau seluruh rangkaian otomasi. |
| **`unlock_screen.sh`** | Mengecek kondisi daya layar (mati/menyala/terkunci), menekan tombol Power jika mati, dan memasukkan PIN `900000` jika layar terkunci. |
| **`enable_hotspot.sh`** | Memeriksa status hotspot, membuka menu pengaturan Hotspot Pribadi Realme UI, dan mengaktifkan toggle switch hingga terdeteksi aktif. |
| **`disable_hotspot.sh`** | Memeriksa status hotspot, membuka menu pengaturan Hotspot Pribadi Realme UI, dan mematikan switch hingga nonaktif. |
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
  [2] Nyalakan Hotspot Pribadi        (enable_hotspot.sh)
  [3] Matikan Hotspot Pribadi         (disable_hotspot.sh)
  [4] Cek Status Perangkat & Jaringan (check_status.sh)
  [5] Jalankan Otomasi Penuh          (1 -> 2 -> 4)
  [0] Keluar
==========================================================
Pilih menu [0-5]: 
```

### 2. Menjalankan Langsung via Argumen atau Script Terpisah
Jika ingin menjalankan modul secara mandiri tanpa menu interaktif:
```bash
# Menjalankan modul individual:
./unlock_screen.sh
./enable_hotspot.sh
./disable_hotspot.sh
./check_status.sh

# Atau lewat argumen main.sh:
./main.sh 1    # Buka Kunci
./main.sh 2    # Nyalakan Hotspot
./main.sh 3    # Matikan Hotspot
./main.sh 4    # Cek Status
./main.sh 5    # Jalankan Semua Alur
```
