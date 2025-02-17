CREATE FUNCTION cant_total_empleados () RETURNS trigger AS $ body $ BEGIN IF TG_OP = 'INSERT' THEN
UPDATE
    area
set
    CantEmp = CantEmp + 1
where
    IdArea = new.AreaT;

RETURN NEW;

END IF;

IF TG_OP = 'UPDATE' THEN
UPDATE
    area
set
    CantEmp = CantEmp - 1
where
    IdArea = old.AreaT;

UPDATE
    area
set
    CantEmp = CantEmp + 1
where
    IdArea = new.AreaT;

RETURN NEW;

END IF;

IF TG_OP = 'DELETE' THEN
UPDATE
    area
set
    CantEmp = CantEmp - 1
where
    IdArea = old.AreaT;

RETURN OLD;

END IF;

END;

$ body $ LANGUAGE 'plpgsql'