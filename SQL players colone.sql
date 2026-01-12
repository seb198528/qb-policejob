ALTER TABLE `players`
ADD COLUMN `drivingpoints` INT(11) DEFAULT 12 AFTER `charinfo`,
ADD COLUMN `licenseloss` INT(11) DEFAULT 0 AFTER `drivingpoints`;