using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.Models;
using BSIPL.Automation.RepositoryImplementation;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO.Pipelines;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;

namespace BSIPL.Automation.SkillsMatrixService
{
    public class DashboardService : IDashboardService
    {
        private readonly IDashboardRepository dashboardRepository;
        private readonly ITimeSheetRepository timesheetRepository;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper { get; }

        public DashboardService(IDashboardRepository _dashboardRepository, ITimeSheetRepository _timesheetRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper)
        {
            this.dashboardRepository = _dashboardRepository;
            this.timesheetRepository = _timesheetRepository;
            this.objectMapper = objectMapper;
        }

        public async Task<List<DashboardLineChartModel>> GetDashboardLineChartModelAsync(string clientId, string functionType)
        {
            var lineDataList = await dashboardRepository.DashboardLineData(clientId, functionType);
            var teams = lineDataList.Select(x => x.TeamName).Distinct().ToList();
            var dashboards = new List<DashboardLineChartModel>();
            foreach (var team in teams)
            {
                var dashboard = new DashboardLineChartModel();
                dashboard.Id = team;
                dashboard.Color = "#" + Guid.NewGuid().ToString().Substring(0, 6);
                var teamResult = lineDataList.Where(x => x.TeamName == team).ToList();
                var lineData = new List<LineData>();
                foreach (var item in teamResult)
                {
                    var data = new LineData()
                    {
                        X = item.CategoryName.ToString().Length > 5 ? item.CategoryName.ToString().Substring(0, 5) : item.CategoryName.ToString(),
                        Y = item.AvgScorepercentage.ToString(),
                    };
                    lineData.Add(data);
                }
                dashboard.Data = lineData;
                dashboards.Add(dashboard);
                break;
            }

            return dashboards;


        }

        public async Task<List<dynamic>> GetDashboardBarChartModelAsync(string clientId, string functionType)
        {


            var lineDataList = (await dashboardRepository.DashboardLineData(clientId, functionType)).ToList();
            var clients = lineDataList.Select(x => x.ClientName).Distinct().ToList();
            if (clients.Count > 1)
            {
                return GetDashBoardChartModelTeamWise(lineDataList, functionType);
            }
            else
            {
                return GetDashBoardChartModelTeamWise(lineDataList,functionType);
            }
        }

        private static List<dynamic> GetDashBoardChartModelTeamWise(List<dynamic> lineDataList, string functionType)
        {
            var teams = lineDataList.Select(x => x.TeamName).Distinct().ToList();
            var response = new List<dynamic>();
            foreach (var team in teams)
            {
                dynamic expando = new ExpandoObject();
                expando.TeamName = team;
                var teamResult = lineDataList.Where(x => x.TeamName == team).ToList();
                var employeeCount = teamResult.Max(x => x.employeeCount);
                foreach (var item in teamResult)
                {
                    ((IDictionary<String, object>)expando)[item.CategoryName] = item.AvgScorepercentage;

                }
                ((IDictionary<String, object>)expando)["EmployeeCount"] = employeeCount;
                response.Add(expando);
            }
            return response;
        }

        public async Task<List<dynamic>> GetDashboardBarDataTeamWiseAsync(string clientId, string teamName, string chartType, string functionType)
        {
            var response = new List<dynamic>();

            var barDataList = (await dashboardRepository.DashboardBarDataTeamWise(clientId, teamName,functionType)).ToList();
            var employeeNames = barDataList.Select(x => x.EmployeeName).Distinct().ToList();
            foreach (var employee in employeeNames)
            {
                dynamic expando = new ExpandoObject();
                expando.TeamName = employee;
                var teamResult = barDataList.Where(x => x.EmployeeName == employee).ToList();
                foreach (var item in teamResult)
                {
                    ((IDictionary<String, object>)expando)[item.CategoryName] = chartType == "TeamWise" ? item.AvgScorepercentage : item.employeeScore;

                }
                response.Add(expando);
            }
            return response;
        }

        public async Task<IList<DashboardShortCut>> GetDashboardBoxDataAsync(string clientId, string startRange, string endRange, string functionType)
        {
            var shortCutList = await dashboardRepository.DashboardShortCut(clientId, startRange, endRange,functionType);
            var dashBoardData = objectMapper.Map<IList<DashboardDomainShortCut>, IList<DashboardShortCut>>(shortCutList);
            return dashBoardData;
        }

        public async Task<List<dynamic>> GetDashboardBarChartModelCategoryWiseAsync(string clientId, string functionType)
        {
            var response = new List<dynamic>();

            var lineDataList = (await dashboardRepository.DashboardLineData(clientId, functionType)).ToList();
            var CategoryList = lineDataList.Select(x => x.CategoryName).Distinct().ToList();
            foreach (var Category in CategoryList)
            {
                dynamic expando = new ExpandoObject();
                expando.CategoryName = Category;
                var teamResult = lineDataList.Where(x => x.CategoryName == Category).ToList();
                foreach (var item in teamResult)
                {
                    ((IDictionary<String, object>)expando)[item.TeamName] = item.AvgScorepercentage;

                }
                response.Add(expando);
            }
            return response;
        }

        public async Task<List<dynamic>> GetDashboardBarChartCategoryTeamWiseScoreAsync(string clientId,string functionType)
        {
            var response = new List<dynamic>();
            var responseClient = new List<dynamic>();
           
            var lineDataList = (await dashboardRepository.DashboardLineData(clientId,functionType)).ToList();
           
            var clients = lineDataList.Select(x => x.ClientName).Distinct().ToList();
            foreach (var client in clients)
            {
                dynamic expandoClients = new ExpandoObject();
                var responseWithTeam = new List<dynamic>();
                var teams = lineDataList.Where(x=>x.ClientName == client).Select(x => x.TeamName).Distinct().ToList();
                foreach (var team in teams)
                {
                    var teamId = lineDataList.FirstOrDefault(x => x.TeamName == team)?.TeamId;
                    if (teamId == null)
                    {
                        continue;
                    }
                    var employeeList = await timesheetRepository.GetEmployeeDetailsByTeamIdAsync(teamId);
                    dynamic expando = new ExpandoObject();
                    expando.TeamName = team;

                    var teamResult = lineDataList.Where(x => x.TeamName == team).ToList();
                    var employeeCount= employeeList.Count;
                    var sum = teamResult.Sum(x => Convert.ToInt16(x.AvgScorepercentage));

                    ((IDictionary<String, object>)expando)["Score"] = sum / teamResult.Count;
                    ((IDictionary<String, object>)expando)["EmployeeCount"] = employeeCount;
                    response.Add(expando);
                    responseWithTeam.Add(expando);
                }
                expandoClients.TeamName = client;
                
                ((IDictionary<String, object>)expandoClients)["Score"] = responseWithTeam.Sum(item => item.Score) / responseWithTeam.Count;
                ((IDictionary<String, object>)expandoClients)["EmployeeCount"] = responseWithTeam.Sum(item => item.EmployeeCount);
                responseClient.Add(expandoClients);
            }
            if (clientId == "0")
            {
                return responseClient;
            }
            return response;
        }

        public async Task<List<DashboardLineChartModel>> GetDashboardLineChartTrendEmployeeAsync(string clientId, string teamId, string bhavnaEmployeeId, string functionType)
        {
            var lineDataEmployeeList = await dashboardRepository.DashboardLineDataTrendEmployeeWise(clientId, teamId, bhavnaEmployeeId, functionType);
            var categoryList = new List<dynamic>();

           
            if (clientId == "0")
            {
                categoryList = lineDataEmployeeList.Select(x => x.ClientName).Distinct().ToList();
            }
            else if ((clientId != "0" && teamId == "0") || (teamId != "0" && bhavnaEmployeeId == "0"))
            {
                categoryList = lineDataEmployeeList.Select(x => x.TeamName).Distinct().ToList();
            }
            else if (bhavnaEmployeeId != "0")
            {
                categoryList = lineDataEmployeeList.Select(x =>  x.EmployeeName).Distinct().ToList();
            }


            var dashboards = new List<DashboardLineChartModel>();
            foreach (var category in categoryList)
            {
                var dashboard = new DashboardLineChartModel();
                dashboard.Id = category;
                dashboard.Color = "#" + Guid.NewGuid().ToString().Substring(0, 6);
                var categoryResult = new List<dynamic>();
                if (clientId == "0") {
                    categoryResult=lineDataEmployeeList.Where(x => x.ClientName == category).ToList();
                }else if ((clientId != "0" && teamId == "0") || (teamId != "0" && bhavnaEmployeeId =="0"))
                {
                    categoryResult= lineDataEmployeeList.Where(x => x.TeamName == category).ToList();
                }
                else if ( bhavnaEmployeeId != "0")
                {
                    categoryResult = lineDataEmployeeList.Where(x => x.EmployeeName == category).ToList();
                }
                var lineData = new List<LineData>();
                foreach (var item in categoryResult)
                {
                    var data = new LineData()
                    {
                        X = item.date,
                        Y = item.AvgScorepercentage.ToString(),
                    };
                    lineData.Add(data);
                }
                dashboard.Data = lineData;
                dashboards.Add(dashboard);

            }

            return dashboards;
        }

        public async Task<List<dynamic>> GetDashboardBarChartCategoryTeamWiseScoreAsync(string clientId, string teamName, string functionType)
        {
            var response = new List<dynamic>();

            var dashBoardList = (await dashboardRepository.DashboardBarDataTeamWise(clientId, teamName,functionType)).ToList(); ;
            var employees = dashBoardList.Select(x => x.EmployeeName).Distinct().ToList();
            foreach (var employee in employees)
            {
                dynamic expando = new ExpandoObject();
                expando.TeamName = employee;
                var teamResult = dashBoardList.Where(x => x.EmployeeName == employee).ToList();
                var sum = teamResult.Sum(x => Convert.ToInt16(x.AvgScorepercentage));

                ((IDictionary<String, object>)expando)["Score"] = sum / teamResult.Count;

                response.Add(expando);
            }
            return response;
        }

        public async Task<IList<DashboardShortCut>> GetDashboardBoxDataAsync(string clientId, string functionType)
        {
            var shortCutList = await dashboardRepository.DashboardShortCut(clientId, functionType);
            var dashBoardData = objectMapper.Map<IList<DashboardDomainShortCut>, IList<DashboardShortCut>>(shortCutList);
            return dashBoardData;
        }
    }
}