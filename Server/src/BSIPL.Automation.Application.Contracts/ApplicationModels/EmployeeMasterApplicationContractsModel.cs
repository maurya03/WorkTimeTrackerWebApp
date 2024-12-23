using System;

namespace BSIPL.Automation.ApplicationModels
{
    public class EmployeeMasterApplicationContractsModel
    {
        public string EmployeeId { get; set; }
        public string EmailId { get; set; }
        public string FullName { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string EmployeeName { get; set; }
        public int ProjectId { get; set; }
        public string Project { get; set; }
        public string AboutYourSelf { get; set; }
        public string HobbiesAndInterests { get; set; }
        public string FavoriteMomentsAtBhavna { get; set; }
        public string FutureAspirations { get; set; }
        public string BiographyTitle { get; set; }
        public string DefineMyself { get; set; }
        public string MyBiggestFlex { get; set; }
        public string FavoriteBingsShow { get; set; }
        public string MyLifeMantra { get; set; }
        public string ProfilePictureUrl { get; set; }
        public DateTime JoiningDate { get; set; }
        public string DateJoining { get; set; }
        public string EmployeeLocation { get; set; }
        public int TeamId { get; set; }
        public string Team { get; set; }
        public string OneThingICanNotLive { get; set; }
        public string WhoInspiresYou { get; set; }
        public string YourBucketList { get; set; }
        public string FavoriteWorkProject { get; set; }
        public string NativePlace { get; set; }
        public decimal? ExperienceYear { get; set; }
        public int DesignationId { get; set; }
        public string Designation { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsEmployeeBookAllowed { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string CreatedById { get; set; }
        public string UpdatedById { get; set; }
        public bool IsActive { get; set; }
        public bool IsSkillMatrixAllowed { get; set; }
        public byte[] ByteProfilePicture { get; set; }
    }
}