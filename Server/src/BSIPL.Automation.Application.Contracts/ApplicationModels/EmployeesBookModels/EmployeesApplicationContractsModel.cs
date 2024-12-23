namespace BSIPL.Automation.ApplicationModels.EmployeesBookModels
{
    public class EmployeesApplicationContractsModel
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string ProfilePictureUrl { get; set; }
        public byte[] ByteProfilePicture { get; set; }
        public string Designation { get; set; }
        public string EmailId { get; set; }
        public int ProjectId { get; set; }
        public string Interest { get; set; }
        public int RowNum { get; set; }
    }
}