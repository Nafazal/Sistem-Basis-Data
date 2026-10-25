CREATE DATABASE perpustakaan_its;

-- \c perpustakaan_its

-- BAGIAN 2: pembuatan tabel

CREATE TABLE penerbit (
    id          INT PRIMARY KEY,
    nama        VARCHAR(100) NOT NULL,
    kota        VARCHAR(100) NOT NULL,
    no_telepon  VARCHAR(13)  NOT NULL
);

CREATE TABLE penulis (
    id          INT PRIMARY KEY,
    nama        VARCHAR(100) NOT NULL,
    negara_asal VARCHAR(100) NOT NULL
);

CREATE TABLE petugas (
    id          INT PRIMARY KEY,
    nama        VARCHAR(100) NOT NULL,
    jabatan     VARCHAR(100) NOT NULL,
    no_telepon  VARCHAR(13)  NOT NULL
);

CREATE TABLE anggota (
    no_anggota     CHAR(10) PRIMARY KEY,
    nama           VARCHAR(100) NOT NULL,
    tanggal_lahir  DATE         NOT NULL,
    alamat         VARCHAR(100) NOT NULL,
    no_telepon     VARCHAR(13)  NOT NULL,
    jenis_kelamin  CHAR(1)      NOT NULL,
    status_anggota VARCHAR(50)  NOT NULL
);

CREATE TABLE buku (
    id             CHAR(6) PRIMARY KEY,
    isbn           CHAR(13)     NOT NULL,
    judul          VARCHAR(100) NOT NULL,
    tahun_terbit   CHAR(4)      NOT NULL,
    jumlah_halaman INT          NOT NULL,
    stok           INT          NOT NULL,
    penerbit_id    INT          NOT NULL,
    CONSTRAINT fk_buku_penerbit FOREIGN KEY (penerbit_id)
        REFERENCES penerbit(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE buku_penulis (
    buku_id    CHAR(6) NOT NULL,
    penulis_id INT     NOT NULL,
    PRIMARY KEY (buku_id, penulis_id),
    CONSTRAINT fk_bp_buku FOREIGN KEY (buku_id)
        REFERENCES buku(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_bp_penulis FOREIGN KEY (penulis_id)
        REFERENCES penulis(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE peminjaman (
    id                  CHAR(6) PRIMARY KEY,
    waktu_pinjam        TIMESTAMP   NOT NULL,
    tanggal_jatuh_tempo DATE        NOT NULL,
    tanggal_kembali     DATE,                    -- bertanda N di PDM, boleh NULL
    status_peminjaman   VARCHAR(50) NOT NULL,
    anggota_no_anggota  CHAR(10)    NOT NULL,
    buku_id             CHAR(6)     NOT NULL,
    petugas_id          INT         NOT NULL,
    CONSTRAINT fk_pinjam_anggota FOREIGN KEY (anggota_no_anggota)
        REFERENCES anggota(no_anggota)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pinjam_buku FOREIGN KEY (buku_id)
        REFERENCES buku(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pinjam_petugas FOREIGN KEY (petugas_id)
        REFERENCES petugas(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE denda (
    id            CHAR(6) PRIMARY KEY,
    jumlah        INT         NOT NULL,
    jenis_denda   VARCHAR(50) NOT NULL,
    status_bayar  VARCHAR(50) NOT NULL,
    peminjaman_id CHAR(6)     NOT NULL UNIQUE,
    CONSTRAINT fk_denda_peminjaman FOREIGN KEY (peminjaman_id)
        REFERENCES peminjaman(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-- ---------------------------------------------------------------------
-- Soal 2 : Memasukkan data awal
-- (negara_asal masih diisi karena baru dihapus di soal 5)
-- ---------------------------------------------------------------------

INSERT INTO penerbit (id, nama, kota, no_telepon) VALUES
(1, 'Gramedia Pustaka Utama', 'Jakarta',    '0215551001'),
(2, 'Bentang Pustaka',        'Yogyakarta', '0274555002'),
(3, 'Informatika Bandung',    'Bandung',    '0225555003'),
(4, 'Lentera Dipantara',      'Jakarta',    '0215555004');

INSERT INTO penulis (id, nama, negara_asal) VALUES
(1, 'Andrea Hirata',         'Indonesia'),
(2, 'Pramoedya Ananta Toer', 'Indonesia'),
(3, 'Tere Liye',             'Indonesia'),
(4, 'Rinaldi Munir',         'Indonesia'),
(5, 'Leoni Lidya',           'Indonesia');

INSERT INTO buku (id, isbn, judul, tahun_terbit, jumlah_halaman, stok, penerbit_id) VALUES
('BK0001', '9786021000014', 'Laskar Pelangi',            '2005', 529, 5, 2),
('BK0002', '9786021000021', 'Bumi Manusia',              '2005', 535, 3, 4),
('BK0003', '9786021000038', 'Bumi',                      '2014', 440, 4, 1),
('BK0004', '9786021000045', 'Algoritma dan Pemrograman', '2016', 458, 6, 3),
('BK0005', '9786021000052', 'Sang Pemimpi',              '2006', 292, 2, 2);

INSERT INTO buku_penulis (buku_id, penulis_id) VALUES
('BK0001', 1),
('BK0002', 2),
('BK0003', 3),
('BK0004', 4),
('BK0004', 5),
('BK0005', 1);

INSERT INTO anggota (no_anggota, nama, tanggal_lahir, alamat, no_telepon, jenis_kelamin, status_anggota) VALUES
('5026231001', 'Rani Putri',     '2004-03-15', 'Jl. Keputih Tegal No. 12, Surabaya',  '081234567801', 'P', 'Aktif'),
('5026231002', 'Budi Santoso',   '2003-11-02', 'Jl. Gubeng Pojok No. 5, Surabaya',    '081234567802', 'L', 'Aktif'),
('5026231003', 'Dewi Anggraini', '2004-07-21', 'Jl. Dharmahusada No. 20, Surabaya',   '081234567803', 'P', 'Aktif'),
('5026231004', 'Ahmad Fauzi',    '2002-12-09', 'Jl. Mulyorejo No. 3, Surabaya',       '081234567804', 'L', 'Nonaktif'),
('5026231005', 'Siti Rahmawati', '2003-05-28', 'Jl. Ngagel Jaya No. 8, Surabaya',     '081234567805', 'P', 'Aktif');

INSERT INTO petugas (id, nama, jabatan, no_telepon) VALUES
(1, 'Hendra Wijaya',     'Pustakawan',     '081345678901'),
(2, 'Lestari Wulandari', 'Staf Sirkulasi', '081345678902'),
(3, 'Bambang Pratama',   'Staf Katalog',   '081345678903');

INSERT INTO peminjaman (id, waktu_pinjam, tanggal_jatuh_tempo, tanggal_kembali, status_peminjaman, anggota_no_anggota, buku_id, petugas_id) VALUES
('PJ0001', '2026-09-14 09:00:00', '2026-09-21', '2026-09-20', 'Dikembalikan', '5026231001', 'BK0001', 1),
('PJ0002', '2026-09-15 10:30:00', '2026-09-22', NULL,         'Terlambat',    '5026231002', 'BK0002', 2),
('PJ0003', '2026-09-20 13:15:00', '2026-09-27', '2026-09-29', 'Dikembalikan', '5026231003', 'BK0003', 1),
('PJ0004', '2026-10-08 09:00:00', '2026-10-15', NULL,         'Dipinjam',     '5026231001', 'BK0005', 3),
('PJ0005', '2026-10-10 11:00:00', '2026-10-17', NULL,         'Dipinjam',     '5026231005', 'BK0004', 1),
('PJ0006', '2026-09-25 14:20:00', '2026-10-02', NULL,         'Terlambat',    '5026231003', 'BK0004', 2);


-- ---------------------------------------------------------------------
-- Soal 3 : Menambah kolom email dan poin_keaktifan pada tabel anggota
-- ---------------------------------------------------------------------

ALTER TABLE anggota
    ADD COLUMN email VARCHAR(100),
    ADD COLUMN poin_keaktifan INT DEFAULT 0;


-- ---------------------------------------------------------------------
-- Soal 4 : Mengubah tipe data no_telepon pada tabel penerbit
-- ---------------------------------------------------------------------

ALTER TABLE penerbit
    ALTER COLUMN no_telepon TYPE VARCHAR(20);


-- ---------------------------------------------------------------------
-- Soal 5 : Menghapus kolom negara_asal dari tabel penulis
-- ---------------------------------------------------------------------

ALTER TABLE penulis
    DROP COLUMN negara_asal;


-- ---------------------------------------------------------------------
-- Soal 6 : Constraint UNIQUE pada kolom isbn tabel buku
-- ---------------------------------------------------------------------

ALTER TABLE buku
    ADD CONSTRAINT uq_buku_isbn UNIQUE (isbn);


-- =====================================================================
-- DML (kerjakan berurutan 7 s.d. 12)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Soal 7 : Memasukkan data denda
-- ---------------------------------------------------------------------

INSERT INTO denda (id, jumlah, jenis_denda, status_bayar, peminjaman_id) VALUES
('DN0001', 5000, 'Terlambat', 'Belum Lunas', 'PJ0002'),
('DN0002', 2000, 'Terlambat', 'Belum Lunas', 'PJ0003'),
('DN0003', 3000, 'Terlambat', 'Belum Lunas', 'PJ0006');


-- ---------------------------------------------------------------------
-- Soal 8 : PJ0002 (Budi Santoso) dikembalikan pada 2026-10-12
-- ---------------------------------------------------------------------

UPDATE peminjaman
SET tanggal_kembali   = '2026-10-12',
    status_peminjaman = 'Dikembalikan'
WHERE id = 'PJ0002';


-- ---------------------------------------------------------------------
-- Soal 9 : Update nomor telepon Rani Putri (5026231001)
-- ---------------------------------------------------------------------

UPDATE anggota
SET no_telepon = '081223344556'
WHERE no_anggota = '5026231001';


-- ---------------------------------------------------------------------
-- Soal 10 : Denda DN0003 (Dewi Anggraini) sudah dibayar
-- ---------------------------------------------------------------------

UPDATE denda
SET status_bayar = 'Lunas'
WHERE id = 'DN0003';


-- ---------------------------------------------------------------------
-- Soal 11 : Hapus buku BK0005 (Sang Pemimpi) yang hilang
-- Efek cascade: baris (BK0005, 1) di buku_penulis dan PJ0004 di
-- peminjaman ikut terhapus.
-- ---------------------------------------------------------------------

DELETE FROM buku
WHERE id = 'BK0005';


-- ---------------------------------------------------------------------
-- Soal 12 : Hapus seluruh peminjaman berstatus 'Dikembalikan'
-- Efek cascade: DN0001 dan DN0002 di tabel denda ikut terhapus.
-- Hasil akhir: peminjaman tersisa PJ0005 dan PJ0006,
--              denda tersisa DN0003.
-- ---------------------------------------------------------------------

DELETE FROM peminjaman
WHERE status_peminjaman = 'Dikembalikan';
