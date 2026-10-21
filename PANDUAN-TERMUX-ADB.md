# Panduan Termux + ADB

Menyiapkan Termux dan [termux-adb](https://github.com/nohajc/termux-adb) di HP Android untuk menjalankan ADB/fastboot melalui USB OTG, tanpa root.

> **Catatan:** panduan ini memakai repository [termux-adb-setup](https://github.com/nrr24id-cmd/termux-adb-setup) ini sendiri (adaptasi dari proyek pihak ketiga [nohajc/termux-adb](https://github.com/nohajc/termux-adb)). Periksa script sebelum menjalankannya dan gunakan hanya pada perangkat yang kamu miliki atau yang memang kamu berwenang kelola.

*Dokumen langkah demi langkah • diperbarui 22 Oktober 2026*

## 1. Persiapan

### Perangkat yang diperlukan

- HP Android host yang mendukung USB OTG/USB Host.
- Termux dan aplikasi Termux:API yang kompatibel, idealnya dipasang dari sumber yang sama (misalnya F-Droid).
- Kabel data yang mendukung OTG (bukan kabel charge-only) dan adaptor yang sesuai.

### Hal yang perlu dipahami

- HP host tidak perlu root untuk menjalankan ADB, tetapi tidak semua HP mendukung USB Host/OTG dengan baik.
- Status `device` pada ADB berarti koneksi dan otorisasi berhasil; `unauthorized` berarti persetujuan debugging belum diberikan di perangkat target.

## 2. Instal Termux di HP host

1. Pasang Termux dari sumber tepercaya. Hindari menggabungkan instalasi Termux dan plugin dari sumber tanda tangan yang berbeda.
2. Jika diperlukan akses USB, pasang Termux:API yang kompatibel dari sumber yang sama.
3. Buka Termux dan jalankan:

   ```sh
   pkg update && pkg upgrade
   ```

   Jika diminta konfirmasi, baca pertanyaannya lalu setujui bila sesuai. Koneksi internet diperlukan untuk mengunduh paket; data seluler tidak wajib jika tersedia Wi-Fi.

## 3. Instal ADB untuk Termux

> **Cara cepat (direkomendasikan):** langkah 2 dan 3 di panduan ini sudah digabung jadi satu script otomatis, dihosting penuh di repo ini (tidak lagi mengunduh script lain dari pihak ketiga saat dijalankan): [`install-termux-adb.sh`](install-termux-adb.sh).
>
> ```sh
> curl -fL https://raw.githubusercontent.com/nrr24id-cmd/termux-adb-setup/main/install-termux-adb.sh -o install-termux-adb.sh
> bash install-termux-adb.sh
> ```
>
> Langkah manual A–C di bawah tetap didokumentasikan untuk yang mau paham/jalankan satu per satu.

### A. Pasang dependensi

```sh
pkg install curl coreutils gnupg wget
```

### B. Tambahkan repo apt termux-adb + GPG key

```sh
mkdir -p $PREFIX/etc/apt/sources.list.d
echo "deb https://nohajc.github.io termux extras" > $PREFIX/etc/apt/sources.list.d/termux-adb.list
wget -qP $PREFIX/etc/apt/trusted.gpg.d https://nohajc.github.io/nohajc.gpg
pkg update
```

> Perintah di atas adalah isi installer [nohajc/termux-adb](https://github.com/nohajc/termux-adb) yang sudah ditinjau dan dituliskan langsung di sini/di `install-termux-adb.sh`, bukan di-curl dari URL luar lagi. Catatan: paket biner `termux-adb`/`termux-fastboot` sendiri tetap dipublikasikan dari apt repo upstream-nya (`nohajc.github.io`) — itu memang sumber resmi paket tersebut, sama seperti instal `curl` yang menarik dari mirror paket Termux sendiri.

### C. Instal paketnya

```sh
pkg install termux-adb
```

Uji perintah:

```sh
termux-adb version
termux-fastboot --version
```

Jika muncul pesan `command not found`, catat pesan lengkapnya. Jangan langsung menambahkan perintah alternatif yang belum diverifikasi.

## 4. Periksa koneksi ADB

Sambungkan perangkat Android target ke HP host via USB OTG, aktifkan USB debugging di perangkat target (Settings → About → ketuk Build number 7x → Developer options → USB debugging), lalu jalankan pada Termux HP host:

```sh
termux-adb devices
```

Contoh hasil yang diharapkan:

```
List of devices attached
XXXXXXXXXXXX    device
```

Jika statusnya `unauthorized`, buka layar perangkat target dan setujui dialog RSA "Allow USB debugging?" jika muncul, lalu ulangi perintah.

## 5. Troubleshooting

| Gejala | Yang diperiksa |
|---|---|
| Perintah ADB tidak ditemukan | Pastikan installer selesai; tutup dan buka ulang Termux; cek pesan error instalasi. |
| Daftar devices kosong | Periksa OTG/USB Host, kabel data (bukan kabel charge-only), adaptor, izin USB, dan apakah perangkat target mengizinkan USB debugging. |
| Status `unauthorized` | Buka layar perangkat target dan setujui dialog RSA USB debugging jika muncul. Cabut-pasang kabel lalu ulangi. |

## 6. Checklist sebelum selesai

- [ ] Termux terpasang dan paket diperbarui.
- [ ] Installer ADB sudah ditinjau (hosting sendiri di repo ini).
- [ ] `termux-adb version` menampilkan versi.
- [ ] Perangkat target terdeteksi dengan status `device`.

## Referensi

- Termux: [F-Droid](https://f-droid.org/packages/com.termux/)
- Termux:API: [F-Droid](https://f-droid.org/packages/com.termux.api/)
- Script setup di repo ini: [nrr24id-cmd/termux-adb-setup](https://github.com/nrr24id-cmd/termux-adb-setup)
- Upstream apt repo paket termux-adb: [nohajc/termux-adb](https://github.com/nohajc/termux-adb)

---

Panduan ini merupakan petunjuk umum Termux + ADB. Langkah-langkah untuk perangkat atau organisasi tertentu (mis. provisioning MDM) ada di dokumentasi internal terpisah, bukan di repo publik ini.
