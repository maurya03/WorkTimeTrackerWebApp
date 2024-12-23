using System.Threading.Tasks;
using Shouldly;
using Xunit;

namespace BSIPL.Automation.Pages;

public class Index_Tests : AutomationWebTestBase
{
    [Fact]
    public async Task Welcome_Page()
    {
        var response = await GetResponseAsStringAsync("/");
        response.ShouldNotBeNull();
    }
}
