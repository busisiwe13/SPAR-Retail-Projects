SELECT
  DATE(tOrders.created_at) date_utc_offset,
  tOrders.id,
  tOrders.status,
  tOrders.place_id,
  tStores.name store_name,
  tStores.distribution_centre dc,
  tStores.chain.name store_type,
  tOrders.price.captured_price.total_price,
  product.picking_status,
  product.collected_product.gtin,
  tProducts.name product_name,
  LOWER(tProducts.brand) product_brand,
  tProducts.categories[OFFSET((SELECT OFFSET FROM UNNEST(categories) cat WITH OFFSET WHERE cat.tree_name = "SPAR" AND cat.level = 1))].name category_level_1,
  tProducts.categories[OFFSET((SELECT OFFSET FROM UNNEST(categories) cat WITH OFFSET WHERE cat.tree_name = "SPAR" AND cat.level = 2))].name category_level_2,
  product.collected_product.quantity,
  (product.collected_product.row_price_vat / (1 + (product.collected_product.vat_percentage / 100))) row_price_vat,
  product.collected_product.vat_percentage,

FROM `naveo_api_dataset.naveo_order_data_min` tOrders,
UNNEST(products) product

LEFT JOIN `naveo_api_dataset.naveo_store_list_min` tStores ON tStores.master_id = tOrders.place_id
LEFT JOIN `naveo_api_dataset.naveo_products` tProducts ON CAST(tProducts.gtin AS INT64) = product.collected_product.gtin

WHERE
  DATE(tOrders.created_at, "Africa/Johannesburg") BETWEEN PARSE_DATE("%Y%m%d", "20241001") AND PARSE_DATE("%Y%m%d", "20250930")