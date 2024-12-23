import { hot } from "react-hot-loader/root";
import React from "react";
import ReactDOM from "react-dom";
import "./theme/app.scss";
import routes from "./routes";
import reportWebVitals from "./reportWebVitals";
import { MsalProvider } from "@azure/msal-react";
import msalInstance from "./msalConfig";
import "dotenv/config";
import { BrowserRouter as Router } from "react-router-dom";

const render = Component =>
    ReactDOM.render(
        <MsalProvider instance={msalInstance}>
            <Router>
                <Component />
            </Router>
        </MsalProvider>,
        document.getElementById("root")
    );

render(hot(routes));

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
// reportWebVitals(console.log);
