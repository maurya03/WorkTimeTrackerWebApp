using BSIPL.Automation.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;

using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;

using BSIPL.Automation.EmployeesBookServiceInterface;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using BSIPL.Automation.EmployeesBookRepoInterface;
using BSIPL.Automation.Domain.Shared.Enum.EmployeesBookEnum;
using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.Models.EmployeesBookModels;
using BSIPL.Automation.Models;
using System.IO;
using System.DirectoryServices.AccountManagement;
using System.Net.Http;
using System.Text;
using Newtonsoft.Json.Linq;
using System;
using Google.Analytics.Data.V1Beta;
using Microsoft.Extensions.Configuration;
using BSIPL.Automation.LoggerServiceInterface;
using BSIPL.Automation.Domain.Shared.Enum;
using Volo.Abp.Caching;
using Microsoft.Extensions.Caching.Distributed;

namespace BSIPL.Automation.EmployeesBookService
{
    public class EmployeesBookService : IEmployeesBookService
    {
        private readonly IDistributedCache<byte[], string> _cache;
        private readonly IDistributedCache<IList<ProjectsApplicationContractsModel>, string> _cacheProject;

        private readonly IEmployeesBookRepository employeesBookRepository;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper { get; }

        private readonly IConfiguration configuration;
        private readonly ILoggerService loggerService;

        public EmployeesBookService(IEmployeesBookRepository employeeBookRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper, ILoggerService _loggerService, IConfiguration _configuration, IDistributedCache<byte[], string> cache, IDistributedCache<IList<ProjectsApplicationContractsModel>, string> cacheProject)
        {
            configuration = _configuration;
            employeesBookRepository = employeeBookRepository;
            this.objectMapper = objectMapper;
            loggerService = _loggerService;
            _cache = cache;
            _cacheProject = cacheProject;
        }

        public async Task<IList<ProjectsApplicationContractsModel>> GetProjectListAsync()
        {
            var result = await employeesBookRepository.GetProjectListAsync();
            var objProjectsContractModel = objectMapper.Map<IList<ProjectsModel>, IList<ProjectsApplicationContractsModel>>(result);
            return objProjectsContractModel;
        }
        public async Task<IList<ProjectsApplicationContractsModel>> GetProjectListByEmailAsync(string emailId)
        {
            
            return await _cacheProject.GetOrAddAsync(
                   emailId, async () =>
                   {
                       var result = await employeesBookRepository.GetProjectListByEmailAsync(emailId);
                       var objProjectsContractModel = objectMapper.Map<IList<ProjectsModel>, IList<ProjectsApplicationContractsModel>>(result);
                       return objProjectsContractModel;

                   },
                   () => new DistributedCacheEntryOptions
                   {
                       AbsoluteExpiration = DateTimeOffset.Now.AddHours(configuration.GetValue<int>("EnvironmentPath:SlidingExpirationTimeInHour"))
                   }
               );
        }

        public async Task<ProjectsApplicationContractsModel> GetProjectByIdAsync(int id)
        {
            var result = await employeesBookRepository.GetProjectByIdAsync(id);
            var projectsMapperObject = objectMapper.Map<ProjectsModel, ProjectsApplicationContractsModel>(result);

            return projectsMapperObject;
        }

        private string GetImageURl(string imageName)
        {
            var imageBasePath = configuration.GetValue<string>("EnvironmentPath:EmpImagePath");
            return $"{imageBasePath}/{imageName}";
        }

        private byte[] GetByteImage(string fileName)
        {

            if (!string.IsNullOrEmpty(fileName))
            {

                return _cache.GetOrAdd(
                    fileName, () =>
                    {
                        string path = $"{Directory.GetCurrentDirectory()}{@"\wwwroot\img_empbook\"}{fileName}";
                        if (File.Exists(path))
                        {
                            return File.ReadAllBytes(path);
                        }
                        return [];
                    },
                    () => new DistributedCacheEntryOptions
                    {
                        AbsoluteExpiration = DateTimeOffset.Now.AddHours(configuration.GetValue<int>("EnvironmentPath:SlidingExpirationTimeInHour"))
                    }
                );
               
            }
            return [];
        }

        public async Task<EmployeeSearchContractsModel> GetEmployeesWithSearchListAsync(int projectId, string interests, string sortBy, string searchText, int page, int pageSize, string emailId)
        {
            var result = await employeesBookRepository.GetEmployeesWithSearchListAsync(projectId, interests, sortBy, searchText, page, pageSize, emailId);
            foreach (var item in result.EmployeeList)
            {
                item.ProfilePictureUrl = GetImageURl(item.ProfilePictureUrl);
            }
            return result;
          
        }

        public async Task<EmployeeMasterApplicationContractsModel> GetEmployeeDetailByIdAsync(string employeeId)
        {
            var result = await employeesBookRepository.GetEmployeeDetailByIdAsync(employeeId);
            if (result != null)
            {
                result.ProfilePictureUrl = GetImageURl(result.ProfilePictureUrl);
            }
            var employeeMapperObject = objectMapper.Map<EmployeeMasterModel, EmployeeMasterApplicationContractsModel>(result);
            if (employeeMapperObject != null && employeeMapperObject.ExperienceYear == 0)
            {
                employeeMapperObject.ExperienceYear = null;
            }
            return employeeMapperObject;
        }
        public async Task<EmployeeMasterApplicationContractsModel> GetUpdatedEmployeeDetailByIdAsync(string employeeId)
        {
            var result = await employeesBookRepository.GetUpdatedEmployeeDetailByIdAsync(employeeId);
            if (result != null)
            {
                result.ProfilePictureUrl = GetImageURl(result.ProfilePictureUrl);
            }
            var employeeMapperObject = objectMapper.Map<EmployeeMasterModel, EmployeeMasterApplicationContractsModel>(result);
            if (employeeMapperObject != null && employeeMapperObject.ExperienceYear == 0)
            {
                employeeMapperObject.ExperienceYear = null;
            }
            return employeeMapperObject;
        }

        public async Task<IList<EmployeeMasterApplicationContractsModel>> GetUpdatedEmployeeDetailsAsync()
        {
            var result = await employeesBookRepository.GetUpdatedEmployeeDetailsAsync();
            var employeeMapperObject = objectMapper.Map<IList<EmployeeMasterModel>, IList<EmployeeMasterApplicationContractsModel>>(result);
            return employeeMapperObject;
        }

        public async Task<int> UpdateEmployeeDetailAsync(string employeeId, EmployeeMasterApplicationContractsModel updateEmployeeDetail)
        {
            var updateEmployeeMapperData = objectMapper.Map<EmployeeMasterApplicationContractsModel, EmployeeMasterModel>(updateEmployeeDetail);
            var result = await employeesBookRepository.UpdateEmployeeDetailAsync(employeeId, updateEmployeeMapperData);
            return result;
        }
        public async Task<int> AddEmployeeMasterUpdateAsync(EmployeeMasterApplicationContractsModel updateEmployeeDetail)
        {
            var updateEmployeeMapperData = objectMapper.Map<EmployeeMasterApplicationContractsModel, EmployeeMasterModel>(updateEmployeeDetail);
            var result = await employeesBookRepository.AddEmployeeMasterUpdateAsync(updateEmployeeMapperData);
            return result;
        }
        public async Task<int> UpdateEmployeeDetailByIdAsync(string employeeId, EmployeeMasterApplicationContractsModel employeeDetail)
        {
            var updateEmployeeMapperData = objectMapper.Map<EmployeeMasterApplicationContractsModel, EmployeeMasterModel>(employeeDetail);
            await employeesBookRepository.DeleteUpdatedEmployeeDetailByIdAsync(employeeId);
            var result = await employeesBookRepository.UpdateEmployeeDetailAsync(employeeId, updateEmployeeMapperData);
            return result;
        }

        public async Task DeleteUpdatedEmployeeDetailByIdAsync(string employeeId)
        {
            await employeesBookRepository.DeleteUpdatedEmployeeDetailByIdAsync(employeeId);
        }
        public async Task<int> DeleteEmployeeByIdAsync(string employeeId, string emailId)
        {
            return await employeesBookRepository.DeleteEmployeeByIdAsync(employeeId, emailId);
        }

        public async Task<IList<RoleApplicationContractsModel>> GetRoleListAsync()
        {
            var result = await employeesBookRepository.GetRoleListAsync();
            var objRoleContractModel = objectMapper.Map<IList<UserRoleModel>, IList<RoleApplicationContractsModel>>(result);
            return objRoleContractModel;
        }

        public async Task<AssignedRolesApplicationContractsModel> GetAssignedRoleAsync(string emailId)
        {
            var result = await employeesBookRepository.GetAssignedRoleAsync(emailId);
            var roleMapperObject = objectMapper.Map<AssignedRolesModel, AssignedRolesApplicationContractsModel>(result);
            return roleMapperObject;
        }

        public async Task<int> AddEmployeeRoleMapAsync(string emailId, EmployeeRoleMapApplicationContractsModel postEmployeeRoleMap)
        {
            var postEmployeeRoleMappingData = objectMapper.Map<EmployeeRoleMapApplicationContractsModel, EmployeeRoleMapModel>(postEmployeeRoleMap);
            var result = await employeesBookRepository.AddEmployeeRoleMapAsync(emailId, postEmployeeRoleMappingData);
            return result;
        }

        public async Task<int> AddEmployeeExcelAsync(string emailId, IList<EmployeeMasterApplicationContractsModel> postEmployeeExcel)
        {
            if (postEmployeeExcel != null && postEmployeeExcel.Count() > 0)
            {
                var result = await employeesBookRepository.AddEmployeeExcelAsync(emailId, postEmployeeExcel);
                return result;
            }
            return (int)ResponseEnum.ERROR;
        }

        public async Task<IList<EmployeeForRoleApplicationContractsModel>> GetEmployeesAsync()
        {
            return await employeesBookRepository.GetEmployeesAsync();
        }

        public async Task<IList<DesignationApplicationContractsModel>> GetDesignationsAsync()
        {
            return await employeesBookRepository.GetDesignationsAsync();
        }

        public async Task UpdateEmployeeImageUrlAsync(string employeeId, string imagePath)
        {
            await employeesBookRepository.UpdateEmployeeImageUrlAsync(employeeId, imagePath);
        }
        //decrypt Base64 password

        private string DecodeBase64Password(string encodedPassword)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(encodedPassword);
            return Encoding.UTF8.GetString(base64EncodedBytes);
        }
        public async Task<LoginModelApplicationContractsModel> LoginWindowAuth(LoginModelApplicationContractsModel model, string domain, string instance, string tenantId, string clientId, string resource, string scope, string grantType, string clientSecret)
        {
            model.Password = DecodeBase64Password(model.Password);
            var principalContext = new PrincipalContext(ContextType.Domain, domain);
            var isValidCredentials = principalContext.ValidateCredentials(model.Username.Trim(), model.Password.Trim());
            if (isValidCredentials)
            {
                model.Username = $"{model.Username.Trim()}@bhavnacorp.com";
                using (HttpClient client = new HttpClient())
                {
                    var tokenEndpoint = $"https://login.windows.net/{tenantId}/oauth2/token";
                    var accept = "application/json";

                    client.DefaultRequestHeaders.Add("Accept", accept);
                    string postBody = $"resource={resource}&client_id={clientId}&client_secret={clientSecret}&grant_type={grantType}&username={model.Username.Trim()}&password={model.Password.Trim()}&scope={scope}";
                    using (var response = await client.PostAsync(tokenEndpoint, new StringContent(postBody, Encoding.UTF8, "application/x-www-form-urlencoded")))
                    {
                        if (response.IsSuccessStatusCode)
                        {
                            var jsonresult = JObject.Parse(await response.Content.ReadAsStringAsync());
                            if (jsonresult != null)
                            {
                                model.IsLoginSuccessfully = true;
                                model.Token = (string)jsonresult["access_token"];
                                model.Password = string.Empty;

                            }
                        }
                    }
                }
            }
            return model;
        }

        public async Task<IList<AnalyticalReportsApplicationContractsModel>> GetGoogleAnalyticalReport(DateTime startDate, DateTime endDate)
        {
            string dateFormate = "yyyy-MM-dd";
            var res = new List<AnalyticalReportsApplicationContractsModel>();

            try
            {
                string propertyId = configuration.GetValue<string>("GoogleProperties:GoogleAnalyticspropertyId");
                BetaAnalyticsDataClient client = BetaAnalyticsDataClient.Create();

                RunReportRequest request = new RunReportRequest
                {
                    Property = "properties/" + propertyId,

                    Dimensions =
                {   new Dimension { Name = "city" },
                    new Dimension { Name = "country" },
                    new Dimension { Name = "audienceName" },
                    new Dimension { Name = "eventName" },
                    new Dimension { Name = "unifiedScreenName" }
                },

                    Metrics =
                {   new Metric { Name = "activeUsers" },
                    new Metric { Name = "conversions" },
                    new Metric { Name = "eventCount" },
                    new Metric { Name = "screenPageViews" }
                },

                    DateRanges = { new DateRange { StartDate = startDate.ToString(dateFormate), EndDate = endDate.ToString(dateFormate) }, },

                };

                var response = client.RunReport(request);

                foreach (Row row in response.Rows)
                {
                    var dimenList = new List<DimensionHeadersValuesApplicationContractsModelModel>();
                    var metricList = new List<MetricHeadersValuesApplicationContractModel>();


                    var analyticsResponse = new AnalyticalReportsApplicationContractsModel();

                    var dimension = row.DimensionValues.ToArray();
                    var dimensionRecord = new DimensionHeadersValuesApplicationContractsModelModel();
                    for (int i = 0; i < dimension.Length; i++)
                    {
                        getDimensionObject(i, dimensionRecord, dimension[i].Value);
                    }
                    dimenList.Add(dimensionRecord);

                    var matric = row.MetricValues.ToArray();
                    var matricRecord = new MetricHeadersValuesApplicationContractModel();
                    for (int i = 0; i < matric.Length; i++)
                    {
                        getMatricObject(i, matricRecord, Convert.ToInt32(matric[i].Value));
                    }
                    metricList.Add(matricRecord);

                    analyticsResponse.DimensionValues = dimenList;
                    analyticsResponse.MetricValues = metricList;

                    res.Add(analyticsResponse);
                }
            }
            catch (Exception ex)
            {

            }
            return await Task.FromResult((res));
        }

        public static DimensionHeadersValuesApplicationContractsModelModel getDimensionObject(int index, DimensionHeadersValuesApplicationContractsModelModel dimensionValues, string value)
        {
            switch (index)
            {
                case 0:
                    dimensionValues.City = value;
                    break;
                case 1:
                    dimensionValues.Country = value;
                    break;
                case 2:
                    dimensionValues.AudienceName = value;
                    break;
                case 3:
                    dimensionValues.EventName = value;
                    break;
                case 4:
                    dimensionValues.UnifiedScreenName = value;
                    break;
            }
            return dimensionValues;
        }

        public static MetricHeadersValuesApplicationContractModel getMatricObject(int index, MetricHeadersValuesApplicationContractModel matricValues, int value)
        {
            switch (index)
            {
                case 0:
                    matricValues.ActiveUsers = value;
                    break;
                case 1:
                    matricValues.Conversions = value;
                    break;
                case 2:
                    matricValues.EventCount = value;
                    break;
                case 3:
                    matricValues.ScreenPageViews = value;
                    break;
            }
            return matricValues;
        }

        public async Task<AnalyticsReportApplicationContractsModel> GetAnalyticsReportAsync(string filter, DateTime startDate, DateTime endDate)
        {
            return await employeesBookRepository.GetAnalyticsReportAsync(filter, startDate, endDate);
        }

        public async Task AddLogAsync(LoggerApplicationContractsModel addLogModel)
        {
            addLogModel.LoggerType = LogEnum.Basic_detail;
            addLogModel.LogFrom = LogFromEnum.EmployeeBook;
            await loggerService.AddLog(addLogModel);
        }
    }
}