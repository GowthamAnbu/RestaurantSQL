DELIMITER $$
DROP PROCEDURE IF EXISTS `insert_food_items`$$
CREATE PROCEDURE `insert_food_items`(lid INT,lfood_id TINYINT,lquantity INT)
BEGIN
INSERT INTO ORDER_FOOD_MAINTENANCE (ORDER_ID,FOOD_ID,QUANTITY,TOTAL_PRICE)
VALUES (lid,lfood_id,lquantity,(SELECT PRICE*lquantity FROM SEED_FOOD WHERE ID=lfood_id));
END$$
DELIMITER ;