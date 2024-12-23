using System;
using System.Collections;
using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels.EmployeesBookModels
{
    public class AnalyticsReportApplicationContractsModel
    {
        public int ActiveEmployeeCount { get; set; }
        public int DailyEmployeeLoginCount { get; set; }
        public List<LoginCountApplicationContractsModel> LoginCountModel { get; set; }
    }
}