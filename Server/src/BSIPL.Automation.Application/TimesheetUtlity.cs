using BSIPL.Automation.ApplicationModels.Timesheet;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.IO;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using BSIPL.Automation.Models.Timesheet;
using iTextSharp.text.pdf;
using iTextSharp.text;
using static iTextSharp.text.pdf.AcroFields;
using Microsoft.EntityFrameworkCore.Storage;
using iTextSharp.text.pdf.draw;
using Microsoft.Extensions.Configuration;
using BSIPL.Automation.Models.SkillsMatrix;
using ScottPlot;
using static OfficeOpenXml.ExcelErrorValue;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Org.BouncyCastle.Utilities;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using OfficeOpenXml.FormulaParsing.Excel.Functions;
using ScottPlot.TickGenerators.TimeUnits;
using System.Security.Policy;
using System.Xml;
namespace BSIPL.Automation
{
    public static class TimesheetUtlity
    {
        public static TimesheetViewListDtoModel AddTimesheetDetail(TimeSheetDetailListDtoModel item)
        {
            List<int> ids = new List<int>();
            ids.Add(item.TimesheetDetailId);
            var detail = new TimesheetViewListDtoModel
            {
                StatusId = item.StatusId,
                CategoryName = item.CategoryName,
                TimeSheetCategoryId = item.TimeSheetCategoryId,
                SubCategoryName = item.SubCategoryName,
                TimeSheetSubCategoryId = item.TimeSheetSubCategoryId,
                ProjectId = item.ProjectId,
                ProjectName = item.ProjectName,
                TaskDescription = item.TaskDescription,
                TimesheetDetailId = ids,
                Sun = (item.DayOfWeek == 1 ? item.HoursWorked.ToString() : ""),
                Mon = (item.DayOfWeek == 2 ? item.HoursWorked.ToString() : ""),
                Tue = (item.DayOfWeek == 3 ? item.HoursWorked.ToString() : ""),
                Wed = (item.DayOfWeek == 4 ? item.HoursWorked.ToString() : ""),
                Thu = (item.DayOfWeek == 5 ? item.HoursWorked.ToString() : ""),
                Fri = (item.DayOfWeek == 6 ? item.HoursWorked.ToString() : ""),
                Sat = (item.DayOfWeek == 7 ? item.HoursWorked.ToString() : "")
            };
            return detail;
        }
        public static string GetFilePath(string type)
        {
            var builder = new ConfigurationBuilder().SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            IConfigurationRoot configuration = builder.Build();
            string filePath = "";
            if (type == "excel")
            {
                filePath = configuration.GetSection("ReportSettings:ExcelFilePath").Value;
            }
            else
            {
                filePath = configuration.GetSection("ReportSettings:PdfFilePath").Value;
            }

            if (!Directory.Exists(filePath))
            {
                Directory.CreateDirectory(filePath);
            }
            return filePath;
        }
        public static byte[] ExportToExcel(IList<TimesheetExcelSummaryDomainModel> dataList, DateTime startDate, DateTime endDate, bool isExcelButtonClick, string reportType)
        {
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            ExcelPackage excelPackage = new ExcelPackage();
            ExcelWorksheet worksheet = excelPackage.Workbook.Worksheets.Add("TimesheetData");
            worksheet.Cells[1, 1].Value = "Employee Name";
            worksheet.Cells[1, 2].Value = "Project";
            worksheet.Cells[1, 3].Value = "Period";
            worksheet.Cells[1, 4].Value = "Total Hours";
            worksheet.Cells[1, 5].Value = "Status";
            int rowNum = 2;
            foreach (var item in dataList)
            {
                worksheet.Cells[rowNum, 1].Value = item.EmployeeName;
                worksheet.Cells[rowNum, 2].Value = item.Project;
                worksheet.Cells[rowNum, 3].Value = item.Period;
                worksheet.Cells[rowNum, 4].Value = item.TotalHours;
                worksheet.Cells[rowNum, 5].Value = item.Status;
                rowNum++;

            }
            worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
            byte[] excelBytes = excelPackage.GetAsByteArray();
            if (isExcelButtonClick == true)
            {
                return excelBytes;
            }
            else
            {
                string basePath = GetFilePath("excel");
                string downloadLocation = reportType == "Week" ? @"" + basePath + "\\" + "TS_WSR_WKEnding" + endDate.ToString("MMdd") + ".xlsx" :
                        @"" + basePath + "\\" + "TS_MSR_Month_" + String.Format("{0:MMMM}", DateTime.Now.AddMonths(-1)) + ".xlsx";
                File.WriteAllBytes(downloadLocation, excelBytes);
                return [];
            }
        }
        public static DateTime GetFirstSunday(int year, int month)
        {
            DateTime firstDayofMonth = new DateTime(year, month, 1);
            return firstDayofMonth.AddDays(-(int)firstDayofMonth.DayOfWeek);

        }
        public static DateTime GetLastSaturday(int year, int month)
        {
            DateTime lastDayOfMonth = new DateTime(year, month, DateTime.DaysInMonth(year, month));
            int daysUnitlSaturday = ((int)DayOfWeek.Saturday - (int)lastDayOfMonth.DayOfWeek - 7) % 7;
            return lastDayOfMonth.AddDays(daysUnitlSaturday);
        }
        public static byte[] GenerateTimesheetReportPDF(IList<TimesheetReportDetails> details, DateTime startDate, DateTime endDate, int noOfWeeks, IList<ClientMasterModel> clientList, bool isPdfButtonClick, string reportType)
        {
            float pageWidth = PageSize.A3.Rotate().Width - 100;
            float pageHeight = PageSize.A3.Rotate().Height + 100;
            IList<TimesheetEffortSummary> timesheetEffortSummariesForGA = new List<TimesheetEffortSummary>();
            timesheetEffortSummariesForGA = details.Where(detail => detail.clientId == 46).Select(summary => summary.TimesheetEffortSummary).FirstOrDefault();
            Document doc = new Document(new Rectangle(pageWidth, pageHeight));
            ScottPlot.Plot myPlot = new();
            ScottPlot.Palettes.Category10 palette = new();
            int si = 1;
            List<Tick> barGraphTicks = new List<Tick>();
            List<Coordinates> TimesheetExpectedHours = new List<Coordinates>();
            List<Coordinates> TimesheetActualHoursGraph = new List<Coordinates>();

            myPlot.Axes.Left.Label.Text = "Expected and Actual Hours";
            List<double> EmployeeCountClientWise = new List<double>();
            List<double> TimesheetHoursClientWise = new List<double>();
            List<double> LeaveHoursClientWise = new List<double>();
            List<double> TimesheetProductiveHoursClientWise = new List<double>();
            List<double> ProductiveHoursAvgClientWise = new List<double>();
            List<double> ExpectedHoursClientWise = new List<double>();
            List<double> TimesheetSubmittedClientWise = new List<double>();
            List<double> TotalExpectedHoursClientWise = new List<double>();
            List<double> TotalWeekendHours = new List<double>();
            List<double> TotalIdleTime = new List<double>();
            MemoryStream memoryStream = new MemoryStream();
            try
            {
                foreach (var report in details)
                {
                    if (report.clientId <= 0) continue;
                    int baseIndex = si + 1;
                    decimal TimesheetHours = 0;
                    decimal EmployeeCount = 0;
                    decimal LeaveHours = 0;
                    double timesheetSubmittedPeople = 0;
                    decimal TimesheetProductiveHours = 0;
                    //double ExpectedHours = 0;
                    decimal TotalExpectedHours = 0;
                    decimal WeekendHours = 0;
                    decimal IdleTime = 0;

                    List<decimal> ValuesOfBars = new List<decimal>();
                    foreach (var item in report.TimesheetEffortSummary)
                    {
                        TimesheetHours += item.TSActualHours;
                        EmployeeCount += item.EmployeeCount;
                        LeaveHours += item.LeaveHours;
                        timesheetSubmittedPeople += item.TimesheetSubmitted;
                        TimesheetProductiveHours += item.TSProdHours;
                        //ExpectedHours += item.ExpectedHours;
                        WeekendHours += item.WeekEndHour;
                        IdleTime += 0; // Need to fetch it from DB
                        TotalExpectedHours += item.TSExpectedHours;

                    }
                    double AvgExpectedHours = TotalExpectedHours != 0 ? (double)(TotalExpectedHours / EmployeeCount) : 0;
                    TimesheetProductiveHours = TimesheetHours - LeaveHours;
                    if (Double.IsNaN(AvgExpectedHours))
                    {
                        AvgExpectedHours = 0;
                    }
                    ValuesOfBars.Add(EmployeeCount * 40);

                    ValuesOfBars.Add(TimesheetHours);

                    ValuesOfBars.Add(LeaveHours);

                    ValuesOfBars.Add(WeekendHours);
                    int j = 1;
                    foreach (var barValue in ValuesOfBars)
                    {
                        ScottPlot.Bar bar = new()
                        {
                            Value = Convert.ToDouble(barValue),
                            FillColor = palette.GetColor(j),
                            Position = si,

                        };
                        bar.Label = Convert.ToInt32(barValue).ToString();
                        var bars = myPlot.Add.Bar(bar);
                        bars.Axes.YAxis = myPlot.Axes.Right;
                        si++;
                        j++;

                    }



                    barGraphTicks.Add(new Tick(position: baseIndex, label: report.clientName));
                    TimesheetExpectedHours.Add(new Coordinates(baseIndex, AvgExpectedHours));
                    double AvgHours = Math.Round(Convert.ToDouble(Convert.ToDouble(TimesheetProductiveHours) / Convert.ToDouble(EmployeeCount)));
                    if (Double.IsNaN(AvgHours))
                    {
                        AvgHours = 0;
                    }
                    TimesheetActualHoursGraph.Add(new Coordinates(baseIndex, AvgHours));
                    si++;
                    EmployeeCountClientWise.Add(Convert.ToDouble(EmployeeCount));
                    TimesheetHoursClientWise.Add(Convert.ToDouble(TimesheetHours));
                    LeaveHoursClientWise.Add(Convert.ToDouble(LeaveHours));
                    TimesheetProductiveHoursClientWise.Add(Convert.ToDouble(TimesheetProductiveHours));
                    ProductiveHoursAvgClientWise.Add(AvgHours);

                    ExpectedHoursClientWise.Add(AvgExpectedHours);
                    TimesheetSubmittedClientWise.Add(timesheetSubmittedPeople);
                    TotalExpectedHoursClientWise.Add(Convert.ToDouble(TotalExpectedHours));
                    TotalWeekendHours.Add(Convert.ToDouble(WeekendHours));
                    TotalIdleTime.Add(Convert.ToDouble(IdleTime));

                }
                Coordinates[] pp =
                {
                new Coordinates(0,0)
            };
                myPlot.Add.Scatter(pp);

                var TimesheetExpectedHoursScatterGraph = myPlot.Add.Scatter(TimesheetExpectedHours);
                TimesheetExpectedHoursScatterGraph.Color = palette.GetColor(4);
                var TimesheetActualHoursScatterGraph = myPlot.Add.Scatter(TimesheetActualHoursGraph);
                TimesheetActualHoursScatterGraph.Color = palette.GetColor(5);
                myPlot.Axes.Bottom.TickGenerator = new ScottPlot.TickGenerators.NumericManual(barGraphTicks.ToArray());

                myPlot.Axes.Bottom.MajorTickStyle.Length = 0;

                myPlot.HideGrid();

                myPlot.Axes.Margins(bottom: 0);
                LegendItem item1 = new() { LabelText = "Expected Hours", FillColor = palette.GetColor(1) };
                myPlot.Legend.ManualItems.Add(item1);
                LegendItem item2 = new() { LabelText = "Timesheet Hours", FillColor = palette.GetColor(2) };
                myPlot.Legend.ManualItems.Add(item2);
                LegendItem item3 = new() { LabelText = "Leave Hours", FillColor = palette.GetColor(3) };
                myPlot.Legend.ManualItems.Add(item3);
                LegendItem item4 = new() { LabelText = "Weekend Hours", FillColor = palette.GetColor(4) };
                myPlot.Legend.ManualItems.Add(item4);
                LegendItem item5 = new() { LabelText = "Productive Avg Hours", FillColor = palette.GetColor(5) };
                myPlot.Legend.ManualItems.Add(item5);
                LegendItem item6 = new() { LabelText = "Expected Avg Hours", FillColor = palette.GetColor(6) };
                myPlot.Legend.ManualItems.Add(item6);
                myPlot.Legend.Orientation = Orientation.Horizontal;
                myPlot.ShowLegend(Alignment.UpperCenter);
                myPlot.Axes.Margins(bottom: 0, top: .3);
                myPlot.SavePng("demo.png", 1030, 340);
                PdfWriter Write;
                if (isPdfButtonClick == true)
                {
                    Write = PdfWriter.GetInstance(doc, memoryStream);
                }
                else
                {
                    string basePath = GetFilePath("pdf");
                    string outputPath = reportType == "Week" ? @"" + basePath + "\\" + "TS_WSR_WKEnding" + endDate.ToString("MMdd") + ".pdf" :
                            @"" + basePath + "\\" + "TS_MSR_Month_" + String.Format("{0:MMMM}", DateTime.Now.AddMonths(-1)) + ".pdf";
                    PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(outputPath, FileMode.Create));
                }
                doc.Open();
                doc.NewPage();
                Paragraph title;
                title = new Paragraph("Organization Summary (1)");
                title.Alignment = Element.ALIGN_CENTER;
                title.Font.Size = 26;
                doc.Add(title);
                LineSeparator line = new LineSeparator();
                line.LineWidth = 2.5f;
                line.LineColor = new BaseColor(173, 216, 230);
                Chunk linebreak = new Chunk(line);
                doc.Add(linebreak);
                string dateParagraph = "Organization Timesheet Summary: " + startDate.ToString("d MMM") + " - " + endDate.ToString("d MMM,yyyy") + "";
                Paragraph date = new Paragraph(dateParagraph);
                date.Alignment = Element.ALIGN_CENTER;
                date.Font.Size = 16;
                date.SpacingAfter = 10f;
                doc.Add(date);
                Paragraph Space = new Paragraph("\n");
                Space.Alignment = Element.ALIGN_CENTER;
                Space.Font.Size = 16;
                Space.SpacingAfter = 10f;
                doc.Add(Space);
                doc.Add(iTextSharp.text.Image.GetInstance("demo.png"));
                Font cellFont = FontFactory.GetFont(FontFactory.HELVETICA, 12);
                Font boldFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12);
                Font tableHeaderFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 13);
                PdfPTable TableForFirstPage = GetTableForFirstPage(boldFont, cellFont, tableHeaderFont, TotalExpectedHoursClientWise, ProductiveHoursAvgClientWise, clientList, EmployeeCountClientWise, TimesheetHoursClientWise, LeaveHoursClientWise, TimesheetProductiveHoursClientWise, ExpectedHoursClientWise, TimesheetSubmittedClientWise, TotalWeekendHours);
                doc.Add(TableForFirstPage);
                doc.NewPage();
                title = new Paragraph("Organization Summary(2)");
                title.Alignment = Element.ALIGN_CENTER;
                title.Font.Size = 26;
                doc.Add(title);
                line = new LineSeparator();
                line.LineWidth = 2.5f;
                line.LineColor = new BaseColor(173, 216, 230);
                linebreak = new Chunk(line);
                doc.Add(linebreak);
                dateParagraph = "Organization Timesheet Summary: " + startDate.ToString("d MMM") + " - " + endDate.ToString("d MMM,yyyy") + "";
                date = new Paragraph(dateParagraph);
                date.Alignment = Element.ALIGN_CENTER;
                date.Font.Size = 16;
                date.SpacingAfter = 10f;
                doc.Add(date);

                PdfPTable TableForSecondPage = GetTableForSecondPage(boldFont, cellFont, tableHeaderFont, timesheetEffortSummariesForGA, TotalExpectedHoursClientWise, clientList, EmployeeCountClientWise, TimesheetHoursClientWise, LeaveHoursClientWise, TimesheetProductiveHoursClientWise, ExpectedHoursClientWise, TimesheetSubmittedClientWise, TotalWeekendHours, TotalIdleTime);
                doc.Add(TableForSecondPage);
                try
                {
                    foreach (var report in details)
                    {
                        doc.NewPage();
                        // int totalHeadCount = 0;
                        //double prodHoursTotalPercent = 0;
                        //double utilisationPer = 0;
                        //foreach (var item in report.TimesheetEffortSummary)
                        //{
                        //   // totalHeadCount += item.EmployeeCount;
                        //   // prodHoursTotalPercent += item.ProdPercent;
                        //    //utilisationPer += item.UtilisationPer;
                        //}

                        //  Paragraph title;
                        if (report.clientId == 0)
                        {
                            title = new Paragraph("Engineering Effort Summary");
                        }
                        else if (report.clientId == -1)
                        {
                            title = new Paragraph("Consultant Effort Summary");
                        }
                        else
                        {
                            title = new Paragraph(report.clientName);
                        }
                        title.Alignment = Element.ALIGN_CENTER;
                        title.Font.Size = 26;
                        doc.Add(title);

                        line = new LineSeparator();
                        line.LineWidth = 2.5f;
                        line.LineColor = new BaseColor(173, 216, 230);
                        linebreak = new Chunk(line);
                        doc.Add(linebreak);
                        int utilisationPercent = 0;
                        int prodPercentage = 0;

                        PdfPTable first = GetTimesheetSummaryReport(boldFont, cellFont, tableHeaderFont, report.TimesheetEffortSummary, noOfWeeks, report.clientId, ref utilisationPercent, ref prodPercentage);
                        dateParagraph = "Timesheet Status: " + startDate.ToString("d MMM") + " - " + endDate.ToString("d MMM,yyyy") + "";
                        string utilization = "Utilization: " + utilisationPercent.ToString() + "%";
                        string productionHours = "Production Hours: " + prodPercentage.ToString() + "%";
                        date = new Paragraph(dateParagraph + "    |    " + utilization + "    |    " + productionHours);
                        date.Alignment = Element.ALIGN_LEFT;
                        date.Font.Size = 16;
                        date.SpacingAfter = 10f;
                        doc.Add(date);


                        first.SpacingAfter = 15f;
                        doc.Add(first);
                        PdfPTable noteTable = GetClientWiseEffortSummaryNote(boldFont, cellFont);

                        if (report.clientId != 46)
                        {
                            PdfPTable second = GetEffortSummaryByCategory(boldFont, cellFont, tableHeaderFont, report.TimesheetCategoryWiseEfforts);
                            second.SpacingAfter = 15f;
                            doc.Add(second);
                        }
                        if (report.clientId != -1 && report.clientId != 46)
                        {
                            PdfPTable third = GetNonProdTableForPdf(boldFont, cellFont, tableHeaderFont, report.NonProdTimesheetDetails);
                            third.SpacingAfter = 15f;
                            doc.Add(third);
                            if (report.clientId != 0) { doc.Add(noteTable); }
                        }
                        if (report.clientId == -1)
                        {
                            noteTable.SpacingBefore = 15f;
                            doc.Add(noteTable);
                        }
                        if (report.clientId == 46)
                        {
                            PdfPTable? fourth = report.timesheetFunctionWiseEfforts[0] != null ? GetEffortSummaryBySubCategory(boldFont, cellFont, tableHeaderFont, report.timesheetFunctionWiseEfforts[0], "HR") : null;
                            doc.Add(fourth);
                            doc.Add(Space);
                            PdfPTable? fifth = report.timesheetFunctionWiseEfforts[0] != null ? GetEffortSummaryBySubCategory(boldFont, cellFont, tableHeaderFont, report.timesheetFunctionWiseEfforts[1], "TA") : null;
                            doc.Add(fifth);
                            doc.Add(Space);

                            doc.NewPage();
                            title = new Paragraph("G&A Summary(2)");
                            title.Alignment = Element.ALIGN_CENTER;
                            title.Font.Size = 26;
                            doc.Add(title);

                            line = new LineSeparator();
                            line.LineWidth = 2.5f;
                            line.LineColor = new BaseColor(173, 216, 230);
                            linebreak = new Chunk(line);
                            doc.Add(linebreak);

                            PdfPTable? sixth = report.timesheetFunctionWiseEfforts[0] != null ? GetEffortSummaryBySubCategory(boldFont, cellFont, tableHeaderFont, report.timesheetFunctionWiseEfforts[2], "IT") : null;
                            doc.Add(sixth);
                            doc.Add(Space);

                            PdfPTable? seventh = report.timesheetFunctionWiseEfforts[0] != null ? GetEffortSummaryBySubCategory(boldFont, cellFont, tableHeaderFont, report.timesheetFunctionWiseEfforts[3], "Operations") : null;
                            doc.Add(seventh);
                            doc.Add(Space);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                }

                //Non Compliance Page
                doc.NewPage();
                title = new Paragraph("Non-Compliance Report");
                title.Alignment = Element.ALIGN_CENTER;
                title.Font.Size = 26;
                doc.Add(title);
                line = new LineSeparator();
                line.LineWidth = 2.5f;
                line.LineColor = new BaseColor(173, 216, 230);
                linebreak = new Chunk(line);
                doc.Add(linebreak);
                PdfPTable NonCompliance = GetTableForNonCompliance(details, boldFont, cellFont, tableHeaderFont, clientList, TimesheetSubmittedClientWise, EmployeeCountClientWise);
                doc.Add(Space);
                doc.Add(NonCompliance);

                //Project Wise Leave Data (TS vs Adrenaline)
                doc.NewPage();
                title = new Paragraph("Project Wise Leave Data (TS vs Adrenalin)");
                title.Alignment = Element.ALIGN_CENTER;
                title.Font.Size = 26;
                doc.Add(title);
                line = new LineSeparator();
                line.LineWidth = 2.5f;
                line.LineColor = new BaseColor(173, 216, 230);
                linebreak = new Chunk(line);
                doc.Add(linebreak);
                doc.Add(Space);
                PdfPTable TableForLeaveData = GetTableForLeaveData(details, boldFont, cellFont, tableHeaderFont, clientList, LeaveHoursClientWise, startDate, endDate);
                doc.Add(TableForLeaveData);

            }

            catch (DocumentException dex)
            {
                Console.WriteLine(dex.Message);
            }
            finally
            {
                doc.Close();
            }
            return memoryStream.ToArray();
        }
        private static PdfPTable GetTableForNonCompliance(IList<TimesheetReportDetails> details, Font boldFont, Font cellFont, Font tableHeaderFont, IList<ClientMasterModel> clientList, List<double> TimesheetSubmittedClientWise, List<double> EmployeeCountClientWise)
        {
            PdfPTable table = new PdfPTable(3);
            table.WidthPercentage = 50;
            PdfPCell headerCell;
            foreach (var header in new[] { "Project", "%TS Non-Compliance", "NC count " })
            {
                headerCell = new PdfPCell(new Phrase(header, tableHeaderFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 30f;
                table.AddCell(headerCell);
            }

            for (int i = 0; i < clientList.Count; i++)
            {
                if (clientList[i].Id == 48) continue;
                PdfPCell cell;
                cell = new PdfPCell(new Phrase(clientList[i].ClientName, cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                table.AddCell(cell);
                double Ncpercent = ((EmployeeCountClientWise[i] - TimesheetSubmittedClientWise[i]) *100)/ EmployeeCountClientWise[i];
                cell = new PdfPCell(new Phrase((Ncpercent>=0? Math.Round(Ncpercent, 2):0).ToString() + "%", cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase((EmployeeCountClientWise[i] - TimesheetSubmittedClientWise[i]).ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);               
            }
            return table;
        }
        private static PdfPTable GetTableForLeaveData(IList<TimesheetReportDetails> details, Font boldFont, Font cellFont, Font tableHeaderFont, IList<ClientMasterModel> clientList, List<double> LeaveHoursClientWise, DateTime startDate, DateTime endDate)
        {
            PdfPTable table = new PdfPTable(4);
            table.WidthPercentage = 100;
            PdfPCell headerCell;

            double Difference = 0;
            double LeaveHours = 0;
            double AdrenalineLeaves = 0;
            foreach (var header in new[] { "Project Name", "TS Leaves", "Adrenalin Leaves ", "Difference (TS-Adrenalin)" })
            {
                headerCell = new PdfPCell(new Phrase(header, tableHeaderFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 30f;
                table.AddCell(headerCell);
            }

            PdfPCell cell;
            for (int i = 1; i <= clientList.Count; i++)
            {
                cell = new PdfPCell(new Phrase(details[i].clientName));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase((LeaveHoursClientWise[i - 1] != 0 ? LeaveHoursClientWise[i - 1] / 8 : 0).ToString()));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(details[i].AdrenalineLeaves.ToString()));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(((LeaveHoursClientWise[i - 1] != 0 ? LeaveHoursClientWise[i - 1] / 8 : 0) - details[i].AdrenalineLeaves).ToString()));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);

                LeaveHours += (LeaveHoursClientWise[i - 1] != 0 ? LeaveHoursClientWise[i - 1] / 8 : 0);
                AdrenalineLeaves += details[i].AdrenalineLeaves;
                Difference += (LeaveHoursClientWise[i - 1] != 0 ? LeaveHoursClientWise[i - 1] / 8 : 0) - details[i].AdrenalineLeaves;
            }
            cell = new PdfPCell(new Phrase("Total", boldFont));
            cell.FixedHeight = 20f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(cell);
            cell = new PdfPCell(new Phrase(LeaveHours.ToString(), boldFont));
            cell.FixedHeight = 20f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(cell);
            cell = new PdfPCell(new Phrase(AdrenalineLeaves.ToString(), boldFont));
            cell.FixedHeight = 20f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(cell);
            cell = new PdfPCell(new Phrase(Difference.ToString(), boldFont));
            cell.FixedHeight = 20f;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(cell);
            return table;
        }

        private static PdfPTable GetTableForFirstPage(Font boldFont, Font cellFont, Font tableHeaderFont, List<double> TotalExpectedHoursClientWise, List<double> ProductiveHoursAvgClientWise, IList<ClientMasterModel> clientList, List<double> EmployeeCountClientWise, List<double> TimesheetHoursClientWise, List<double> LeaveHoursClientWise, List<double> TimesheetProductiveHoursClientWise, List<double> ExpectedHoursClientWise, List<double> TimesheetSubmittedClientWise, List<double> TotalWeekendHours)
        {
            PdfPTable table = new PdfPTable(clientList.Count + 1);
            table.WidthPercentage = 100;
            PdfPCell headerCell;
            for (int i = 0; i < clientList.Count; i++)
            {
                if (i == 0)
                {

                    headerCell = new PdfPCell(new Phrase(""));
                    headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                    headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                    table.AddCell(headerCell);
                }
                string NameofTheClient = clientList[i].ClientName;
                string header = NameofTheClient + (NameofTheClient == "MeridianLink" ? "\n(" : " (") + TimesheetSubmittedClientWise[i] + "/" + EmployeeCountClientWise[i] + ")";
                headerCell = new PdfPCell(new Phrase(header, tableHeaderFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(headerCell);
            }
            for (int i = 0; i < clientList.Count; i++)
            {

                PdfPCell cell;
                if (i == 0)
                {
                    cell = new PdfPCell(new Phrase("Expected Hours", cellFont));
                    cell.FixedHeight = 30f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.PaddingTop = 8;
                    table.AddCell(cell);

                }
                // To compensate extra hours of Ops(Awadh)
                cell = new PdfPCell(new Phrase(Math.Round(clientList[i].ClientName == "G&A" ? TotalExpectedHoursClientWise[i] + 12 : TotalExpectedHoursClientWise[i], 2).ToString(), cellFont));
                cell.FixedHeight = 30f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 8;
                table.AddCell(cell);
            }
            for (int i = 0; i < clientList.Count; i++)
            {

                PdfPCell cell;
                if (i == 0)
                {
                    cell = new PdfPCell(new Phrase("Timesheet Hours", cellFont));
                    cell.FixedHeight = 30f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.PaddingTop = 8;
                    table.AddCell(cell);

                }
                cell = new PdfPCell(new Phrase(Math.Round(TimesheetHoursClientWise[i], 2).ToString(), cellFont));
                cell.FixedHeight = 30f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 8;
                table.AddCell(cell);
            }
            for (int i = 0; i < clientList.Count; i++)
            {

                PdfPCell cell;
                if (i == 0)
                {
                    cell = new PdfPCell(new Phrase("Leave Hours", cellFont));
                    cell.FixedHeight = 30f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.PaddingTop = 8;
                    table.AddCell(cell);

                }
                cell = new PdfPCell(new Phrase(Math.Round(LeaveHoursClientWise[i], 2).ToString(), cellFont));
                cell.FixedHeight = 30f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 8;
                table.AddCell(cell);
            }
            for (int i = 0; i < clientList.Count; i++)
            {

                PdfPCell cell;
                if (i == 0)
                {
                    cell = new PdfPCell(new Phrase("Weekend Hours", cellFont));
                    cell.FixedHeight = 30f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.PaddingTop = 8;
                    table.AddCell(cell);

                }
                cell = new PdfPCell(new Phrase(Math.Round(TotalWeekendHours[i], 2).ToString(), cellFont));
                cell.FixedHeight = 30f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 8;
                table.AddCell(cell);
            }
            for (int i = 0; i < clientList.Count; i++)
            {

                PdfPCell cell;
                if (i == 0)
                {
                    cell = new PdfPCell(new Phrase("Productive Average Hours", cellFont));
                    cell.FixedHeight = 40f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.PaddingTop = 6;
                    table.AddCell(cell);

                }
                cell = new PdfPCell(new Phrase(Math.Round(ProductiveHoursAvgClientWise[i], 2).ToString(), cellFont));
                cell.FixedHeight = 30f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 8;
                table.AddCell(cell);
            }
            for (int i = 0; i < clientList.Count; i++)
            {

                PdfPCell cell;
                if (i == 0)
                {
                    cell = new PdfPCell(new Phrase("Expected Average Hours", cellFont));
                    cell.FixedHeight = 40f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.PaddingTop = 6;
                    table.AddCell(cell);

                }
                cell = new PdfPCell(new Phrase(Math.Round(ExpectedHoursClientWise[i], 2).ToString(), cellFont));
                cell.FixedHeight = 30f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 8;
                table.AddCell(cell);
            }
            return table;

        }


        private static PdfPTable GetTableForSecondPage(Font boldFont, Font cellFont, Font tableHeaderFont, IList<TimesheetEffortSummary> timesheetEffortSummariesForGA, List<double> TotalExpectedHoursClientWise, IList<ClientMasterModel> clientList, List<double> EmployeeCountClientWise, List<double> TimesheetHoursClientWise, List<double> LeaveHoursClientWise, List<double> TimesheetProductiveHoursClientWise, List<double> ExpectedHoursClientWise, List<double> TimesheetSubmittedClientWise, List<double> TotalWeekendHours, List<double> TotalIdleTime)
        {
            PdfPTable table = new PdfPTable(9);
            table.WidthPercentage = 100;
            PdfPCell headerCell;
            double HeadCount = 0;
            double TimesheetSubmitted = 0;
            double ExpectedHours = 0;
            double TimesheetHours = 0;
            double LeaveHours = 0;
            double ProductiveHours = 0;
            double WeekendHours = 0;
            double IdleTime = 0;
            double GAHeadCount = 0;
            double GATimesheetSubmitted = 0;
            decimal GAExpectedHours = 0;
            decimal GATimesheetHours = 0;
            decimal GALeaveHours = 0;
            decimal GAProductiveHours = 0;
            decimal GAWeekendHours = 0;
            decimal GAIdleTime = 0;
            foreach (var header in new[] { "Project", "HeadCount", "Timesheet Submitted ", "Expected Hours", "Timesheet Hours", "Leave", "Idle Time", "Weekend Hours", "Productive Hours" })
            {
                headerCell = new PdfPCell(new Phrase(header, tableHeaderFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 30f;
                table.AddCell(headerCell);
            }

            for (int i = 0; i < clientList.Count; i++)
            {
                if (clientList[i].Id == 46) continue;
                PdfPCell cell;
                cell = new PdfPCell(new Phrase(clientList[i].ClientName, cellFont));
                cell.FixedHeight = clientList[i].ClientName == "MeridianLink Special" ? 30f : 20f;
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(EmployeeCountClientWise[i].ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(TimesheetSubmittedClientWise[i].ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase((TotalExpectedHoursClientWise[i]).ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(TimesheetHoursClientWise[i].ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(LeaveHoursClientWise[i].ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(TotalIdleTime[i].ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(TotalWeekendHours[i].ToString()));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(TimesheetProductiveHoursClientWise[i].ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                HeadCount += EmployeeCountClientWise[i];
                TimesheetSubmitted += TimesheetSubmittedClientWise[i];
                ExpectedHours += TotalExpectedHoursClientWise[i];
                TimesheetHours += TimesheetHoursClientWise[i];
                LeaveHours += LeaveHoursClientWise[i];
                ProductiveHours += TimesheetProductiveHoursClientWise[i];
                WeekendHours += TotalWeekendHours[i];
                IdleTime += TotalIdleTime[i];
            }
            table = SortPdfPTableByClientName(table);
            PdfPCell enggtotalCell;
            enggtotalCell = new PdfPCell(new Phrase("Engg Sub Total", boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_LEFT;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(HeadCount.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(TimesheetSubmitted.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(ExpectedHours.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(TimesheetHours.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(LeaveHours.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(IdleTime.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(WeekendHours.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);
            enggtotalCell = new PdfPCell(new Phrase(ProductiveHours.ToString(), boldFont));
            enggtotalCell.FixedHeight = 20f;
            enggtotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(enggtotalCell);

            for (int i = 0; i < timesheetEffortSummariesForGA.Count; i++)
            {
                if (timesheetEffortSummariesForGA[i].FunctionType == "Exce-PMO" || timesheetEffortSummariesForGA[i].FunctionType == "Marketing") continue;
                PdfPCell cell;
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].FunctionType, cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].EmployeeCount.ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].TimesheetSubmitted.ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                // To compensate extra hours of Ops(Awadh)
                cell = new PdfPCell(new Phrase((timesheetEffortSummariesForGA[i].FunctionType == "Ops" ?
                    timesheetEffortSummariesForGA[i].TSExpectedHours + 12 :
                    timesheetEffortSummariesForGA[i].TSExpectedHours).ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].TSActualHours.ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].LeaveHours.ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].IdleTime.ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(timesheetEffortSummariesForGA[i].WeekEndHour.ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase((timesheetEffortSummariesForGA[i].TSActualHours - timesheetEffortSummariesForGA[i].LeaveHours).ToString(), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(cell);
                GAHeadCount += timesheetEffortSummariesForGA[i].EmployeeCount;
                GATimesheetSubmitted += timesheetEffortSummariesForGA[i].TimesheetSubmitted;
                // To compensate extra hours of Ops(Awadh)
                GAExpectedHours += (timesheetEffortSummariesForGA[i].FunctionType == "Ops" ?
                    timesheetEffortSummariesForGA[i].TSExpectedHours + 12 :
                    timesheetEffortSummariesForGA[i].TSExpectedHours);
                GATimesheetHours += timesheetEffortSummariesForGA[i].TSActualHours;
                GALeaveHours += timesheetEffortSummariesForGA[i].LeaveHours;
                GAProductiveHours += (timesheetEffortSummariesForGA[i].TSActualHours - timesheetEffortSummariesForGA[i].LeaveHours);
                GAWeekendHours += timesheetEffortSummariesForGA[i].WeekEndHour;
                GAIdleTime += timesheetEffortSummariesForGA[i].IdleTime;

            }

            PdfPCell gatotalCell;
            gatotalCell = new PdfPCell(new Phrase("G&A Sub Total", boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_LEFT;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GAHeadCount.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GATimesheetSubmitted.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GAExpectedHours.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GATimesheetHours.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GALeaveHours.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GAIdleTime.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GAWeekendHours.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);
            gatotalCell = new PdfPCell(new Phrase(GAProductiveHours.ToString(), boldFont));
            gatotalCell.FixedHeight = 20f;
            gatotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(gatotalCell);

            PdfPCell grandTotalCell;
            grandTotalCell = new PdfPCell(new Phrase("Grand Total", boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_LEFT;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((HeadCount + GAHeadCount).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((TimesheetSubmitted + GATimesheetSubmitted).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((ExpectedHours + (double)GAExpectedHours).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((TimesheetHours + (double)GATimesheetHours).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((LeaveHours + (double)GALeaveHours).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((IdleTime + (double)GAIdleTime).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((WeekendHours + (double)GAWeekendHours).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            grandTotalCell = new PdfPCell(new Phrase((ProductiveHours + (double)GAProductiveHours).ToString(), boldFont));
            grandTotalCell.FixedHeight = 20f;
            grandTotalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            table.AddCell(grandTotalCell);
            return table;

        }

        private static PdfPTable GetTimesheetSummaryReport(Font boldFont, Font cellFont, Font tableHeaderFont, List<TimesheetEffortSummary> timesheetEffortSummaries, int noOfWeeks, int clientId, ref int utilizationPer, ref int productionPer)
        {
            //start of Table 1
            //Comment by Dhiraj: To Do: Below code block has to be removed. Poor progamming. Using ref variable for heacount variable in previous look could serve the purpose.
            int totalHeadCount = 0;
            foreach (var item in timesheetEffortSummaries)
            {
                if (clientId == 0 && item.FunctionType != "Dev" && item.FunctionType != "QA" && item.FunctionType != "SM" && item.FunctionType != "PMO" && item.FunctionType != "BA" && item.FunctionType != "Analyst") { continue; }
                else if (clientId == 46 && item.FunctionType == "Exce-PMO" || item.FunctionType == "Marketing")
                {
                    continue;
                }
                totalHeadCount += item.EmployeeCount;
            }
            PdfPTable table = new PdfPTable(11);
            table.WidthPercentage = 100;
            PdfPCell parentHeaderCell = new PdfPCell(new Phrase("Engineering Effort Summary( HC-" + totalHeadCount + ")", tableHeaderFont));
            parentHeaderCell.Colspan = 11;
            parentHeaderCell.HorizontalAlignment = Element.ALIGN_CENTER;
            parentHeaderCell.BackgroundColor = new BaseColor(173, 216, 230);
            parentHeaderCell.MinimumHeight = 20f;
            table.AddCell(parentHeaderCell);

            PdfPCell headerCell;
            foreach (var header in new[] { "Function", "Total Employees", "% TS Compliance", "TS Expected Hours", "TS Actual Hours", "Leave Hours", "TS Prod Hours", "TS Prod Hours %", "TS Non-Prod Hours", "IT Hours", "Utilisation(%)" })
            {
                headerCell = new PdfPCell(new Phrase(header, boldFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(headerCell);
            }

            int totalEmployeeSum = 0;
            decimal tsHoursExpectedSum = 0;
            decimal tsHoursActualSum = 0;
            decimal leaveHoursSum = 0;
            decimal tsProdHoursSum = 0;
            decimal tsNonProdHoursSum = 0;
            double tsComplianceTotal = 0;
            double prodHoursTotalPercent = 0;
            double itHoursSum = 0;
            double totalUtilisationPer = 0;
            int timesheetEffortSummaryCount = 0;

            foreach (var item in timesheetEffortSummaries)
            {
                if (clientId == 0 && item.FunctionType != "Dev" && item.FunctionType != "QA" && item.FunctionType != "SM" && item.FunctionType != "PMO" && item.FunctionType != "BA" && item.FunctionType != "Analyst") { continue; }
                else if (clientId == 46 && item.FunctionType == "Exce-PMO" || item.FunctionType == "Marketing")
                {
                    continue;
                }
                decimal actualHours = item.TSActualHours - item.LeaveHours;
                decimal prodHours = actualHours - item.TSNonProdHours;

                itHoursSum += item.ITHours;
                totalUtilisationPer += Math.Round(Convert.ToDouble(actualHours * 100 / item.TSExpectedHours), 2);
                prodHoursTotalPercent += actualHours > 0 ? Math.Round(Convert.ToDouble(prodHours * 100 / actualHours), 2) : 0;
                totalEmployeeSum += item.EmployeeCount;
                // To compensate extra hours of Ops(Awadh)
                tsHoursExpectedSum += item.FunctionType == "Ops" ? item.TSExpectedHours + 12 : item.TSExpectedHours;
                tsHoursActualSum += (actualHours);
                leaveHoursSum += item.LeaveHours;
                tsProdHoursSum += prodHours;
                tsNonProdHoursSum += item.TSNonProdHours;
                tsComplianceTotal += item.TSCompliance;
                timesheetEffortSummaryCount++;
                PdfPCell cell;
                cell = new PdfPCell(new Phrase(item.FunctionType, cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.EmployeeCount), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.TSCompliance), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                // To compensate extra hours of Ops(Awadh)
                cell = new PdfPCell(new Phrase(Convert.ToString(item.FunctionType == "Ops" ? item.TSExpectedHours + 12 : item.TSExpectedHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(actualHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.LeaveHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(prodHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(actualHours > 0 ? Math.Round(prodHours * 100 / actualHours) : 0), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.TSNonProdHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.ITHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(Math.Round(actualHours * 100 / item.TSExpectedHours)), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);


            }
            double tsComplianceAverage = Math.Round(tsComplianceTotal, 0) / timesheetEffortSummaryCount;
            int tsProdPercentAverage = (tsHoursActualSum > 0 ? (int)(tsProdHoursSum * 100 / tsHoursActualSum) : 0);
            decimal UtilisationPercentAvg = Math.Round((tsHoursActualSum * 100 / tsHoursExpectedSum), 0);

            utilizationPer = (int)UtilisationPercentAvg;
            productionPer = tsProdPercentAverage;
            PdfPCell totalCell;
            totalCell = new PdfPCell(new Phrase("Total", boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_LEFT;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(totalEmployeeSum.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(Math.Round(tsComplianceAverage, 2).ToString() + "%", boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(tsHoursExpectedSum.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(tsHoursActualSum.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(leaveHoursSum.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(Math.Round(tsProdHoursSum,2).ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(tsProdPercentAverage.ToString() + "%", boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(Math.Round(tsNonProdHoursSum,2).ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(itHoursSum.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(UtilisationPercentAvg.ToString() + "%", boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            return table;
        }
        private static PdfPTable GetEffortSummaryByCategory(Font boldFont, Font cellFont, Font tableHeaderFont, List<TimesheetCategoryWiseEfforts> timesheetCategoryWiseEfforts)
        {
            var uniqueEmployeeTypes = timesheetCategoryWiseEfforts.Select(x => x.EmployeeType).Distinct().ToList();
            PdfPTable table = new PdfPTable(uniqueEmployeeTypes.Count + 1);
            try
            {

                table.WidthPercentage = 100;
                PdfPCell parentHeader = new PdfPCell(new Phrase("Engineering Effort Summary (Category Wise)", tableHeaderFont));
                parentHeader.Colspan = uniqueEmployeeTypes.Count + 1;
                parentHeader.HorizontalAlignment = Element.ALIGN_CENTER;
                parentHeader.BackgroundColor = new BaseColor(173, 216, 230);
                parentHeader.MinimumHeight = 20f;
                table.AddCell(parentHeader);
                PdfPCell headerCell;
                headerCell = new PdfPCell(new Phrase("Category Name", boldFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 20f;
                table.AddCell(headerCell);
                Dictionary<string, decimal> totalHours = new Dictionary<string, decimal>();

                foreach (var employeeType in uniqueEmployeeTypes)
                {
                    headerCell = new PdfPCell(new Phrase($"{employeeType} (Hours with %)", boldFont));
                    headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                    headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                    headerCell.FixedHeight = 20f;
                    table.AddCell(headerCell);
                    totalHours[employeeType] = timesheetCategoryWiseEfforts.Where(x => x.EmployeeType == employeeType).Sum(x => x.Hours);
                }

                foreach (var categoryName in timesheetCategoryWiseEfforts.Select(x => x.CategoryName).Distinct())
                {
                    PdfPCell cell;
                    cell = new PdfPCell(new Phrase(categoryName, cellFont));
                    cell.HorizontalAlignment = Element.ALIGN_LEFT;
                    cell.PaddingTop = 4;
                    cell.FixedHeight = 20f;
                    cell.NoWrap = false;
                    table.AddCell(cell);
                    foreach (var employeeType in uniqueEmployeeTypes)
                    {
                        var model = timesheetCategoryWiseEfforts.FirstOrDefault(x => x.CategoryName == categoryName && x.EmployeeType == employeeType);
                        double hours = model != null ? Convert.ToDouble(model.Hours) : 0;
                        double percentage = totalHours[employeeType] != 0 ? (hours / Convert.ToDouble(totalHours[employeeType])) * 100 : 0;
                        string cellContent = $"{hours} ({percentage:F2}%)";
                        cell = new PdfPCell(new Phrase(cellContent, cellFont));
                        cell.FixedHeight = 20f;
                        cell.HorizontalAlignment = Element.ALIGN_CENTER;
                        cell.PaddingTop = 4;
                        cell.NoWrap = false;
                        table.AddCell(cell);
                    }
                }
                PdfPCell totalCell;
                totalCell = new PdfPCell(new Phrase("Total", boldFont));
                totalCell.Colspan = 1;
                totalCell.FixedHeight = 20f;
                totalCell.HorizontalAlignment = Element.ALIGN_LEFT;
                totalCell.PaddingTop = 4;
                table.AddCell(totalCell);
                foreach (var employeeType in uniqueEmployeeTypes)
                {
                    totalCell = new PdfPCell(new Phrase(totalHours[employeeType].ToString(), boldFont));
                    totalCell.FixedHeight = 20f;
                    totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
                    totalCell.PaddingTop = 4;
                    table.AddCell(totalCell);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);

            }
            return table;
        }
        private static PdfPTable GetEffortSummaryBySubCategory(Font boldFont, Font cellFont, Font tableHeaderFont, List<TimesheetSubCategoryWiseEfforts> timesheetSubCategoryWiseEfforts, string name)
        {
            var uniqueEmployeeName = timesheetSubCategoryWiseEfforts.Select(x => x.EmployeeName).Distinct().ToList();
            var uniqueSubCategory = timesheetSubCategoryWiseEfforts.Select(x => x.SubCategoryName).Distinct().ToList();
            PdfPTable table = new PdfPTable(uniqueEmployeeName.Count + 3);
            try
            {

                table.WidthPercentage = 100;
                PdfPCell parentHeader = new PdfPCell(new Phrase($"{name} Effort Summary", tableHeaderFont));
                parentHeader.Colspan = uniqueEmployeeName.Count + 3;
                parentHeader.HorizontalAlignment = Element.ALIGN_CENTER;
                parentHeader.BackgroundColor = new BaseColor(173, 216, 230);
                parentHeader.MinimumHeight = 20f;
                table.AddCell(parentHeader);
                PdfPCell headerCell;
                headerCell = new PdfPCell(new Phrase("SubCategories", boldFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 20f;
                table.AddCell(headerCell);
                Dictionary<string, decimal> totalHours = new Dictionary<string, decimal>();
                Dictionary<string, decimal> total = new Dictionary<string, decimal>();
                decimal TotalSum = 0;

                foreach (var employeeName in uniqueEmployeeName)
                {
                    headerCell = new PdfPCell(new Phrase($"{employeeName}", boldFont));
                    headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                    headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                    headerCell.FixedHeight = 20f;
                    table.AddCell(headerCell);
                    totalHours[employeeName] = timesheetSubCategoryWiseEfforts.Where(x => x.EmployeeName == employeeName).Sum(x => x.Hours);
                }
                headerCell = new PdfPCell(new Phrase("Total Hours", boldFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 20f;
                table.AddCell(headerCell);
                headerCell = new PdfPCell(new Phrase("%", boldFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 20f;
                table.AddCell(headerCell);

                foreach (var subCategory in uniqueSubCategory)
                {
                    total[subCategory] = timesheetSubCategoryWiseEfforts.Where(x => x.SubCategoryName == subCategory).Sum(x => x.Hours);

                    TotalSum += total[subCategory];
                }

                foreach (var categoryName in timesheetSubCategoryWiseEfforts.Select(x => x.SubCategoryName).Distinct())
                {
                    PdfPCell cell;
                    cell = new PdfPCell(new Phrase(categoryName, cellFont));
                    cell.HorizontalAlignment = Element.ALIGN_LEFT;
                    cell.FixedHeight = 20f;
                    cell.NoWrap = false;
                    table.AddCell(cell);
                    foreach (var employeeName in uniqueEmployeeName)
                    {
                        var model = timesheetSubCategoryWiseEfforts.FirstOrDefault(x => x.SubCategoryName == categoryName && x.EmployeeName == employeeName);
                        double hours = model != null ? Convert.ToDouble(model.Hours) : 0;

                        cell = new PdfPCell(new Phrase(hours.ToString(), cellFont));
                        cell.FixedHeight = 20f;
                        cell.HorizontalAlignment = Element.ALIGN_CENTER;
                        cell.NoWrap = false;
                        table.AddCell(cell);
                    }
                    cell = new PdfPCell(new Phrase(total[categoryName].ToString(), cellFont));
                    cell.FixedHeight = 20f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.NoWrap = false;
                    table.AddCell(cell);
                    decimal percent = total[categoryName] != 0 ? (total[categoryName] / TotalSum) * 100 : 0;
                    string cellContent = $"{percent:F2}%";
                    cell = new PdfPCell(new Phrase(cellContent, cellFont));
                    cell.FixedHeight = 20f;
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.NoWrap = false;
                    table.AddCell(cell);

                }
                PdfPCell totalCell;
                totalCell = new PdfPCell(new Phrase("Total", boldFont));
                totalCell.Colspan = 1;
                totalCell.FixedHeight = 20f;
                totalCell.HorizontalAlignment = Element.ALIGN_LEFT;
                table.AddCell(totalCell);
                foreach (var employeeName in uniqueEmployeeName)
                {
                    totalCell = new PdfPCell(new Phrase(totalHours[employeeName].ToString(), boldFont));
                    totalCell.FixedHeight = 20f;
                    totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
                    table.AddCell(totalCell);
                }
                totalCell = new PdfPCell(new Phrase(TotalSum.ToString(), boldFont));
                totalCell.FixedHeight = 20f;
                totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(totalCell);
                totalCell = new PdfPCell(new Phrase("".ToString(), boldFont));
                totalCell.FixedHeight = 20f;
                totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
                table.AddCell(totalCell);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);

            }
            return table;
        }
        private static PdfPTable GetNonProdTableForPdf(Font boldFont, Font cellFont, Font tableHeaderFont, List<NonProdTimesheetDetail> nonProdTimesheetDetails)
        {
            PdfPTable table = new PdfPTable(3);
            table.WidthPercentage = 100;
            PdfPCell parentHeader = new PdfPCell(new Phrase("Engineering TS Non-Prod Hours", tableHeaderFont));
            parentHeader.Colspan = 3;
            parentHeader.HorizontalAlignment = Element.ALIGN_CENTER;
            parentHeader.BackgroundColor = new BaseColor(173, 216, 230);
            parentHeader.MinimumHeight = 20f;
            table.AddCell(parentHeader);

            PdfPCell headerCell;
            foreach (var header in new[] { "Sub Categories", "Total Emp", "Non-Prod TS Hours" })
            {
                headerCell = new PdfPCell(new Phrase(header, boldFont));
                headerCell.BackgroundColor = new BaseColor(173, 216, 230);
                headerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                headerCell.FixedHeight = 20f;
                table.AddCell(headerCell);
            }

            int totalEmployeeNonProdSum = 0;
            decimal totalNonProdHours = 0;

            foreach (var item in nonProdTimesheetDetails)
            {
                totalEmployeeNonProdSum += item.EmployeeCount;
                totalNonProdHours += item.TSHours;
                PdfPCell cell;
                cell = new PdfPCell(new Phrase(item.SubCategory, cellFont));
                cell.HorizontalAlignment = Element.ALIGN_LEFT;
                cell.PaddingTop = 4;
                cell.NoWrap = false;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.EmployeeCount), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);
                cell = new PdfPCell(new Phrase(Convert.ToString(item.TSHours), cellFont));
                cell.FixedHeight = 20f;
                cell.HorizontalAlignment = Element.ALIGN_CENTER;
                cell.PaddingTop = 4;
                table.AddCell(cell);


            }
            PdfPCell totalCell;
            totalCell = new PdfPCell(new Phrase("Total", boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_LEFT;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(totalEmployeeNonProdSum.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            totalCell = new PdfPCell(new Phrase(totalNonProdHours.ToString(), boldFont));
            totalCell.FixedHeight = 20f;
            totalCell.HorizontalAlignment = Element.ALIGN_CENTER;
            totalCell.PaddingTop = 4;
            table.AddCell(totalCell);
            //Paragraph secondTableParagraph = new Paragraph();
            //secondTableParagraph.Alignment = Element.ALIGN_LEFT;
            //secondTableParagraph.Add(table);
            return table;
        }

        public static PdfPTable SortPdfPTableByClientName(PdfPTable table)
        {
            // Extract header row if present
            PdfPCell[] headerCells = table.GetRow(0).GetCells();

            // Extract data rows (excluding the header)
            List<PdfPCell[]> rows = new List<PdfPCell[]>();
            for (int i = 1; i < table.Rows.Count; i++)
            {
                PdfPCell[] cells = table.GetRow(i).GetCells();
                rows.Add(cells);
            }

            var sortedRows = rows.OrderBy(row => row[0].Phrase.Content).ToList();

            // Create a new PdfPTable with the same number of columns
            PdfPTable sortedTable = new PdfPTable(table.NumberOfColumns);

            // Add header row to the new table
            foreach (var headerCell in headerCells)
            {
                sortedTable.AddCell(headerCell);
            }

            // Add sorted rows to the new table
            foreach (var row in sortedRows)
            {
                foreach (var cell in row)
                {
                    sortedTable.AddCell(cell);
                }
            }
            return sortedTable;
        }

        public static PdfPTable GetClientWiseEffortSummaryNote(Font boldFont, Font cellFont)
        {
            PdfPTable noteTable = new PdfPTable(1);

            // Create the note text
            string noteTextBold = "Note: \n";
            string noteTextRegular = "1. Excluding Holiday Hours.\n" +
                              "2. TS Hours Expected (Excluding Holiday Hours).\n" +
                              "3. TS Hours Actual (Excluding Leave & Holiday Hours).\n" +
                              "4. Utilization (%) (TS Actual Hours / TS Expected Hours) & Prod Hours (%) (TS Prod Hours / TS Hours Actual).\n" +
                              "5. TS = Timesheet, NC = Non-Compliance, HC = Head Count.";

            Paragraph noteParagraph = new Paragraph();
            noteParagraph.Add(new Chunk(noteTextBold, boldFont));
            noteParagraph.Add(new Chunk(noteTextRegular, cellFont));

            // Create a cell for the note text
            PdfPCell noteCell = new PdfPCell(new Phrase(noteParagraph));
            noteCell.BackgroundColor = new BaseColor(173, 216, 230);
            noteCell.MinimumHeight = 100f;
            noteCell.Padding = 10f;

            // Set the cell to span all columns.
            noteCell.Colspan = 1;
            noteCell.Border = Rectangle.BOX;
            noteCell.BorderWidth = 5f;
            noteCell.HorizontalAlignment = Element.ALIGN_LEFT;

            // Disable the border for the note cell
            noteCell.Border = Rectangle.NO_BORDER;

            // Add the note cell to the table
            noteTable.AddCell(noteCell);
            noteTable.HorizontalAlignment = Element.ALIGN_LEFT;
            noteTable.SetWidthPercentage(new float[] { 60 }, PageSize.B10);

            // Add some padding to the note cell.
            noteCell.Padding = 10f;

            return noteTable;
        }
    }
}
