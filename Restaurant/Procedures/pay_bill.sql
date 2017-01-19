DELIMITER $$
DROP PROCEDURE IF EXISTS `pay_bill`$$
CREATE PROCEDURE `pay_bill`(IN lseat_number TINYINT,OUT result text)
BEGIN
/* 1 checking whether the seat number is valid
 * 1.1 checking whether the seat number is active
 * 1.1.1 checking whether the seat number ordered food
 * 1.1.2 checking whether the order has already been paid 
 * 1.1.3 checking whether the order has been cancelled 
 * 1.2 no items ordered*/
IF (isseat_number(lseat_number)) THEN
	IF (isseat_number_active(lseat_number)) THEN
		IF (EXISTS(SELECT ID FROM ORDERS WHERE SEAT_NUMBER=lseat_number AND STATUS='Ordered')) THEN
		START TRANSACTION;
		SET autocommit=0;
			UPDATE ORDERS SET STATUS='Paid' WHERE SEAT_NUMBER=lseat_number AND STATUS='Ordered';
			UPDATE ORDER_FOOD_MAINTENANCE
			INNER JOIN ORDERS
			ON ORDER_FOOD_MAINTENANCE.ORDER_ID=ORDERS.ID
			SET ORDER_FOOD_MAINTENANCE.STATUS='Paid'
			WHERE ORDERS.SEAT_NUMBER=lseat_number 
			AND ORDERS.STATUS='Paid' 
			AND ORDER_FOOD_MAINTENANCE.STATUS='Ordered';
			UPDATE SEED_SEAT SET ACTIVE=0 WHERE SEAT_NUMBER=lseat_number;
		COMMIT;
		ELSEIF (EXISTS(SELECT ID FROM ORDERS WHERE SEAT_NUMBER=lseat_number AND STATUS='Paid')) THEN
		SET result="Bill has already been paid";
		ELSEIF (EXISTS(SELECT ID FROM ORDERS WHERE SEAT_NUMBER=lseat_number AND STATUS='Cancelled')) THEN
		SET result="Order has been cancelled";
		ELSE
		SET result="No items purchased for this seat number";
		END IF;
	ELSE
	SET result="NO ITEMS ORDERED";
	END IF;
ELSE
SET result="INVALID SEAT NUMBER";
END IF;
END$$
DELIMITER ;