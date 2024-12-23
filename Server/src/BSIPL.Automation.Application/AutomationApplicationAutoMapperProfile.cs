using AutoMapper;
using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.SkillsMatrix;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using BSIPL.Automation.Models.EmployeesBookModels;
using BSIPL.Automation.Models.Timesheet;
using BSIPL.Automation.ApplicationModels.Timesheet;
using System.Collections.Generic;
using BSIPL.Automation.TimesheetService;
using BSIPL.Automation.Model;
using BSIPL.Automation.Models.ShareIdeaModels;
using BSIPL.Automation.ApplicationModels.ShareIdeaModels;

namespace BSIPL.Automation;

public class AutomationApplicationAutoMapperProfile : Profile
{
    public AutomationApplicationAutoMapperProfile()
    {
        /* You can configure your AutoMapper mapping configuration here.
         * Alternatively, you can split your mapping configurations
         * into multiple profile classes for a better organization. */
        CreateMap<CategoryMasterModel, CategoryMasterApplicationContractsModel>();
        CreateMap<ClientMasterModel, ClientMasterApplicationContractsModel>();
        CreateMap<SkillsMatrixModel, SkillsMatrixApplicationContractsModel>();
        CreateMap<SubCategoryMasterModel, SubCategoryMasterApplicationContractsModel>();
        CreateMap<TeamMasterModel, TeamMasterApplicationContractsModel>();
        CreateMap<SubCategoryMappingModel, SubCategoryMappingApplicationContractsModel>();
        CreateMap<EmployeeDetailsModel, EmployeeDetailsApplicationContractsModel>();
        CreateMap<EmployeeMasterModel, EmployeeMasterApplicationContractsModel>();
        CreateMap<PostSkillMatrixTableContractsModel, PostSkillMatrixTableModel>();

        CreateMap<CategoryMasterApplicationContractsModel, CategoryMasterModel>();
        CreateMap<ClientMasterApplicationContractsModel, ClientMasterModel>();
        CreateMap<SkillsMatrixApplicationContractsModel, SkillsMatrixModel>();
        CreateMap<SubCategoryMasterApplicationContractsModel, SubCategoryMasterModel>();
        CreateMap<TeamMasterApplicationContractsModel, TeamMasterModel>();
        CreateMap<SubCategoryMappingApplicationContractsModel, SubCategoryMappingModel>();
        CreateMap<EmployeeDetailsApplicationContractsModel, EmployeeDetailsModel>();


        CreateMap<PostSubCategoryMappingApplicationContractsModel, SubCategoryMappingModel>();
        CreateMap<GetSkillsMatrixJoinTablesModel, GetSkillsMatrixJoinTablesApplicationContractsModel>();
        CreateMap<EmployeeSkillMatrixModel, EmployeeSkillScoreModel>();
        CreateMap<GetSkillsMatrixJoinTablesCheckModel, GetSkillsMatrixJoinTablesApplicationContractsModel>();
        CreateMap<GetSkillsMatrixJoinTablesApplicationContractsModel, GetSkillsMatrixJoinTablesModel>();
        CreateMap<EditClientTeamsApplicationContractsModel, EditClientTeamsModel>();
        CreateMap<EditCategorySubcategoryApplicationContractsModel, EditCategorySubcategoryModel>();
        CreateMap<EditTeamEmployeesApplicationContractsModel, EditTeamEmployeesModel>();

        //Designation Mapper
        CreateMap<DesignationsModel, DesignationsApplicationContractsModel>().ReverseMap();

        // Role Mapper
        CreateMap<RolesModel, RolesApplicationContractsModel>();
        CreateMap<EmployeeRolesModel, EmployeeRolesApplicationContractsModel>();
        CreateMap<EmployeeRolesModel, EmployeeRolesApplicationContractsModel>();
        CreateMap<EditTeamEmployeesUpdateApplicationContractsModel, EditTeamEmployeesModelUpdate>();

        //Timesheet
        CreateMap<TimesheetDto, Timesheet>();
        CreateMap<TimesheetDetail, TimesheetEntryItems>();
        CreateMap<TimeSheetListDomainModel, TimeSheetEntryListDtoModel>();
        CreateMap<TimeSheetDetailListDomainModel, TimeSheetDetailListDtoModel>();
        CreateMap<TimeSheetPatchOperationDto, TimeSheetPatchOperationDomain>();
        CreateMap<TimeSheetListModel, TimeSheetListDtoModel>();
        CreateMap<UpdateTimeSheetDtoModel, UpdateTimeSheetDomainModel>();
        CreateMap<TimesheetEmployeeDetailsDtoModel, TimesheetEmployeeDetailsModel>();
        CreateMap<TimesheetEmployeeDetailsModel, TimesheetEmployeeDetailsDtoModel>();
        CreateMap<TimesheetDeleteEmployeeListModel, TimesheetDeleteEmployeeListDtoModel>();
        CreateMap<TimeSheetDetailWithCreatedTypeListDomainModel, TimeSheetDetailWithCreatedTypeListDtoModel>();
        CreateMap<EmailAndWeekDto, EmailAndWeekDomainModel>();
        CreateMap<CreateTimesheetDtoModel, Timesheet>();
        CreateMap<TimesheetTaskDtoModel, List<TimesheetDetail>>()
              .BeforeMap<MappedTimesheetDetail>();
        CreateMap<ClientWiseHoursTotalDto, ClientWiseHoursTotal>();
        CreateMap<TimesheetStatusDtoModel, TimesheetStatusDomainModel>().ReverseMap();
        CreateMap<ManagerAndApproverDtoModel, ManagerAndApproverDomainModel>().ReverseMap();


        //Logger Mapper
        CreateMap<LoggerApplicationContractsModel, LoggerModel>().ReverseMap();
        //timesheetCategorymapping
        CreateMap<TimesheetCategoryDomainModel, TimesheetCategoryDtoModel>();
        CreateMap<TimesheetCategoryDtoModel, TimesheetCategoryDomainModel>();
        CreateMap<TimesheetSubCategoryDomainModel, TimesheetSubCategoryDtoModel>();
        CreateMap<TimesheetEmployeeDomainModel, TimesheetEmployeeDtoModel>();
        CreateMap<UpdateTimeSheetDtoModel, UpdateTimeSheetDomainModel>();
        CreateMap<DashboardDomainShortCut, DashboardShortCut>();

        //Employee Book Mapper START
        CreateMap<ProjectsModel, ProjectsApplicationContractsModel>();
        CreateMap<EmployeesModel, EmployeesApplicationContractsModel>();
        CreateMap<EmployeeMasterModel, EmployeeMasterApplicationContractsModel>().ReverseMap();
        CreateMap<UserRoleModel, RoleApplicationContractsModel>();
        CreateMap<AssignedRolesModel, AssignedRolesApplicationContractsModel>();
        CreateMap<EmployeeRoleMapApplicationContractsModel, EmployeeRoleMapModel>().ReverseMap();

        // Employee Book Mapper END
        CreateMap<EmployeeTypeApplicationContractsModel, EmployeeTypeModel>().ReverseMap();
        CreateMap<TimesheetUpdateStatusDtoModel, TimesheetUpdateStatusDomain>();
        CreateMap<TimesheetSubCategoryDtoModel, TimesheetSubCategoryDomainModel>();
        CreateMap<EmployeeProject, EmployeeProjectDtoModel>();
        CreateMap<ShareIdeaModel, ShareIdeaApplicationContractsModel>().ReverseMap();
        CreateMap<ShareIdeaCategoryModel, ShareIdeaCategoryApplicationContractsModel>().ReverseMap();
        CreateMap<ShareIdeaQuestionsModel, ShareIdeaQuestionsApplicationContractsModel>().ReverseMap();
        CreateMap<GetShareIdeaCountsWithCategoryModel, GetShareIdeaCountsWithCategoryApplicationContractsModel>().ReverseMap();

        CreateMap<TimesheetApproverName, TimesheetApprovalAsignee>().ReverseMap();
        CreateMap<TimesheetApproval, TimesheetApprovalDetail>().ReverseMap();
        CreateMap<SkillSegementCategoryModel, SkillSegementCategoryApplicationContractModel>().ReverseMap();

        CreateMap<OrgColumnDomainModel, OrgColumnNameModel>().ReverseMap();
        CreateMap<OrgMasterRecordDomainModel, OrgMasterRecord>().ReverseMap();
        CreateMap<WorkModeMaster, WorkModeMasterDomainModel>().ReverseMap();
    }
}
