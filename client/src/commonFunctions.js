import { msalConfig } from "./msalConfig";

export const handleLogin = async (instance, accounts) => {
    try {
        const request = { scopes: ["openid", "profile"] };
        await instance.loginRedirect(request);
    } catch (err) {
        console.error(err);
    }
};

export const acquireToken = async (instance, accounts, setGraphData) => {
    let accessToken = "";
    try {
        await instance
        .acquireTokenSilent({
            ...msalConfig.auth.scopes,
            account: accounts[0]
        })
        .then(response => {
            accessToken = response.accessToken;
            localStorage.setItem("accessToken", response.accessToken);
            localStorage.setItem("userEmailId", response.account.username);
        });
    } catch(err){
        const redirectRequest = {
            ...msalConfig.auth.scopes,
            prompt: 'login',
          };
        await instance.acquireTokenRedirect(redirectRequest);
    }

    return accessToken;
};
export const handleScrollToTop = async formContainerRef => {
  if (formContainerRef.current) {
      formContainerRef.current.scrollTop = 0;
  }
};
