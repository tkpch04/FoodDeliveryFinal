class RegistrasiGagal {
  late final String message;

  RegistrasiGagal([this.message = "Pendaftaran gagal"]);

  factory RegistrasiGagal.code(String code) {
    switch (code) {
      case "weak-password":
        return RegistrasiGagal('Masukkan Password yang kuat');
      case "invalid-email":
        return RegistrasiGagal('Email salah');
      case "email-already-use":
        return RegistrasiGagal('Email sudah digunakan');
      default:
        // Jika tidak ada kode yang sesuai, kembalikan objek RegistrasiGagal dengan pesan default
        return RegistrasiGagal();
    }
  }
}
