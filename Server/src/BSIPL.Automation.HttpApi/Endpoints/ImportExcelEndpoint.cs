using BSIPL.Automation.ImportExcel;
using BSIPL.Automation.Model;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Endpoints
{
    public static class ImportExcelEndpoint
    {
        public static WebApplication MapImportEndpoint(this WebApplication app)
        {
            var builder = new ConfigurationBuilder().SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            IConfigurationRoot configuration = builder.Build();
           
            app.MapPost("/api/org/records", async (IFormFile file, IWebHostEnvironment env, IImportExcelContract orgService) =>
            {
                try
                {
                    var uploadsFolder = Path.Combine(env.WebRootPath, "uploads");
                    if (!Directory.Exists(uploadsFolder))
                        Directory.CreateDirectory(uploadsFolder);

                    var filePath = Path.Combine(uploadsFolder, file.FileName);
                    string[] words = file.FileName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                    DateTime startDate = Convert.ToDateTime(words[2]);
                    DateTime endDate = startDate.AddDays(7);

                    await using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await file.CopyToAsync(stream);
                    }
                    var excelPackage = new ExcelPackage(new FileInfo(filePath));
                    ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                    var Leave= configuration["ImportFile:LeaveFileName"] ?? throw new InvalidOperationException();
                    var ItHours= configuration["ImportFile:HoursFileName"] ?? throw new InvalidOperationException();

                    var worksheet = words[0]=="Leave"?excelPackage.Workbook.Worksheets[Leave]: excelPackage.Workbook.Worksheets.First(x => x.Name.StartsWith(ItHours));
                    var columnData = new List<string>();
                    var rowData = new List<List<string>>();

                    foreach (var firstRowCell in worksheet.Cells[worksheet.Dimension.Start.Row, worksheet.Dimension.Start.Column, 1, worksheet.Dimension.End.Column])
                    {
                        columnData.Add(firstRowCell.Text);
                    }
                    var columnList = await orgService.SaveExcelColumnName(columnData);
                    var orgList = new List<OrgMasterRecord>();
                    // Loop through rows dynamically
                    for (int row = 2; row <= worksheet.Dimension.End.Row; row++)
                    {
                        foreach (var firstRowCell in worksheet.Cells[worksheet.Dimension.Start.Row, worksheet.Dimension.Start.Column, 1, worksheet.Dimension.End.Column])
                        {
                            int columnIndex = GetColumnIndexByName(worksheet, firstRowCell.Text);
                            var rowDataValues = worksheet.Cells[row, columnIndex].Text.ToString();
                            rowDataValues = rowDataValues.Replace("'", "''");
                            var columnId = columnList.Where(x => x.ColumnName.ToString().Trim().ToLower() == firstRowCell.Text.ToString().Trim().ToLower()).Select(x => x.ColumnNumber).FirstOrDefault();
                            rowDataValues = ((columnId == "7"|| columnId == "12") && rowDataValues == "") ? "0" : rowDataValues;
                            rowDataValues = (columnId == "0"  && rowDataValues.StartsWith("0")) ? rowDataValues.Remove(0, 1) : rowDataValues;
                            orgList.Add(new OrgMasterRecord() { ColumnValue = rowDataValues, OrgColumnId = Convert.ToInt32(columnId), RowId = row });
                        }
                    }

                    if (orgList.Count > 0)
                    {
                        var records = await orgService.SaveOrgRecords(orgList, startDate, endDate);
                        return Results.Ok(new
                        {
                            Message = $"File {file.FileName} uploaded successfully",
                            Records = records
                        });
                    }
                    else
                    {
                        // TODO: Process the columnData and rowData lists as needed
                        return Results.Ok(new
                        {
                            Message = $"File {file.FileName} uploaded successfully",
                            Columns = columnData,
                            Rows = rowData
                        });
                    }
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(ex.Message);
                }
            });


            app.MapPost("/api/ItHours", async (IFormFile file, IWebHostEnvironment env, IImportExcelContract orgService) =>
            {
                try
                {
                    var uploadsFolder = Path.Combine(env.WebRootPath, "uploads");
                    if (!Directory.Exists(uploadsFolder))
                        Directory.CreateDirectory(uploadsFolder);

                    var filePath = Path.Combine(uploadsFolder, file.FileName);
                    string[] words = file.FileName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

                    await using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await file.CopyToAsync(stream);
                    }
                    var excelPackage = new ExcelPackage(new FileInfo(filePath));
                    ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                    var ItHours = configuration["ImportFile:HoursFileName"] ?? throw new InvalidOperationException();
                    if (words[0] != "IT") { throw new InvalidOperationException(); }
                    var worksheet = excelPackage.Workbook.Worksheets.First(x => x.Name.StartsWith(ItHours));
                    var columnData = new List<string>();
                    var rowData = new List<List<string>>();

                    foreach (var firstRowCell in worksheet.Cells[worksheet.Dimension.Start.Row, worksheet.Dimension.Start.Column, 1, worksheet.Dimension.End.Column])
                    {
                        columnData.Add(firstRowCell.Text);
                    }
                    var columnList = await orgService.SaveExcelColumnName(columnData);
                    var orgList = new List<OrgMasterRecord>();
                    for (int row = 2; row <= worksheet.Dimension.End.Row; row++)
                    {
                        foreach (var firstRowCell in worksheet.Cells[worksheet.Dimension.Start.Row, worksheet.Dimension.Start.Column, 1, worksheet.Dimension.End.Column])
                        {
                            int columnIndex = GetColumnIndexByName(worksheet, firstRowCell.Text);
                            var rowDataValues = worksheet.Cells[row, columnIndex].Text.ToString();
                            rowDataValues = rowDataValues.Replace("'", "''");
                            var columnId = columnList.Where(x => x.ColumnName.ToString().Trim().ToLower() == firstRowCell.Text.ToString().Trim().ToLower()).Select(x => x.ColumnNumber).FirstOrDefault();                           
                            orgList.Add(new OrgMasterRecord() { ColumnValue = rowDataValues, OrgColumnId = Convert.ToInt32(columnId), RowId = row });
                        }                        
                    }

                    if (orgList.Count > 0)
                    {
                        var records = await orgService.SaveItHoursTable(orgList);
                        return Results.Ok(new
                        {
                            Message = $"File {file.FileName} uploaded successfully",
                            Records = records
                        });
                    }
                    else
                    {
                        // TODO: Process the columnData and rowData lists as needed
                        return Results.Ok(new
                        {
                            Message = $"File {file.FileName} uploaded successfully",
                            Columns = columnData,
                            Rows = rowData
                        });
                    }
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(ex.Message);
                }

            });         

            return app;
        }
        public static int GetColumnIndexByName(ExcelWorksheet worksheet, string columnName)
        {
            return worksheet.Cells["1:1"].First(c => c.Value.ToString() == columnName).Start.Column;
        }
    }
}

