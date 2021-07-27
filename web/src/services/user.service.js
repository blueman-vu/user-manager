import axios from "axios";
import authHeader from "./auth-header";

const API_URL = process.env.BACKEND_API_URL || "http://backend.localhost/";

class UserService {
  getUserBoard() {
    return axios.get(API_URL + "user", { headers: authHeader() });
  }
}

export default new UserService();
