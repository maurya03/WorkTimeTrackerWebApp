ALTER TABLE ClientMaster
ADD CreatedBy varchar(100);
 
ALTER TABLE ClientMaster
ADD ModifiedBy varchar(100);

ALTER TABLE SubCategoryMaster
ADD CreatedBy varchar(100);
 
ALTER TABLE SubCategoryMaster
ADD ModifiedBy varchar(100);

ALTER TABLE CategoryMaster
ADD CreatedBy varchar(100);
 
ALTER TABLE CategoryMaster
ADD ModifiedBy varchar(100);

ALTER TABLE TeamMaster
ADD CreatedBy varchar(100);
 
ALTER TABLE TeamMaster
ADD ModifiedBy varchar(100);

ALTER TABLE EmployeeDetails
ADD CreatedBy varchar(100);
 
ALTER TABLE EmployeeDetails
ADD ModifiedBy varchar(100);

ALTER TABLE SubCategoryMapping
ADD CreatedBy varchar(100);
 
ALTER TABLE SubCategoryMapping
ADD ModifiedBy varchar(100);

ALTER TABLE SkillsMatrix
ADD CreatedBy varchar(100);
 
ALTER TABLE SkillsMatrix
ADD ModifiedBy varchar(100);

ALTER TABLE EmployeeRoles
ADD CreatedBy VARCHAR(50);

ALTER TABLE EmployeeRoles
ADD ModifiedBy VARCHAR(50);


