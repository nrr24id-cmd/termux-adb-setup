# Panduan Termux + ADB ke SUNMI / DualPOS

Menjalankan ADB dari HP Android tanpa root menggunakan USB OTG.

**Tujuan:** menggunakan HP Android sebagai pengganti laptop Windows untuk menghubungkan ke perangkat SUNMI/DualPOS, memasang APK MDM Agent, dan — jika memenuhi syarat — menetapkan aplikasi sebagai Device Owner.

> **Catatan:** panduan ini memakai repository [termux-adb](https://github.com/nohajc/termux-adb) pihak ketiga. Periksa script sebelum menjalankannya dan gunakan hanya pada perangkat yang kamu miliki atau yang memang kamu berwenang kelola.

## Alur singkat

| | | |
|---|---|---|
| **HP host**<br>Termux + ADB | → USB OTG/data → | **SUNMI target**<br>USB debugging |
| APK MDM Agent tersimpan di HP host | → instal via ADB → | Periksa aplikasi & provisioning |

*Dokumen langkah demi langkah • diperbarui 21 Oktober 2026*

## 1. Persiapan dan batasan

### Perangkat yang diperlukan

- HP Android host yang mendukung USB OTG/USB Host.
- Termux dan aplikasi Termux:API yang kompatibel, idealnya dipasang dari sumber yang sama (misalnya F-Droid).
- SUNMI/DualPOS target, kabel data yang mendukung OTG, dan adaptor yang sesuai.
- File APK yang benar, misalnya `hmdm-6.26-master.apk`, diperoleh dari sumber resmi/organisasi.

### Hal yang perlu dipahami

- HP host tidak perlu root untuk menjalankan ADB, tetapi tidak semua HP mendukung USB Host/OTG dengan baik.
- Pada SUNMI, USB debugging mungkin dibatasi oleh kebijakan perusahaan atau firmware.
- Status `device` pada ADB berarti koneksi dan otorisasi berhasil; `unauthorized` berarti persetujuan debugging belum diberikan.
- Perintah Device Owner dapat gagal jika SUNMI sudah melalui setup/pemakaian. Jangan factory reset tanpa persetujuan dan rencana pemulihan data.

## 2. Instal Termux di HP host

1. Pasang Termux dari sumber tepercaya. Hindari menggabungkan instalasi Termux dan plugin dari sumber tanda tangan yang berbeda.
2. Jika diperlukan akses USB, pasang Termux:API yang kompatibel dari sumber yang sama.
3. Buka Termux dan jalankan:

   ```sh
   pkg update && pkg upgrade
   ```

   Jika diminta konfirmasi, baca pertanyaannya lalu setujui bila sesuai. Koneksi internet diperlukan untuk mengunduh paket; data seluler tidak wajib jika tersedia Wi-Fi.

## 3. Instal ADB untuk Termux

Repository yang digunakan dalam panduan ini: [github.com/nohajc/termux-adb](https://github.com/nohajc/termux-adb). Script internet dapat berubah. Periksa isinya sebelum menjalankan.

> **Cara cepat:** langkah 2 dan 3 di panduan ini sudah digabung jadi satu script otomatis di repo ini: [`install-termux-adb.sh`](install-termux-adb.sh). Lihat [README](README.md) untuk cara pakainya. Langkah manual di bawah tetap berguna untuk memahami/meninjau apa yang dijalankan script tersebut, atau kalau mau jalankan satu per satu.

### A. Pasang curl

```sh
pkg install curl
```

### B. Unduh script tanpa langsung mengeksekusinya

```sh
curl -fL https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh -o install.sh
cat install.sh
```

> Baca isi script. Jika tidak memahami perintah di dalamnya, jangan lanjutkan; minta bantuan admin IT untuk meninjau.

### C. Jalankan installer setelah ditinjau

```sh
bash install.sh
```

Jika installer selesai, uji perintah:

```sh
termux-adb version
termux-fastboot --version
```

Jika muncul pesan `command not found`, catat pesan lengkapnya. Jangan langsung menambahkan perintah alternatif yang belum diverifikasi.

## 4. Aktifkan USB debugging di SUNMI

Langkah menu berbeda menurut model SUNMI dan versi Android. Jika perangkat dikelola perusahaan, ikuti prosedur admin IT.

1. Buka Settings/Pengaturan di SUNMI.
2. Buka About device/Tentang perangkat, lalu cari Build number/Nomor bentukan. Pada banyak perangkat, mengetuknya tujuh kali mengaktifkan Developer options/Opsi pengembang.
3. Buka Developer options dan aktifkan USB debugging jika tersedia.
4. Sambungkan SUNMI ke HP host menggunakan kabel data dan adaptor OTG yang tepat.
5. Jika muncul permintaan akses USB di HP host, izinkan. Jika SUNMI menampilkan dialog RSA "Allow USB debugging?", periksa perangkat host dan setujui hanya jika dipercaya.

## 5. Periksa koneksi ADB

Jalankan pada Termux HP host:

```sh
termux-adb devices
```

Contoh hasil yang diharapkan:

```
List of devices attached
XXXXXXXXXXXX    device
```

Jika statusnya `unauthorized`, buka layar SUNMI dan setujui dialog debugging jika tersedia, lalu ulangi perintah. Jika daftar kosong, lanjutkan ke bagian [Troubleshooting](#9-troubleshooting).

## 6. Siapkan APK MDM Agent

Pindahkan APK resmi yang diberikan organisasi ke folder Download di HP host. Jangan menggunakan APK dari sumber tidak dikenal.

```sh
termux-setup-storage
ls ~/storage/downloads/
```

Pastikan nama file sama persis. Contoh di bawah mengasumsikan nama file `hmdm-6.26-master.apk`.

## 7. Instal APK ke SUNMI

```sh
termux-adb install -r ~/storage/downloads/hmdm-6.26-master.apk
```

Hasil `Success` berarti APK berhasil dipasang. Ini belum berarti enrollment selesai atau aplikasi sudah menjadi Device Owner.

### Verifikasi informasi perangkat (opsional)

```sh
termux-adb shell getprop ro.build.version.release
termux-adb shell getprop ro.product.manufacturer
termux-adb shell getprop ro.product.model
```

## 8. Device Owner — langkah sensitif

Panduan awal menggunakan perintah:

```sh
termux-adb shell dpm set-device-owner com.hmdm.launcher/.AdminReceiver
```

> **Jangan jalankan perintah ini secara membabi buta.** Perintah hanya sesuai jika nama paket dan komponen AdminReceiver benar untuk APK tersebut, perangkat memenuhi persyaratan provisioning Android, dan kamu memiliki otorisasi untuk mendaftarkan SUNMI ke MDM organisasi. Pada banyak versi Android, penetapan Device Owner hanya dapat dilakukan saat perangkat masih dalam keadaan provisioning yang memenuhi syarat. Jika perintah gagal, simpan pesan error dan hubungi admin IT/vendor MDM; jangan langsung melakukan reset pabrik.

Jika berhasil, lanjutkan enrollment Headwind POS sesuai SOP organisasi dan verifikasi status MDM Agent pada SUNMI. Jangan menganggap instalasi APK saja sudah menyelesaikan enrollment.

## 9. Troubleshooting

| Gejala | Yang diperiksa |
|---|---|
| Perintah ADB tidak ditemukan | Pastikan installer selesai; tutup dan buka ulang Termux; cek pesan error instalasi. |
| Daftar devices kosong | Periksa OTG/USB Host, kabel data (bukan kabel charge-only), adaptor, izin USB, dan apakah SUNMI mengizinkan USB debugging. |
| Status `unauthorized` | Buka layar SUNMI dan setujui dialog RSA USB debugging jika muncul. Cabut-pasang kabel lalu ulangi. |
| APK tidak ditemukan | Jalankan `ls ~/storage/downloads/` dan gunakan nama file yang persis; pastikan `termux-setup-storage` sudah dijalankan. |
| `INSTALL_FAILED_*` | Catat pesan lengkap. Bisa terkait versi Android, arsitektur, tanda tangan APK, kebijakan perangkat, atau versi aplikasi. |
| `set-device-owner` gagal | Periksa pesan error, nama paket/receiver, status provisioning, akun/pengguna yang sudah dikonfigurasi, serta kebijakan SUNMI. Jangan reset tanpa persetujuan. |

## 10. Checklist sebelum selesai

- [ ] Termux terpasang dan paket diperbarui.
- [ ] Installer ADB diperiksa sebelum dijalankan.
- [ ] `termux-adb version` menampilkan versi.
- [ ] SUNMI terdeteksi dengan status `device`.
- [ ] APK MDM Agent berasal dari sumber resmi dan berhasil diinstal.
- [ ] Komponen Device Owner sudah diverifikasi oleh admin/vendor.
- [ ] Enrollment Headwind POS selesai sesuai SOP dan statusnya sudah dicek.

## Referensi

- Termux: [F-Droid](https://f-droid.org/packages/com.termux/)
- Termux:API: [F-Droid](https://f-droid.org/packages/com.termux.api/)
- Installer ADB: [github.com/nohajc/termux-adb](https://github.com/nohajc/termux-adb)
- Dokumentasi Android Device Policy / Device Owner: [developer.android.com/work/dpc/provisioning](https://developer.android.com/work/dpc/provisioning)

---

Panduan ini merupakan petunjuk umum. Model SUNMI, versi Android, kebijakan perusahaan, dan versi APK dapat mengubah langkah yang diperlukan.
