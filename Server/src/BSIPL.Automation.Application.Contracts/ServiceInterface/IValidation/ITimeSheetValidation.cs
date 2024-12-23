using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.ApplicationModels.Timesheet;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.ServiceInterface.Validation
{
    public interface ITimeSheetValidation : IApplicationService
    {
        IList<ValidationErrorMessage> ValidateTimesheet(TimesheetEmployeeDetailsDtoModel timesheetEmployeeDetails, IList<TimesheetEmployeeDetailsDtoModel> employeeDetails);
        IList<ValidationErrorMessage> ValidateSaveTimesheet(TimesheetDetail hourlyData, IList<TimesheetCategoryDtoModel> timesheetCategories, IList<TimesheetSubCategoryDtoModel> timesheetSubCategories);
        IList<ValidationErrorMessage> ValidateGetTimesheetStatusWise(TimesheetGetDto timesheetDtoObj, IList<ClientMasterApplicationContractsModel> clients);
        IList<ValidationErrorMessage> ValidateGetTimesheetForTImesheetId(int timesheetId);
        IList<ValidationErrorMessage> ValidateGetTimesheetForEmployeeId(string employeeId, IList<TimesheetEmployeeDetailsDtoModel> employeeDetails);
        IList<ValidationErrorMessage> ValidateUpdateTimesheetStatusForApprover(TimesheetUpdateStatusDtoModel timesheetUpdate, IList<TimesheetEmployeeDetailsDtoModel> employeeDetails);
        IList<ValidationErrorMessage> ValidateUpdateTimesheetStatusForEmployee(UpdateTimeSheetDtoModel updateTimeSheet);
        IList<ValidationErrorMessage> ValidateUpdateTimesheetSubCategoryBYCategoryId(int categoryId, IList<TimesheetCategoryDtoModel> categories);
        IList<ValidationErrorMessage> ValidateGetTimesheetEmployeeByProjectId(int projectId);
        Task<IList<ValidationErrorMessage> > ValidateDeleteTimesheetBySubCategoryId(int subCategorId, IList<TimesheetSubCategoryDtoModel> subCategories);
        Task<IList<ValidationErrorMessage>> ValidateCreateTimesheet(CreateTimesheetDtoModel createTimesheetDtoModel);
        Task<IList<ValidationErrorMessage>> ValidateDeleteTimesheetCategory(int Id);

    }
}