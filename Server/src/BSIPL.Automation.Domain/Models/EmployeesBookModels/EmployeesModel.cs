using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.EmployeesBookModels
{
    public class EmployeesModel
    {
        public int EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string ProfilePictureUrl { get; set; }
        public string Designation { get; set; }
    }
}