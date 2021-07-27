import axios from "axios";
import authHeader from "./auth-header";

const API_URL = "http://api.localhost/";

class UserService {
  getUserBoard() {
    return axios.get(API_URL + "user", { headers: authHeader() });
  }
}

export default new UserService();
