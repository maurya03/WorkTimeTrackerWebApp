using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models
{   
    public class MailServiceModel
    {      
        public string RecipientEmail { get; set; }
        public string Status { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Subject { get; set; }
        public string StatusMessage { get; set; }
        public string DetailsLink { get; set; }
        public string EmailBodyFormat { get; set; }
        public string FooterMessage { get; set; }
        public string Remarks { get; set; }
        public string SubjectPrefix { get; set; }
    }
}
