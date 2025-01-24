SELECT
  t.customer_name,
  p.product_id,
  p.product_name,  -- Nama obat
  p.price AS actual_price,  -- Harga obat
  t.discount_percentage,
  -- Menghitung harga setelah diskon (nett_sales)
  p.price - (p.price * t.discount_percentage / 100) AS nett_sales,
  -- Menentukan persentase laba berdasarkan harga produk (persentase_gross_laba)
  CASE
    WHEN p.price <= 50000 THEN 10
    WHEN p.price > 50000 AND p.price <= 100000 THEN 15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 25
    ELSE 30
  END AS persentase_gross_laba,
  -- Menghitung keuntungan bersih (nett_profit)
  (p.price - (p.price * t.discount_percentage / 100)) *
  CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.3
  END AS nett_profit,
  kc.rating AS rating_cabang,  -- Penilaian konsumen terhadap cabang Kimia Farma
  t.rating AS rating_transaksi,  -- Penilaian konsumen terhadap transaksi
  t.date,  -- Tanggal transaksi
  kc.kota,  -- Kota lokasi cabang
  kc.provinsi,  -- Provinsi lokasi cabang
  kc.branch_name, -- Nama cabang
  t.transaction_id,
  COUNT(t.transaction_id) OVER (PARTITION BY t.customer_name) AS total_transaction -- Jumlah total transaksi per customer
FROM
  `crypto-minutia-447907-d6.rakamin.final_transaction` t  -- Tabel transaksi
JOIN
  `crypto-minutia-447907-d6.rakamin.product` p ON t.product_id = p.product_id  -- Tabel produk
JOIN
  `crypto-minutia-447907-d6.rakamin.kantor_cabang` kc ON t.branch_id = kc.branch_id;  -- Tabel kantor cabang
