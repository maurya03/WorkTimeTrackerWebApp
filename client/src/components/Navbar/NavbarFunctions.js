import { auth_Success, user_Token } from "../../redux/common/actions";
import axios from "axios";
import Cookies from "universal-cookie";
import jwt_decode from "jwt-decode";
const cookies = new Cookies();

export const authUser = async (dispatch, userToken) => {
    try {
        const decoded = await jwt_decode(userToken);
        await axios
            .get(`https://localhost:7040/api/Emp/${decoded.Emp_id}`)
            .then(res => {
                if (res.status === 200) {
                    dispatch(auth_Success(true));
                }
            });
    } catch (error) {}
};

export const logout = async (dispatch, Emp_id) => {
    cookies.remove("my_cookie");
    await axios.delete(`https://localhost:7040/api/Emp/${Emp_id}`);
    dispatch(user_Token());
    dispatch(auth_Success(false));
    window.location = "http://localhost:3000/";
};
