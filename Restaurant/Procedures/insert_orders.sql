DELIMITER $$
DROP PROCEDURE IF EXISTS `insert_orders`$$
CREATE PROCEDURE `insert_orders`(IN lseat_number TINYINT,OUT lid INT)
BEGIN
		INSERT INTO ORDERS (SEAT_NUMBER) VALUES (lseat_number);
		SET lid=LAST_INSERT_ID();	
END$$
DELIMITER ;