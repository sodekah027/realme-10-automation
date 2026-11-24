# realme-10-automation
Automation scripts and tools for Realme 10 (RMX3630).

## Daftar Script

### 1. `script1.sh`
- **Fungsi**: Menekan tombol Power, mengusap layar ke atas (swipe to unlock), dan memasukkan angka `90000` (PIN).
- **Resolusi Target**: 1080x2400 (Realme 10 4G).
- **Kebutuhan**: Root (KernelSU / Magisk).

#### Cara Menjalankan:
```bash
# Dari direktori repo
bash script1.sh
# Atau
./script1.sh
```

### 2. `script2.sh`
- **Fungsi**:
  1. Cek kondisi layar terlebih dahulu (apakah mati/sleep, menyala tapi terkunci, atau sudah menyala & terbuka).
  2. Membuka kunci otomatis dengan PIN `90000` hanya jika layar terkunci.
  3. Cek status hotspot: jika sudah aktif, tidak perlu dinyalakan lagi.
  4. Menyalakan Hotspot Pribadi Realme UI dan kembali ke homescreen.
- **Resolusi Target**: 1080x2400 (Realme 10 4G).
- **Kebutuhan**: Root (KernelSU / Magisk).

#### Cara Menjalankan:
```bash
bash script2.sh
# Atau
./script2.sh
```
