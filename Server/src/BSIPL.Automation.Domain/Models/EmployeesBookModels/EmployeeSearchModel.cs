using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace BSIPL.Automation.Models.EmployeesBookModels
{
    public class EmployeeSearchModel
    {
        public IList<EmployeesModel> EmployeeList {get;set;}

        public int TotalPages { get; set; }

        public int TotalRecords { get; set; }
    }
}