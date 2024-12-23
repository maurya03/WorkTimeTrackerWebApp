using AutoMapper;
using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Domain.Shared.Enums;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace BSIPL.Automation.TimesheetService
{
    public class MappedTimesheetDetail : IMappingAction<TimesheetTaskDtoModel, List<TimesheetDetail>>
    {
        public void Process(TimesheetTaskDtoModel source, List<TimesheetDetail> destination, ResolutionContext context)
        {
            var hoursData = JsonConvert.DeserializeObject<Dictionary<string, string>>(source.HoursWorked);
            var days = hoursData.Keys;
            foreach (var day in days)
            {
                if (hoursData[day] != "")
                {
                    var timesheetDetail = new TimesheetDetail();
                    timesheetDetail.HoursWorked = Convert.ToDecimal(hoursData[day]);
                    timesheetDetail.DayOfWeek = DayOfWeekByName(day);
                    timesheetDetail.ProjectId = source.ProjectId;
                    timesheetDetail.TimeSheetCategoryID = source.CategoryID;
                    timesheetDetail.TimeSheetSubcategoryID = source.SubCategoryID;
                    timesheetDetail.TaskDescription = source.TaskDescription.Trim();
                    destination.Add(timesheetDetail);
                }
            }
        }
        public int DayOfWeekByName(string inputDay)
        {
            TimeSheetDayOfWeek dayEnum;

            if (Enum.TryParse(inputDay, true, out dayEnum))
            {
                return (int)dayEnum;
            }
            else
            {
                throw new InvalidCastException("Invalid day passed");
            }
        }
    }
}
