import { PublicClientApplication } from "@azure/msal-browser";
// import config from "rootpath/appsettings.json";
import config from "Configurator";
// import config from  './config';
export const msalConfig = {
    auth: {
        clientId: config.clientId,
        authority: config.authority,
        redirectUri: config.redirectUri,
        scopes: ["User.Read"]
    },
    cache: {
        cacheLocation: config.cacheLocation,
        storeAuthStateInCookie: true
    }
};

export const graphConfig = {
    graphMeEndpoint: config.graphMeEndpoint
};

const msalInstance = new PublicClientApplication(msalConfig);

export default msalInstance;
