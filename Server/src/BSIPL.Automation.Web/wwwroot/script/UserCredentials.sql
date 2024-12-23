CREATE TABLE UserCredentials (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    EmailId VARCHAR(255) UNIQUE NOT NULL,
    Name VARCHAR(255) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

GO
CREATE TRIGGER SetUpdatedAt
ON UserCredentials
AFTER UPDATE
AS
BEGIN
    UPDATE UserCredentials
    SET UpdatedAt = GETDATE()
    WHERE UserId IN (SELECT DISTINCT UserId FROM Inserted);
END;
--------------------------------------------------------------------------------
GO
CREATE OR ALTER PROCEDURE usp_insertUserRegistrationDetail --'a@gmail.com', 'abc234','hjdgweh'
@EmailId VARCHAR(200),
@UserName VARCHAR(200),
@Password VARCHAR(200)

AS
	BEGIN
		INSERT INTO UserCredentials(Name, EmailId, PasswordHash)
		VALUES(@UserName, @EmailId, @Password)
END
------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER PROCEDURE usp_getUserDetailsByEmailId --'a@gmail.com'
@EmailId VARCHAR(200)
AS
	BEGIN
		SELECT EmailId, Name, PasswordHash FROM UserCredentials
		WHERE EmailId = @EmailId
	END
