select name from person_corporation where person_id in (select client_id from clients);
select owner_id, sum(area) from (select owner_id, area from owns, properties where owns.property_number =  properties.property_number) as owner_area group by owner_id;
select name, viewing_date.property_number from viewing_date, (select employe_id, name, property_number from associate, person_corporation where associate.employe_id = person_corporation.person_id) as assos where viewing_date.property_number = assos.property_number and date_ >= 20201200 and date_ < 20201300;
select  property_number, count(property_number) as amount_viewed from viewing_date where date_ >= 20200000 and date_ < 20210000 group by property_number order by amount_viewed desc;
select owner_id, name, sum(rent) as total_rent from (select owns.owner_id,  person_corporation.name, owns.property_number,  lease_rent.rent from person_corporation, owns , (select rent, property_number from lease) lease_rent where owns.property_number = lease_rent.property_number and owns.owner_id = person_corporation.person_id) as full_list group by owner_id;
select supervisor.subordinate_id, person_corporation.name from person_corporation, supervisor where supervisor_id in (select person_id from person_corporation where name = "Ulises Huerta") and supervisor.subordinate_id = person_corporation.person_id;
select person_corporation.name from person_corporation, owns, properties, address where person_corporation.person_id = owns.owner_id and owns.property_number = properties.property_number and properties.property_type = "residential" and properties.address_id = address.address_id and address.city in (select address.city from person_corporation, owns, properties, address  where person_corporation.person_id = owns.owner_id and owns.property_number = properties.property_number and person_corporation.name = "Pat Doe" and properties.address_id = address.address_id and properties.property_type = "commercial");
select partner.employe_id, person_corporation.name, count(lease.property_number) as lesed_property from partner, owns, lease, owner, person_corporation where partner.employe_id = owner.partner_id and owns.owner_id = owner.owner_id and owns.property_number = lease.property_number and person_corporation.person_id = partner.employe_id group by employe_id order by lesed_property desc limit 3;

# this is a view that lists what each property owes in the last 3 month
drop view if exists fees;
CREATE VIEW fees AS
select property_number, (fee * months) as total_fee from
(select lease.property_number, ((lease.rent * properties.management_fee) / 100) as fee, 
case 
when lease.start_date >= 20201200 and lease.end_date >= 20201200 then 1  
when lease.start_date >= 20201100 and lease.end_date >= 20201200 then 2 
else 3
end as months
from lease, properties 
where lease.property_number = properties.property_number 
and lease.end_date >= 20201000) as full_data;

# this is a function that returns the total amount 0f fees in the last 3 month
DROP FUNCTION IF EXISTS fee_amount;
CREATE FUNCTION fee_amount()
  RETURNS INTEGER
  CONTAINS SQL READS SQL DATA
BEGIN
  DECLARE amount INTEGER; -- local variable within the body of the stored function/procedure
  SELECT sum(total_fee) INTO amount
  FROM fees
  RETURN d_count;
END;

# this makes a triger for when a new lease is added
DROP TRIGGER IF EXISTS lease_ad;

CREATE TRIGGER lease_ad 
    AFTER INSERT on lease
FOR EACH ROW
BEGIN 
  UPDATE properties
     SET ads = 1
  where properties.property_number = lease.property_number;
END;