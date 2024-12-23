using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Polly;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.Http;
using System.Net;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Tokens;
using BSIPL.Automation.EmployeesBookRepoInterface;
using BSIPL.Automation.EmployeesBookRepo;

namespace BSIPL.Automation.Web.Middleware
{
    // You may need to install the Microsoft.AspNetCore.Http.Abstractions package into your project
    public class AuthMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly IEmployeesBookRepository _employeeBookRepository;

        public AuthMiddleware(RequestDelegate next, IHttpContextAccessor contextAccessor, IEmployeesBookRepository employeeBookRepository)
        {
            _next = next;
            _contextAccessor = contextAccessor;
            _employeeBookRepository = employeeBookRepository;
        }

        private string GetEmailAddressFromToken(string token)
        {
            var email = string.Empty;
            if (!string.IsNullOrEmpty(token))
            {
                var handler = new JwtSecurityTokenHandler();
                var readToken = handler.ReadJwtToken(token);
                email = readToken.Claims.First(claim => claim.Type == "upn").Value; // By default, on Azure AD the UPN is set to [email protected] to ensure a globally unique value
            }
            return email;
        }

        public Task Invoke(HttpContext httpContext)
        {
            if (_contextAccessor.HttpContext.Request.Method == HttpMethod.Options.ToString())
            {
                return _next(httpContext);
            }
            var token = _contextAccessor.HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            if(!string.IsNullOrEmpty(token))
            {
                try
                {
                    var userEmailId = GetEmailAddressFromToken(token);
                    var EmployeeId = _employeeBookRepository.GetUserDetailByEmailIdAsync(userEmailId).Result;
                    if (!String.IsNullOrEmpty(EmployeeId))
                    {
                        httpContext.Request.Headers["emailId"] = userEmailId;
                    }
                    else
                    {
                        BaseResponse response = new BaseResponse(StatusCodes.Status401Unauthorized, "Unauthorized");
                        // You can ignore redirect
                        httpContext.Response.StatusCode = response.StatusCode;
                        httpContext.Response.ContentType = "application/json";
                        return httpContext.Response.WriteAsJsonAsync(response);
                    }
                    
                   
                }
                catch (Exception)
                {
                    BaseResponse response = new BaseResponse(StatusCodes.Status401Unauthorized, "Unauthorized");
                    // You can ignore redirect
                    httpContext.Response.StatusCode = response.StatusCode;
                    httpContext.Response.ContentType = "application/json";
                    return httpContext.Response.WriteAsJsonAsync(response);
                }
            }
            else
            {
                if (_contextAccessor.HttpContext.Request.Path.HasValue && !(_contextAccessor.HttpContext.Request.Path.Value == "/swagger/index.html" || _contextAccessor.HttpContext.Request.Path.Value == "/swagger/ui/abp.swagger.js" || _contextAccessor.HttpContext.Request.Path.Value == "/swagger/ui/abp.js" || _contextAccessor.HttpContext.Request.Path.Value == "/swagger/v1/swagger.json"))
                {
                    BaseResponse response = new BaseResponse(StatusCodes.Status401Unauthorized, "Unauthorized");
                    // You can ignore redirect
                    httpContext.Response.StatusCode = response.StatusCode;
                    httpContext.Response.ContentType = "application/json";
                    httpContext.Response.WriteAsJsonAsync(response);
                }

            }
            return _next(httpContext);
        }

        public JwtSecurityToken Validate(string token)
        {
            TokenValidationParameters validationParameters = new TokenValidationParameters
            {
                ValidateAudience = false,
                ValidateIssuer = false,
                ValidateLifetime = false
            };

            JwtSecurityTokenHandler tokendHandler = new JwtSecurityTokenHandler();

            SecurityToken jwt;
            var result = tokendHandler.ValidateToken(token, validationParameters, out jwt);
            return jwt as JwtSecurityToken;
        }

        public class BaseResponse
        {
            public BaseResponse(int statusCode, string message)
            {
                Message = message;
                StatusCode = statusCode;
            }
            public int StatusCode { get; set; }
            public string Message { get; set; }
        }
    }

    // Extension method used to add the middleware to the HTTP request pipeline.
    public static class AuthMiddlewareExtensions
    {
        public static IApplicationBuilder UseAuthMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<AuthMiddleware>();
        }
    }
}
