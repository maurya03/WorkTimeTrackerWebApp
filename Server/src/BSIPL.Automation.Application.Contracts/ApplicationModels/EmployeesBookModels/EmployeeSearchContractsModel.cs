using System;
using System.Collections.Generic;
using System.Net.Http.Headers;
using System.Text;


namespace BSIPL.Automation.ApplicationModels.EmployeesBookModels
{
    public class EmployeeSearchContractsModel
    {
        public EmployeeSearchContractsModel()
        {
            EmployeeCount = new EmployeeCountApplicationContractsModel();
            EmployeeList = new List<EmployeeMasterApplicationContractsModel>();
        }
        public IList<EmployeeMasterApplicationContractsModel> EmployeeList { get; set; }
        public EmployeeCountApplicationContractsModel EmployeeCount { get; set; }

    }

}