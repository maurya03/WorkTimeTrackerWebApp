namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EmployeeScoreModel
    {
        public int Id { get; set; }
        public string BhavnaEmployeeId { get; set; }
        public int SubcategoryId { get; set; }
        public int EmployeeScore { get; set; }
    }
    public class EmployeeSkillScoreModel
    {
        public string EmployeeName { get; set; }
        public string BhavnaEmployeeId { get; set; }
        public int SubCategoryId { get; set; }
        public int EmployeeScore { get; set; }
        public int MappingId { get; set; }
    }

}
