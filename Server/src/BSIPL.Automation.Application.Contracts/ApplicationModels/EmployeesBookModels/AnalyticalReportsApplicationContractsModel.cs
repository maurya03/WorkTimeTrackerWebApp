using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.EmployeesBookModels
{
    public class AnalyticalReportsApplicationContractsModel
    {
        public List<DimensionHeadersValuesApplicationContractsModelModel> DimensionValues { get; set; }
        public List<MetricHeadersValuesApplicationContractModel> MetricValues { get; set; }
    }
}
