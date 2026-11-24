# realme-10-automation
Kumpulan script otomatisasi modular untuk Realme 10 (RMX3630).

Setiap script dibuat terpisah sesuai fungsinya masing-masing sehingga mudah diuji coba atau diperbaiki secara independen jika terjadi kendala.

---

## Struktur File Script

| Nama Script | Fungsi Utama |
| :--- | :--- |
| **`unlock_screen.sh`** | Mengecek kondisi daya layar (mati/menyala/terkunci), menekan tombol Power jika mati, dan memasukkan PIN `90000` jika layar terkunci. |
| **`enable_hotspot.sh`** | Memeriksa status hotspot, membuka menu pengaturan Hotspot Pribadi Realme UI, dan mengaktifkan toggle switch. |
| **`check_status.sh`** | Memeriksa dan menampilkan laporan status akhir (Hotspot, IP Gateway, kondisi layar, dan level baterai). |
| **`main.sh`** | Runner pengontrol utama yang mengeksekusi script secara berurutan (`unlock_screen.sh` -> `enable_hotspot.sh` -> `check_status.sh`). Jika terjadi error di salah satu script, eksekusi akan langsung berhenti dengan notifikasi yang jelas. |

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

### 1. Menjalankan Seluruh Otomasi Sekaligus:
```bash
./main.sh
```

### 2. Menjalankan atau Menguji Modul Tertentu Saja:
```bash
# Hanya membuka kunci layar:
./unlock_screen.sh
# Atau lewat main:
./main.sh unlock

# Hanya menyalakan hotspot:
./enable_hotspot.sh
# Atau lewat main:
./main.sh hotspot

# Hanya mengecek status akhir:
./check_status.sh
# Atau lewat main:
./main.sh status
```
