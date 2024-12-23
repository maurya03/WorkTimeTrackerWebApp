using BSIPL.Automation.ApplicationModels.UserCredential;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BSIPL.Automation.Endpoints.User
{
    public static class UserEndpoints
    {
        public static WebApplication MapUserEndpoints(this WebApplication app)
        {
            var userRoute = app.MapGroup("api/v1").WithTags("User");
            _ = userRoute.MapPost("/registerUser", async ([FromServices] IUserCredentialService userService, [FromBody] LoginUserDetails userDetails) =>
            {
                await userService.AddUser(userDetails);
            });

            _ = userRoute.MapPost("/validateUser", async ([FromServices] IUserCredentialService userService, [FromBody] LoginRequest loginRequest) =>
            {
                return await userService.ValidateUser(loginRequest.Email, loginRequest.Password);
            });

            return app;
        }
    }
}
