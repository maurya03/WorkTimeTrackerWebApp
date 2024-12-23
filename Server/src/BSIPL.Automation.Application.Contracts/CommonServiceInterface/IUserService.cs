using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.ShareIdeaModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.CommonServiceInterface
{
    public interface IUserService : IApplicationService
    {
        Task<UserApplicationContractsModel> UserInfo();
    }
}
