using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System.Net;
using System.Threading.Tasks;
using System;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.LoggerServiceInterface;

namespace BSIPL.Automation.Web.Middleware
{

    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILoggerService _loggerService;
        public ExceptionMiddleware(RequestDelegate next, ILoggerService loggerService)
        {
            _next = next;
            _loggerService = loggerService;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                await HandleExceptionAsync(context, ex, _loggerService);
            }
        }

        private static Task HandleExceptionAsync(HttpContext context, Exception exception, ILoggerService loggerService)
        {
            if (!context.Response.HasStarted)
            {
                var response = context.Response;
                ResponseModel responseObject = new ResponseModel();
                switch (exception)
                {
                    case ApplicationException ex:
                        responseObject.ResponseCode = (int)HttpStatusCode.BadRequest;
                        response.StatusCode = (int)HttpStatusCode.BadRequest;
                        responseObject.ResponseMessage = exception.Message;
                        break;
                    default:
                        responseObject.ResponseCode = (int)HttpStatusCode.InternalServerError;
                        response.StatusCode = (int)HttpStatusCode.InternalServerError;
                        responseObject.ResponseMessage = exception.Message;
                        break;

                }
                loggerService.AddLog(new ApplicationModels.LoggerApplicationContractsModel { Description = exception.Message.Replace("'", ""), LoggerType = LogEnum.Error, Source = exception.Source.ToString(), CreatedDate = DateTime.Now });
                return context.Response.WriteAsync(JsonConvert.SerializeObject(responseObject));
            }
            else
            {
                return context.Response.WriteAsync(string.Empty);
            }
        }

        public class ResponseModel
        {
            public int ResponseCode { get; set; }
            public string? ResponseMessage { get; set; }
        }
    }
}
