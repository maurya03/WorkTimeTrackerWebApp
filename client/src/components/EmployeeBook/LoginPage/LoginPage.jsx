import React, { useState } from "react";
import css from "./LoginPage.css";
import bhavnaLogo from "rootpath/assets/bhavna-logo.png";

const LoginPage = ({ handleRegister, handleLogin }) => {
    const [isRegistering, setIsRegistering] = useState(false);
    const [email, setEmail] = useState("");
    const [name, setName] = useState("");
    const [password, setPassword] = useState("");

    const registerUserDetail = {
        Email : email,
        Password : password,
        Username : name
    };

    const loginUserDetail = {
        Email : email,
        Password : password
    };
    const handleFormSubmit = (e) => {
        e.preventDefault();
        if (isRegistering) {
            handleRegister(registerUserDetail);
        } else {
            handleLogin(loginUserDetail);
        }
    };

    return (
        <div className={css.unauthenticatedLayout}>
            <div className={css.loginDetails}>
                <div className={css.loginHeader}>
                    <span>Welcome To Application</span>
                    <img width="200px" src={bhavnaLogo} />
                </div>
                <form className={css.loginForm} onSubmit={handleFormSubmit}>
                    {isRegistering && (
                        <div className={css.inputField}>
                            <label htmlFor="name">Name</label>
                            <input
                                type="text"
                                id="name"
                                value={name}
                                onChange={(e) => setName(e.target.value)}
                                required
                            />
                        </div>
                    )}
                    <div className={css.inputField}>
                        <label htmlFor="email">Email</label>
                        <input
                            type="email"
                            id="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                        />
                    </div>
                    <div className={css.inputField}>
                        <label htmlFor="password">Password</label>
                        <input
                            type="password"
                            id="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                        />
                    </div>
                    <button type="submit" className={css.submitBtn}>
                        {isRegistering ? "Register" : "Login"}
                    </button>
                </form>
                <div
                    className={css.toggleAuth}
                    onClick={() => setIsRegistering(!isRegistering)}
                >
                    {isRegistering
                        ? "Already have an account? Login"
                        : "Don't have an account? Register"}
                </div>
            </div>
        </div>
    );
};

export default LoginPage;