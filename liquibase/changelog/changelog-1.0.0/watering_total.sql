SELECT *
FROM crosstab(
  $$
  SELECT
    wd.watering_date_id
    ,wd.watering_date
    ,wz.zone_name
    ,wa.watering_amount
  FROM
    watering.watering_date wd
  INNER JOIN
    watering.watering_amount wa ON wd.watering_date_id = wa.watering_date_id
  INNER JOIN
    watering.watering_zone wz ON wz.watering_zone_id = wa.watering_zone_id
  ORDER BY
    wd.watering_date_id, wz.zone_name
  $$,
  $$ VALUES ('front'), ('back'), ('side') $$
) AS pivot_table (
  watering_date_id INT
  ,watering_date DATE
  ,front DECIMAL(5,3)
  ,back DECIMAL(5,3)
  ,side DECIMAL(5,3)
);