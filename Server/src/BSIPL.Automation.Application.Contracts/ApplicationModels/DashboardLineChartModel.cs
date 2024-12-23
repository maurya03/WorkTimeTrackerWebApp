using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels
{
    public class DashboardLineChartModel
    {
        public string Id { get; set; }
        public string Color { get; set; }
        public List<LineData> Data { get; set; }
    }

    public class LineData
    {
        public string X { get; set; }
        public String Y { get; set; }
    }
}
