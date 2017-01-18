DELIMITER $$
DROP FUNCTION IF EXISTS `isfood_available`$$
CREATE FUNCTION `isfood_available`(lfood_id TINYINT)
RETURNS BOOLEAN
BEGIN
DECLARE result BOOLEAN DEFAULT FALSE;
DECLARE stocks_sold INT DEFAULT 0;
/* adding the quantity based on foodid into local variable */
SELECT SUM(ORDER_FOOD_MAINTENANCE.QUANTITY) INTO stocks_sold FROM ORDER_FOOD_MAINTENANCE 
JOIN ORDERS
ON ORDER_FOOD_MAINTENANCE.ORDER_ID=ORDERS.ID
WHERE FOOD_ID=lfood_id AND DATE(ORDERS.ORDER_TIME)=CURRENT_DATE AND ORDERS.STATUS<>'Cancelled' AND ORDER_FOOD_MAINTENANCE.STATUS<>'Cancelled'
GROUP BY(FOOD_ID);
/* checking whether the stock is available */
IF ((SELECT QUANTITY FROM FOOD_SESSION_MAINTENANCE WHERE FOOD_ID=lfood_id
AND SESSION_ID IN(SELECT ID FROM SEED_SESSION WHERE START_TIME<=CURRENT_TIME AND END_TIME>=CURRENT_TIME)
)>stocks_sold)THEN
SET result=TRUE;
END IF;
RETURN result;
END$$
DELIMITER ;