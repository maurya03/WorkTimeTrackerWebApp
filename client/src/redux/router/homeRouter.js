import React from "react";
import { Route } from "react-router-dom";
import { initLayout } from "../layout/actions";

const onInit = (store, { location: { query } }) => {
    for (const keys of Object.keys(query)) {
        switch (keys.toLowerCase()) {
            default:
                break;
        }
    }

    store.dispatch(initLayout());
};

export const homeRoute = (path, loader) => (
    <Route
        path={path}
        getComponents={(nextState, cb) => {
            import("../components/Test/HomeContainer")
                .then(
                    loader({
                        nextState,
                        cb,
                        main: () => import("../components/Test/HomeContainer"),
                        onInit: store => onInit(store, nextState)
                    })
                )
                .catch(console.log("errrrr"));
        }}
    />
);
