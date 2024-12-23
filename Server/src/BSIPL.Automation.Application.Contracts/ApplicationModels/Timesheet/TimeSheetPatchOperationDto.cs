using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimeSheetPatchOperationDto
    {
        public int EntryId { get; set; }
        public int EmpId { get; set; }
    }
    public class TimeSheetPatchOperationModelDto
    {
        public List<TimeSheetPatchOperationDto> TimeSheetEntries { get; set; }
        public string Remarks { get; set; }
    }
    public class RoleHierarchy
    {
        public string RoleName { get; set; }
        public List<string> DefaultRoles { get; set; } = new List<string>();
    }
}
