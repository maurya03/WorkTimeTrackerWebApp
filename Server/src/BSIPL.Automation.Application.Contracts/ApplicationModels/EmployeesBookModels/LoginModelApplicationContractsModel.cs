using System;
using System.Collections.Generic;
using System.Net.Http.Headers;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.EmployeesBookModels
{
    public class LoginModelApplicationContractsModel
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string Token { get; set; }
        public bool IsLoginSuccessfully { get;set;}
    }
}
